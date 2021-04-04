#include <mpi.h>
#include <iostream>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <iomanip>
#pragma comment(lib,"msmpi.lib")

#define G 6.67*pow(10, 11)
#define M 10000
#define N 256
#define MIN_DIS 0.0001
#define DELTA_T 0.0001

using namespace std;

/// <summary>
/// 全部使用国际单位制，小球初始间距0.01。
/// 由于小球不存在碰撞但可能会有质心间距极小情况，所以在此设定一个最小间距为0.0001即初始间距的1/100
/// </summary>
typedef struct ball {
	double x;         // 横坐标
	double y;         // 纵坐标
	double f_x;       // x轴受力
	double f_y;       // y轴受力
	double v_x;       // x轴速度
	double v_y;       // y轴速度
}Ball;

/// <summary>
/// F=GMM/r^2, Fx= x /sqrt(x^2+y^2) * F
/// </summary>
/// <param name="balls"></param>
/// <param name="num"></param>
void ComputeForce(Ball* balls, int num)           // 给 balls[num] 计算受力
{
	int i;
	double d_x, d_y;         // 水平 竖直距离
	double d_x_ab, d_y_ab;
	double f_x, f_y;
	f_x = 0.0;
	f_y = 0.0;
	for (i = 0; i < N; i++)
	{
		if (i == num)
			continue;
		d_x = balls[i].x - balls[num].x;
		d_y = balls[i].y - balls[num].y;
		d_x_ab = d_x >= 0 ? d_x : (-1 * d_x);
		d_y_ab = d_y >= 0 ? d_y : (-1 * d_y);
		if (d_x_ab < MIN_DIS)
		{
			if (d_x >= 0)
			{
				d_x = MIN_DIS;
			}
			else
			{
				d_x = -MIN_DIS;
			}
		}
		if (d_y_ab < MIN_DIS)
		{
			if (d_y >= 0)
			{
				d_y = MIN_DIS;
			}
			else
			{
				d_y = -MIN_DIS;
			}
		}
		f_x += G * M * M * d_x / pow(pow(d_x, 2) + pow(d_y, 2), 1.5);
		f_y += G * M * M * d_y / pow(pow(d_x, 2) + pow(d_y, 2), 1.5);
	}
	balls[num].f_x = f_x;
	balls[num].f_y = f_y;
}
/// <summary>
/// v = a*t = F * t / m
/// 设定一个最小时间 Δt , v = Σa*t
/// </summary>
/// <param name="balls"></param>
/// <param name="num"></param>
void ComputeVelocities(Ball* balls, int num)
{
	balls[num].v_x += balls[num].f_x / M * DELTA_T;
	balls[num].v_y += balls[num].f_y / M * DELTA_T;
}

/// <summary>
/// 在 Δt 时间内看作匀速运动
/// </summary>
/// <param name="balls"></param>
/// <param name="num"></param>
void ComputePositions(Ball* balls, int num)
{
	balls[num].x += balls[num].v_x * DELTA_T;
	balls[num].y += balls[num].v_y * DELTA_T;
}

int main(int argc, char* argv[])
{
	int iternum = 1000;
	int n;
	n = (int)sqrt(N);
	int i, j, k;
	double startTime, endTime, t;
	int mypid, mpi_threads_num;
	MPI_Status status;
	Ball* balls = (Ball*)malloc(256 * sizeof(Ball));
	int startPos, endPos;

	for (i = 0; i < n; i++)
	{
		for (j = 0; j < n; j++)
		{
			balls[i * n + j].x = 0.01 * i;
			balls[i * n + j].y = 0.01 * j;
			balls[i * n + j].f_x = 0;
			balls[i * n + j].f_y = 0;
			balls[i * n + j].v_x = 0;
			balls[i * n + j].v_y = 0;
		}
	}

	// MPI 初始化
	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &mypid);
	MPI_Comm_size(MPI_COMM_WORLD, &mpi_threads_num);

	startTime = MPI_Wtime();
	startPos = N * mypid / mpi_threads_num;
	endPos = N * (mypid + 1) / mpi_threads_num;

	for (k = 0; k < iternum; k++)
	{
		for (i = startPos; i < endPos; i++)
		{
			ComputeForce(balls, i);
		}
		for (i = startPos; i < endPos; i++)
		{
			ComputeVelocities(balls, i);
		}
		for (i = startPos; i < endPos; i++)
		{
			ComputePositions(balls, i);
		}
		MPI_Barrier(MPI_COMM_WORLD);

		if (mypid != 0)
		{
			// 更新的位置信息发送给 thread 0
			MPI_Send(&(balls[startPos]), 6 * (endPos - startPos + 1), MPI_DOUBLE, 0, iternum * 10 + mypid, MPI_COMM_WORLD);
		}
		else
		{
			// thread 0 接受其他 thread 发送来的信息
			for (i = 1; i < mpi_threads_num; i++)
			{
				MPI_Recv(&(balls[N * i / mpi_threads_num]), 6 * N, MPI_DOUBLE, i, iternum * 10 + i, MPI_COMM_WORLD, &status);
			}
			// 接受全部信息后广播，更新其他 thread 的位置信息
			MPI_Bcast(balls, 6 * N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
		}
		MPI_Barrier(MPI_COMM_WORLD);
	}
	endTime = MPI_Wtime();

	if (mypid == 0)
	{
		for (i = 0; i < N; i++)
		{
			cout << "小球标号: " << i << "\t";
			cout << "x: " << setprecision(4) << balls[i].x << "\t" << "y: " << balls[i].y << "\t";
			cout << "f_x: " << balls[i].f_x << "\t" << "f_y: " << balls[i].f_y << "\t";
			cout << "v_x: " << balls[i].v_x << "\t" << "v_y: " << balls[i].v_y << endl;
		}
		t = endTime - startTime;
		cout << "startPos: " << startPos << " endPos: " << endPos << endl;
		cout << "threads num:" << mpi_threads_num << endl;
		cout << "time:" << t << "s" << endl;
	}

	MPI_Finalize();
	return 0;
}
#include <mpi.h>
#include <iostream>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#pragma comment(lib,"msmpi.lib")

#define V_MAX 70
#define P 0.5
#define INFTY 10000000

using namespace std;

int move(int v, int d)
{
	if (v < d)
	{
		if (v < V_MAX) 
			v++;
	}
	else
	{
		v = d;
	}
	double r = (rand() % 100) / 100.0;
	if (r < P && v > 0)
	{
		v --;
	}
	return v;
}

int main(int argc, char* argv[])
{
	srand((int)time(0));
	int car_num = 100000, iternum = 500;
	int i, j;
	int* car_speed = (int*)malloc(sizeof(int) * car_num);          // 车速
	int* car_pos = (int*)malloc(sizeof(int) * (car_num) + 4);      // 位置
	int startpos, endpos;
	for (i = 0; i < car_num; i++)
	{
		car_pos[i] = i;
		car_speed[i] = 0;
	}
	car_pos[car_num] = INFTY;

	// FILE* fp;
	// char path[15] = "./output.txt";
	// errno_t err;
	// err = fopen_s(&fp, path, "w");

	int mypid, mpi_threads_num;
	MPI_Status status;
	double start, finish, t;
	// MPI 初始化
	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &mypid);
	MPI_Comm_size(MPI_COMM_WORLD, &mpi_threads_num);

	// 信息传递
	start = MPI_Wtime();
	startpos = mypid * car_num / mpi_threads_num;                 // 0到(线程数-1)/线程数 * car_num
	endpos = (int)((mypid + 1) * car_num / mpi_threads_num - 1);
	for (i = 0; i < iternum; i++)
	{
		// 划分
		if (mypid != 0)
		{
			// cout << "output" << (car_pos[startpos]) << endl;
			MPI_Send(&(car_pos[startpos]), 1, MPI_INT, mypid - 1, i * 10 + mypid, MPI_COMM_WORLD);
		}

		for (j = startpos; j <= endpos; j++)
		{
			car_speed[j] = move(car_speed[j], car_pos[j + 1] - car_pos[j] - 1);
			car_pos[j] += car_speed[j];
		}
		if (mypid != mpi_threads_num - 1)
		{
			MPI_Recv(&(car_pos[endpos + 1]), 1, MPI_INT, mypid + 1, i * 10 + mypid + 1, MPI_COMM_WORLD, &status);
		}
		MPI_Barrier(MPI_COMM_WORLD);
	}

	//  通过Send 将各个thread中数据集中到thread 0中
	if (mypid != 0)
	{
		MPI_Send(&(car_pos[startpos]), endpos - startpos + 1, MPI_INT, 0, 10 * iternum + mypid, MPI_COMM_WORLD);
		MPI_Send(&(car_speed[startpos]), endpos - startpos + 1, MPI_INT, 0, 10 * (iternum + 1) + mypid, MPI_COMM_WORLD);
	}
	MPI_Barrier(MPI_COMM_WORLD);

	if (mypid == 0)
	{
		for (i = 0; i < mpi_threads_num; i++)
		{
			if (i == 0)
				continue;
			MPI_Recv(&(car_pos[i * (endpos - startpos + 1)]), endpos - startpos + 1, MPI_INT, i, 10 * iternum + i, MPI_COMM_WORLD, &status);
			MPI_Recv(&(car_speed[i * (endpos - startpos + 1)]), endpos - startpos + 1, MPI_INT, i, 10 * (iternum + 1) + i, MPI_COMM_WORLD, &status);
		}
		for (i = 0; i < car_num; i++)
		{
			// fprintf(fp, "car: %d  pos: %d  speed: %d   \n", i, car_pos[i], car_speed[i]);
			cout << "car:" << i << "  pos  " << car_pos[i] << "  speed  " << car_speed[i] << endl;
		}
	}

	finish = MPI_Wtime();
	t = finish - start;
	if (mypid == 0)
	{
		printf("Time: %lfs", t);
		// printf("\nCheck in output.txt\n");
	}

	MPI_Finalize();
	free(car_pos);
	free(car_speed);
	return 0;
}
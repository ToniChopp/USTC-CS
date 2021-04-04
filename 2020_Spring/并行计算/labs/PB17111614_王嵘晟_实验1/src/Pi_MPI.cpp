#include <mpi.h>
#include <math.h>
#include <stdio.h>
#include "string.h"
#pragma comment(lib,"msmpi.lib")
inline double fx(double x)
{	
	double result;
	result = 4 / (pow(x, 2.0) + 1);
	return result;
}

int main(int argc, char* argv[])
{
	int n = 100000;
	double pi = 0, local = 0;
	double h;
	int mypid, mpi_threads_num;
	double startTime1, endTime1, startTime2, endTime2;
	double t1, t2;
	int i;
	double x;
	h = 1.0 / (double)n;

	// MPI 初始化
	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &mypid);
	MPI_Comm_size(MPI_COMM_WORLD, &mpi_threads_num);

	// 信息传递
	MPI_Bcast(&n, 1, MPI_INT, 0, MPI_COMM_WORLD);
	startTime1 = MPI_Wtime();

	// 计算质数数量并存储在本地local
	for (i = mypid + 1; i <= n; i += mpi_threads_num)
	{
		x = h * ((double)i - 0.5);
		local += fx(x);
	}

	// 归约，将各个local中数据集中到sum中
	MPI_Reduce(&local, &pi, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);
	pi *= h;
	endTime1 = MPI_Wtime();
	t1 = endTime1 - startTime1;

	if (mypid == 0)
	{
		printf("Number of threads: %d \n", mpi_threads_num);
		printf("Time:\t%f s\n", t1);
		printf("Pi:\t%.12lf\n\n", pi);
	}

	// 计算单线程时间和加速比
	pi = 0;
	startTime2 = MPI_Wtime();
	if (mypid == 0)
	{
		for (int i = 1; i <= n; i ++)
		{
			x = h * ((double)i - 0.5);
			pi += fx(x);
		}
		pi *= h;
		endTime2 = MPI_Wtime();
		t2 = endTime2 - startTime2;
		printf("Serial Computing in thread %d\n", mypid);
		printf("Time:\t%f s\n", t2);
		printf("Pi:\t%.12lf\n\n", pi);

		printf("Speedup: %f", t2 / t1);
	}
	MPI_Finalize();
	return 0;
}
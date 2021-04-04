#include <mpi.h>
#include <math.h>
#include <stdio.h>
#include "string.h"
#pragma comment(lib,"msmpi.lib")
int isPrime(int num)
{
	for (int i = 2; i <= sqrt((double)num); i++)
	{
		if (num % i == 0)
			return 1;
	}
	return 0;
}
int main(int argc, char* argv[])
{
	int n = 1000;
	int sum = 0, local = 0;
	int mypid, mpi_threads_num;
	double startTime1, endTime1, startTime2, endTime2;
	double t1, t2;

	// MPI 初始化
	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &mypid);
	MPI_Comm_size(MPI_COMM_WORLD, &mpi_threads_num);

	// 信息传递
	MPI_Bcast(&n, 1, MPI_INT, 0, MPI_COMM_WORLD);
	startTime1 = MPI_Wtime();

	// 计算质数数量并存储在本地local
	for (int i = mypid * 2 + 1; i <= n; i += mpi_threads_num * 2)
	{
		local += isPrime(i);
	}

	// 归约，将各个local中数据集中到sum中
	MPI_Reduce(&local, &sum, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);
	endTime1 = MPI_Wtime();
	t1 = endTime1 - startTime1;

	if (mypid == 0)
	{
		printf("Number of threads: %d \n", mpi_threads_num);
		printf("Time:\t%f s\n", t1);
		printf("Prime num:\t%d\n\n", sum);
	}

	// 计算单线程时间和加速比
	sum = 0;
	startTime2 = MPI_Wtime();
	if (mypid == 0)
	{
		for (int i = 1; i <= n; i += 2)
		{
			sum += isPrime(i);
		}
		endTime2 = MPI_Wtime();
		t2 = endTime2 - startTime2;
		printf("Serial Computing in thread %d\n", mypid);
		printf("Time:\t%f s\n", t2);
		printf("Prime num:\t%d\n\n", sum);

		printf("Speedup: %f", t2 / t1);
	}
	MPI_Finalize();
	return 0;
}
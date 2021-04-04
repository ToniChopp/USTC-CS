#include <mpi.h>
#include <iostream>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <fstream>
#include <algorithm>
#include <iomanip>
#pragma comment(lib,"msmpi.lib")

using namespace std;

#define THREADS 2

int CMP(const void* a, const void* b)
{
	if (*(int*)a < *(int*)b)
		return -1;
	if (*(int*)a > * (int*)b)
		return 1;
	else
		return 0;
}

void Communicate(int mypid, int mpi_threads_num, int* partitions, int* partsizes, int* array)
{
	// 存储排序结果的数组
	int* sortedSubList;
	// 根进程上相对于 recvbuf 的偏移量
	int* recvDisOffset;
	// 划分区间末尾
	int* partitionEnds;
	int* indexes;
	int* subListsSizes;
	int totalSize;
	int i, j;

	partitionEnds = (int*)malloc(mpi_threads_num * sizeof(int));
	indexes = (int*)malloc(mpi_threads_num * sizeof(int));
	indexes[0] = 0;
	totalSize = partsizes[0];

	for (i = 1; i < mpi_threads_num; i++)
	{
		totalSize += partsizes[i];
		indexes[i] = indexes[i - 1] + partsizes[i - 1];
		partitionEnds[i - 1] = indexes[i];
	}
	partitionEnds[mpi_threads_num - 1] = totalSize;

	sortedSubList = (int*)malloc(totalSize* sizeof(int));
	subListsSizes = (int*)malloc(mpi_threads_num * sizeof(int));
	recvDisOffset = (int*)malloc(mpi_threads_num * sizeof(int));

	// 归并
	for (i = 0; i < totalSize; i++)
	{
		int lowest = 100000;
		int ind = -1;
		for (j = 0; j < mpi_threads_num; j++)
		{
			if ((indexes[j] < partitionEnds[j]) && (partitions[indexes[j]] < lowest))
			{
				lowest = partitions[indexes[j]];
				ind = j;
			}
		}
		sortedSubList[i] = lowest;
		indexes[ind] += 1;
	}

	// 将各子列大小发送回 thread 0
	MPI_Gather(&totalSize, 1, MPI_INT, subListsSizes, 1, MPI_INT, 0, MPI_COMM_WORLD);

	// 计算 thread 0 上相对 recvbuf 的偏移量
	if (mypid == 0)
	{
		recvDisOffset[0] = 0;
		for (i = 1; i < mpi_threads_num; i++)
		{
			recvDisOffset[i] = subListsSizes[i - 1] + recvDisOffset[i - 1];
		}
	}

	// 将排序好的子列表发送回 thread 0
	MPI_Gatherv(sortedSubList, totalSize, MPI_INT, array, subListsSizes, recvDisOffset, MPI_INT, 0, MPI_COMM_WORLD);

	free(recvDisOffset);
	free(subListsSizes);
	free(sortedSubList);
	free(indexes);
	free(partitionEnds);
}

void PSRS(int* array, int num)
{
	int mypid, mpi_threads_num;
	int* partsizes, * newpartsizes;
	int subArraySize, startIndex, endIndex;
	int* sample, * newPartitions;
	int localN = num / THREADS;
	int step = localN / THREADS;

	MPI_Comm_size(MPI_COMM_WORLD, &mpi_threads_num);
	MPI_Comm_rank(MPI_COMM_WORLD, &mypid);

	sample = (int*)malloc(mpi_threads_num * mpi_threads_num * sizeof(int));
	partsizes = (int*)malloc(mpi_threads_num * sizeof(int));
	newpartsizes = (int*)malloc(mpi_threads_num * sizeof(int));

	for (int k = 0; k < mpi_threads_num; k++)
	{
		partsizes[k] = 0;
	}

	startIndex = mypid * num / mpi_threads_num;
	if (mpi_threads_num == (mypid + 1))
	{
		endIndex = num;
	}
	else
	{
		endIndex = (mypid + 1) * num / mpi_threads_num;
	}
	subArraySize = endIndex - startIndex;
	MPI_Barrier(MPI_COMM_WORLD);

	// 子数组局部排序
	qsort(array + startIndex, subArraySize, sizeof(array[0]), CMP);

	// 正则采样
	for (int i = 0; i < mpi_threads_num; i++)
	{
		sample[mypid * THREADS	 + i] = *(array + (mypid * localN + i * step));
	}

	int* pivot_number = (int*)malloc((mpi_threads_num - 1) * sizeof(sample[0])); //主元
	int index = 0;
	MPI_Barrier(MPI_COMM_WORLD);

	if (mypid == 0)
	{
		//对正则采样的样本进行排序
		qsort(sample, mpi_threads_num * mpi_threads_num, sizeof(sample[0]), CMP);

		// 采样排序后进行主元的选择
		for (int i = 0; i < (mpi_threads_num - 1); i++)
		{
			pivot_number[i] = sample[(((i + 1) * mpi_threads_num) + (mpi_threads_num / 2)) - 1];
		}
	}

	MPI_Bcast(pivot_number, mpi_threads_num - 1, MPI_INT, 0, MPI_COMM_WORLD);

	// 主元划分
	for (int i = 0; i < subArraySize; i++)
	{
		if (array[startIndex + i] > pivot_number[index])
		{
			index += 1;
		}
		if (index == mpi_threads_num)
		{
			partsizes[mpi_threads_num - 1] = subArraySize - i + 1;
			break;
		}
		// 划分大小自增
		partsizes[index]++;
	}
	free(pivot_number);

	int totalSize = 0;
	int* sendDisOffset = (int*)malloc(mpi_threads_num * sizeof(int));
	int* recvDisOffset = (int*)malloc(mpi_threads_num * sizeof(int));
	
	// 全局到全局的发送
	MPI_Alltoall(partsizes, 1, MPI_INT, newpartsizes, 1, MPI_INT, MPI_COMM_WORLD);

	// 计算划分的总大小，并给新划分分配空间
	for (int i = 0; i < mpi_threads_num; i++)
	{
		totalSize += newpartsizes[i];
	}
	newPartitions = (int*)malloc(totalSize * sizeof(int));

	sendDisOffset[0] = 0;
	recvDisOffset[0] = 0;
	for (int i = 1; i < mpi_threads_num; i++)
	{
		sendDisOffset[i] = partsizes[i - 1] + sendDisOffset[i - 1];
		recvDisOffset[i] = newpartsizes[i - 1] + recvDisOffset[i - 1];
	}

	//发送数据，实现n次点对点通信
	MPI_Alltoallv(&(array[startIndex]), partsizes, sendDisOffset, MPI_INT, newPartitions, newpartsizes, recvDisOffset, MPI_INT, MPI_COMM_WORLD);

	free(sendDisOffset);
	free(recvDisOffset);

	Communicate(mypid, mpi_threads_num, newPartitions, newpartsizes, array);

	if (mpi_threads_num > 1)
	{
		free(newPartitions);
	}
	free(partsizes);
	free(newpartsizes);
	free(sample);
}

int main(int argc, char* argv[])
{
	int num;
	int i;
	int mypid, mpi_threads_num;
	double startTime, endTime, t;
	int startPos;

	// MPI 初始化
	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &mypid);
	MPI_Comm_size(MPI_COMM_WORLD, &mpi_threads_num);

	// 读入待排序数组大小
	if (mypid == 0)
	{
		cout << "Please enter the size of array:" << endl;
		cin >> num;
	}
	MPI_Bcast(&num, 1, MPI_INT, 0, MPI_COMM_WORLD);

	// 处理 num 不能整除 mpi_threads_num 情况
	startPos = 0;
	startPos = THREADS - (num % THREADS);

	// 随机生成待排序数据
	srand(0);
	int* array = new int[num + startPos];
	for (i = 0; i < num; i++)
	{
		array[i] = rand() % 200;
	}
	for (i = num; i < num + startPos; i++)
	{
		array[i] = 0;
	}

	/* if (mypid == 0)
	{
		cout << "Array waiting for sorting:\n";
		for (i = 0; i < num; i++)
		{
			cout << i << "\t" << array[i] << endl;
		}
	}*/
	startTime = MPI_Wtime();

	PSRS(array, num);

	endTime = MPI_Wtime();
	t = endTime - startTime;
	if (mypid == 0)
	{
		/* cout << "Sorting result:" << endl;
		for (i = 0; i < num; i++)
		{
			cout << i << "\t" << array[i] << endl;
		} */
		cout << "Number of threads: " << mpi_threads_num << endl;
		cout << setprecision(8) << "Exceeding time: " << t << "s" << endl;
	}

	MPI_Finalize();
	return 0;
}
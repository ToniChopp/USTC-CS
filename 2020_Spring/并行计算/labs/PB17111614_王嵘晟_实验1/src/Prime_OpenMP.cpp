#include "stdio.h"
#include "stdlib.h"
#include <math.h>
#include <omp.h>
#include <time.h>

int isPrime(int n)
{
	int i;
	for (i = 2; i <= sqrt((double)n); i++)
	{
		if (n % i == 0)
			return 0;
	}
	return 1;
}

int main(int argc, char *argv[])
{
	omp_set_num_threads(8);
	int n = 500000;
	int i;
	int sum = 0;
	clock_t startTime1, endTime1, startTime2, endTime2;
	clock_t delta1, delta2;
	startTime1 = clock();
#pragma omp parallel for reduction(+:sum)
	for (i = 1; i <= n; i+=2)
	{
		sum += isPrime(i);
	}
	endTime1 = clock();
	delta1 = endTime1 - startTime1;
	printf("OpenMp:\n素数个数:\t%d\n时间:%ld ms\n\n", sum, delta1);

	sum = 0;
	startTime2 = clock();
	for (i = 1; i <= n; i+=2)
	{
		sum += isPrime(i);
	}
	endTime2 = clock();
	delta2 = endTime2 - startTime2;
	printf("串行:\n素数个数:\t%d\n时间:%ld ms\n\n", sum, delta2);
	if (delta1 != 0)
		printf("加速比:\t %.6lf", (double)delta2 / (double)delta1);
	return 0;
}
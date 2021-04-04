#include "stdio.h"
#include "stdlib.h"
#include <math.h>
#include <omp.h>
#include <time.h>

inline double fx(double x)
{
	double result;
	result = 4 / (pow(x, 2.0) + 1);
	return result;
}

int main(int argc, char *argv[])
{
	omp_set_num_threads(8);
	int n = 100000;
	int i;
	double h;
	double sum = 0.0;
	clock_t startTime1, endTime1, startTime2, endTime2;
	clock_t delta1, delta2;
	double x;
	h = 1.0 / (double)n;

	startTime1 = clock();
#pragma omp parallel for reduction(+:sum)
	for (i = 1; i <= n; i++)
	{
		x = h * ((double)i - 0.5);
		sum += fx(x);
	}
	sum *= h;
	endTime1 = clock();
	delta1 = endTime1 - startTime1;
	printf("OpenMp:\npi:\t%.12lf\n时间:%ld ms\n\n", sum, delta1);

	sum = 0.0;
	startTime2 = clock();
	for (i = 1; i <= n; i++)
	{
		x = h * ((double)i - 0.5);
		sum += fx(x);
	}
	sum *= h;
	endTime2 = clock();
	delta2 = endTime2 - startTime2;
	printf("串行:\npi:\t%.12lf\n时间:%ld ms\n\n", sum, delta2);
	if (delta1 != 0)
		printf("加速比:\t %.6lf", (double)delta2 / (double)delta1);
	return 0;
}
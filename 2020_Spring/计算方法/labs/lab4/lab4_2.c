#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<math.h>
double A[100][100];
double x[100];
double b[100];
double c[100];
double xx[100];

double SUM(double *x1, double *x2, int n)       // 前减后
{
    int i;
    double result;
    result = 0;
    for (i = 0; i < n; i ++)
    {
        if (x1[i] >= x2[i])
            result += x1[i] - x2[i];
        else
        {
            result += x2[i] - x1[i];
        }
    }
    return result;
}

int main()
{
    int N;
    int i, j, k;
    int cnt = 1;
    double delta = 100;
    memset(A, 0, sizeof(double));
    memset(x, 0, sizeof(double));
    memset(xx, 0, sizeof(double));
    memset(b, 0, sizeof(double));
    memset(c, 0, sizeof(double));
    printf("Please enter the rank:\n");
    scanf("%d", &N);
    printf("Please enter the matrix A:\n");
    for (i = 0; i < N; i ++)
    {
        for (j = 0; j < N; j ++)
        {
            scanf("%lf", &A[i][j]);
        }
    }
    printf("Please enter b:\n");
    scanf("%lf", &b[0]);
    for (i = 1; i < N; i++)
    {
        b[i] = b[0];
    }
    while (1)
    {
        printf("%d\n", cnt);
        for (i = 0; i < N; i ++)
        {
            if (i == 0)
            {
                for (j = 1; j < N; j ++)
                {
                    c[i] += A[i][j] * x[j];
                }
                c[i] -= b[i];
                xx[i] = -1 * c[i] / A[i][i];
            }
            else
            {
                for (j = 0; j < i; j ++)
                {
                    c[i] += A[i][j] * xx[j];
                }
                for (k = i+1; k < N; k ++)
                {
                    c[i] += A[i][k] * x[k];
                }
                c[i] -= b[i];
                xx[i] = -1 * c[i] / A[i][i];
            }
            printf("%.7lf ", xx[i]);
        }
        printf("\n\n");
        delta = SUM(xx, x, N);
        if (delta <= 1E-5)
            break;
        cnt ++;
        for (i = 0; i < N; i ++)
        {
            x[i] = xx[i];
            c[i] = 0;
        }
    }
    return 0;
}

#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<math.h>

double x1[20];
double Fx[20];
void Getx1 (int N)
{
    int i;
    for(i = 0; i <= N; i ++)
    {
        x1[i] = -5 + 10 * pow(N, -1) * i;
        //x1[i] = -5 * cos((2 * i + 1) * pow(2 * N + 2, -1) * 3.1415926);
    }
}

double Y[502];
void GetY ()
{
    int i;
    for (i = 0; i <= 500; i++)
    {
        Y[i] = i * pow(50, -1) - 5;
    }
}

double Funcx (double x)
{
    double result;
    result = pow(2 + 2 * x + pow(x, 2), -1);
    return result;
}

double GetLagrangeInterpolation (int N, int k, double x)
{
    int i;
    double result = 1;
    for (i = 0; i < k ; i ++)
    {
        result *= ( x- x1[i]) * pow(x1[k] - x1[i], -1);
    }
    for (i = k+1; i <= N; i++)
    {
        result *= ( x- x1[i]) * pow(x1[k] - x1[i], -1);
    }
    return result;
}

double MAX (double a, double b)
{
    if (a > b)
        return a;
    else
    {
        return b;
    } 
}

int main() {
    int N;
    scanf("%d", &N);
    Getx1(N);
    GetY();
    int i, j;
    double LX = 0;
    double FY;
    double Sub;
    double tmp1 = 0;
    for (i = 0; i <= N; i ++)
    {
        Fx[i] = Funcx(x1[i]);
    }
    for(j=0;j<=500;j++)
    {
        LX = 0;
        for(i=0;i<=N;i++)
        {
            LX += Fx[i] * GetLagrangeInterpolation(N, i, Y[j]);
        }
        FY = pow(2 + 2 * Y[j] + pow(Y[j], 2), -1);
        Sub = LX - FY;
        if(Sub <= 0)
            Sub *= -1;
        tmp1 = MAX(tmp1, Sub);
    }
    printf("%.12E", tmp1);
    return 0;
}
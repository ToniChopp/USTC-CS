#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<math.h>

struct FormulaInput
{
    double a;
    double n;
}Formula[100];

double Fx (double x, struct FormulaInput *Formula, int rank)
{
    int i;
    double result;
    result = 0;
    for (i = rank; i >= 0; i --)
    {
        result += Formula[i].a * pow(x, Formula[i].n);
    }
    return result;
}

void ChordCutSolu(double x0, double x1, struct FormulaInput *Formula, int rank)
{
    double xi, xj, xk;
    double fxi, fxj, fxk;
    int cnt = 1;
    xi = x0;
    xj = x1;
    fxi = Fx(xi, Formula, rank);
    fxj = Fx(xj, Formula, rank);
    printf("$0$ & $%.10E$ & $%.10E$ \\cr \\hline \n", xi, fxi);
    printf("\t\t\t$1$ & $%.10E$ & $%.10E$ \\cr \\hline \n", xj, fxj);
    xj = x0;
    xk = x1;
    do
    {
        cnt ++;
        xi = xj;
        xj = xk;
        fxi = Fx(xi, Formula, rank);
        fxj = Fx(xj, Formula, rank);
        xk = xj - fxj * (xj - xi) / (fxj - fxi);
        fxk = Fx(xk, Formula, rank);
        printf("\t\t\t$%d$ & $%.10E$ & $%.10E$ \\cr \\hline \n", cnt, xk, fxk);
    } 
    while (fxk >= 1e-9 || fxk <= -1e-9);
}

int main ()
{
    int maxRank;
    int i;
    double x0, x1;
    printf("Enter the max ranke of the formula:\n");
    scanf("%d", &maxRank);
    printf("Input the formula in format 4x^2 to 4 2:\n");
    for (i = maxRank; i >= 0; i--)
    {
        scanf ("%lf %lf", &Formula[i].a, &Formula[i].n);
    }
    printf("Input x0,x1:\n");
    scanf("%lf %lf", &x0, &x1);
    ChordCutSolu(x0, x1, Formula, maxRank);
    return 0;
}
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<math.h>

struct FormulaInput
{
    double a;
    double n;
}Formula[100];

struct DirivativeFx
{
    double a;
    double n;
}DFx[100];

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

void Derivative (struct FormulaInput *Formula,struct DirivativeFx *DFx, int rank)
{
    int i;
    for (i = rank; i > 0; i --)
    {
        DFx[i-1].a = Formula[i].a * Formula[i].n;
        DFx[i-1].n = Formula[i].n - 1; 
    }
}

double DerFx (double x, struct DirivativeFx *DFx, int rank)
{
    int i;
    double result;
    result = 0;
    for (i = rank - 1; i >= 0; i --)
    {
        result += DFx[i].a * pow(x, DFx[i].n);
    }
    return result;
}

void Interation(double x, struct FormulaInput *Formula, struct DirivativeFx *DFx, int rank)
{
    double x_return;
    double x_temp;
    x_return = x;
    int i = 0;
    double fx;
    fx = Fx(x_return, Formula, rank);
    printf("$0$ & $%.10E$ & $%.10E$ \\cr \\hline \n", x_return, fx);
    do
    {
        i ++;
        x_temp = x_return;
        x_return = x_temp - Fx(x_temp, Formula, rank)/DerFx(x_temp, DFx, rank);
        fx = Fx(x_return, Formula, rank);
        printf("\t\t\t\t$%d$ & $%.10E$ & $%.10E$ \\cr \\hline \n", i, x_return, fx);
    } while (fx >= 1e-9 || fx <= -1e-9);
}

int main ()
{
    int maxRank;
    int i, j;
    double x0;
    printf("Enter the max ranke of the formula:\n");
    scanf("%d", &maxRank);
    printf("Input the formula in format 4x^2 to 4 2:\n");
    for (i = maxRank; i >= 0; i--)
    {
        scanf ("%lf %lf", &Formula[i].a, &Formula[i].n);
    }
    Derivative(Formula, DFx, maxRank);
    printf("Input x0:\n");
    scanf("%lf", &x0);
    Interation(x0, Formula, DFx, maxRank);
    return 0;
}

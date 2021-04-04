#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<math.h>

double array[5] = {4040.045551380452, -2759471.276702747, -31.64291531266504,  2755462.874010974,  0.0000557052996742893};

double SUM_InOrder (double *array)
{
    int i;
    double result = 0;
    for (i = 0; i < 5; i ++)
    {
        result += array[i];
    }
    return result;
}

double SUM_DiverseOrder (double *array)
{
    int i;
    double result = 0;
    for(i = 4; i >= 0; i--)
    {
        result += array[i];
    }
    return result;
}

void BubbleSort (double *array)
{
    int i,j;
    double tmp;
    for (i = 0; i < 4; i ++)
    {
        for (j = 0; j < 5-i; j++)
        {
            if (array[i] > array[j])
            {
                tmp = array[i];
                array[i] = array[j];
                array[j] = tmp;
            }
        }
    }
}

double SUM_SortedOrder (double *array)
{
    BubbleSort (array);
    double result1 = 0;
    double result2 = 0;
    int i;
    for (i = 0; i < 2; i++)
    {
        result1 += array[i];
    }
    for (i = 4; i >= 2; i--)
    {
        result2 += array[i];
    }
    result2 += result1;
    return result2;
}

int main ()
{
    int i;
    double sum1, sum2, sum3;
    sum1 = SUM_InOrder(array);
    sum2 = SUM_DiverseOrder(array);
    sum3 = SUM_SortedOrder(array);
    printf("%.12E\t%.12E\t%.12E", sum1, sum2, sum3);
    return 0;
}
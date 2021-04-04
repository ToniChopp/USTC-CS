#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

double In_f (int index)
{
    double N;
    N = pow(2, index);
    int i;
    double result = 0;
    double h;
    h = 8 / N;
    for (i = 1; i < N; i ++)
    {
        result += sin(h * i);
    }
    result += (0.5 * sin(8));
    result *= h;
    return result;
}

int main() {
    double I;
    I = cos(8);
    I *= -1;
    I += 1;     // 原积分结果
    
    double In[11];
    double En[11];
    double d[11];

    int i, j;
    for (i = 0; i <= 10; i ++)
    {
        In[i] = In_f(i);
        En[i] = I - In[i];
        if (En[i] < 0)
            En[i] *= -1;
        if (i > 0)
        {
            d[i] = log(En[i] / En[i-1]);
            d[i] /= log(2);
            d[i] *= -1;
        }
        if (i == 0)
        {
            printf("\\hline\n");
            printf("$%d$ & $%.12E$ &  \\cr \\hline \n", i, En[i]);
        }
        else
        {
            printf("$%d$ & $%.12E$ & $%.6f$  \\cr \\hline \n", i, En[i], d[i]);
        }
        
    }

    return 0;
}
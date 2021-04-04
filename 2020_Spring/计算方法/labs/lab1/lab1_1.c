#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<math.h>

float function_fx (float x) 
{
    float result;
    result = sqrt(pow(x, 2) + 9) - 3;
    return result;
}

float function_gx (float x)
{
    float result;
    result = pow(x, 2)/(sqrt(pow(x, 2) + 9) + 3);
    return result;
}

void FloatToString (float f)
{
    if (f != 0)
    {
        char str[21];
        memset(str, 0, sizeof(char));
        sprintf(&str[1], "%.11E", f);
        str[0] = '0';
        str[2] = str[1];
        str[1] = '.';
        int len;
        len = strlen(str) - 1;
        if (str[len] != '-')
        {
            str[len]--;
            while (str[len] < '0')
            {
                str[len--] = '9';
                if (str[len] == '-')
                {
                    break;
                }
                str[len]--;
            }
        }
        printf("%s\t", str);
    }
    else
    {
        printf("0.000000000000E-000\t");
    }
    
}

int main()
{
    float x;
    int i;
    float fx, gx;
    for (i = 1; i <= 10; i ++)
    {
        x = pow(8, -i);
        fx = function_fx (x);
        gx = function_gx (x);
        FloatToString(x);
        FloatToString(fx);
        FloatToString(gx);
        printf("\n");
    }

    return 0;
}
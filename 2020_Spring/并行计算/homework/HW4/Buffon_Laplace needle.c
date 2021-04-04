#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <time.h>

float Randomf(float a, float b)           // 生成a, b中间一个随机数
{ 
    int na = (int)(a * 10000); 
    int nb = (int)(b * 10000); 
    int temp = rand() % ( nb - na + 1 ); 
    temp += na; 
    return (temp / 10000.0); 
}
    
int Randomi(int i, int j) 
{ 
    int temp; 
    temp =( rand() % ( j - i + 1 )) + i; 
    return temp; 
}

int main()
{
    long int start, end;
    int N;
    printf("enter the number of needles: \n");
    scanf("%d", &N);
    start = clock();
    int temp = N;
    int cnt = 0;        // 次数
    int a = 2;
    int b = 2;
    int l = 1;
    double width, height;
    float x1, y1, x2, y2;
    int xm, xM, ym, yM;
    int degree;
    while (temp --)
    {
        x1 = Randomf(0.0,100.0); 
        y1 = Randomf(0.0,100.0); 
        degree = Randomi( 0, RAND_MAX); 
        height = sin(degree); 
        width = cos(degree); 
        x2 = x2 + l * width; 
        y2 = y1 + l * height; 
        xm = (x1 < x2)? (int)x1 : (int)x2;
        xM = (x1 >= x2)? (int)x1 : (int)x2;
        ym = (y1 < y2)? (int)y1 : (int)y2;
        yM = (y1 >= y2)? (int)y1 : (int)y2;
        if ((xm % 2) == 0 && (xM % 2) != 0)
        {
            cnt ++;
        }
        if ((ym % 2) == 0 && (yM % 2) != 0)
        {
            cnt ++;
        }
        if (((xm % 2) == 0 && (xM % 2) != 0) && ((ym % 2) == 0 && (yM % 2) != 0))
        {
            cnt --;
        }
    }
    float result;
    printf("%d ", cnt);
    result = (float)N / (float)cnt;
    result *= 7;
    result /= 4;
    printf("%.16f\n", result);

    end = clock();
    printf("Time:%ld ms\n", end - start);
}
#include<stdio.h> 
#include<ctime> 
#include<cstdlib> 
#include <math.h> 
// 设地板的宽度为2，针的长度为1 
float Randomf( float a, float b); 
int Randomi( int i, int j); 

int main(void) 
{ 
    float x1, y1, x2, y2; 
    const int MAX= 20000000; 
    int nCase = MAX; 
    int k = 0; 
    // 针与缝隙交叉的次数 
    double high, width; 
    int degree; 
    while( nCase-- ) 
    { 
        x1 = Randomf(2.0,100.0); 
        y1 = Randomf(2.0,100.0); 
        degree = Randomi( 0, RAND_MAX); 
        high = sin( degree ); 
        width = cos( degree ); 
        x2 = x2 + width; 
        y2 = y1 + high; 
        //确定x2以后，由于两个点之间的距离是恒定的，所以y2也求出来了，但是这里y2可以去两个值，为了公平起见，
        //交替取以过（x1，y1）的水平线以上的点，和水平线以下的点。 
        int min,max; 
        if( y1 > y2 ) 
        { 
            min = (int)y2; 
            max = (int)y1; 
        } 
        else 
        { 
            min = (int)y1; 
            max = (int)y2; 
        } 
        if( max % 2 == 0 && min % 2 != 0) 
            k++;  
    } 
    printf("%d %g\n", k, MAX * 1.0 / k ); 
    return 0;
}

    
    float Randomf( float a, float b) 
    { 
        int na = (int)(a * 10000); 
        int nb = (int)(b * 10000); 
        int temp = rand() % ( nb - na + 1 ); 
        temp += na; 
        return (temp / 10000.0); 
    }
    
    int Randomi( int i, int j) 
    { 
        int temp; 
        temp =( rand() % ( j - i + 1 )) + i; 
        return temp; 
    }









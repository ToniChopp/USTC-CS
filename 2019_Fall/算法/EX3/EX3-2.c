#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#define M 201
int m[M][M];

int min(int a,int b)
{
    while(a>0 && b>0)
    {
        if(a < b)
            return a;
        return b;
    }
    return a;
}

int SUM(int *a,int m,int n)
{
    int i;
    int b=0;
    for(i=m;i<n;i++)
    {
        b+=a[i];
    }
    return b;
}

int main()
{
    int n;
    scanf("%d",&n);
    int a[200];
    int i,j,k,l;
    for(i=0;i<200;i++)
    {
        a[i] = 0;
    }
    for(i=0;i<n;i++)
    {
        scanf("%d",&a[i]);
    }
    for(i=0;i<n;i++)
    {
        for(j=0;j<n;j++)
        {
            if(i == j)
                m[i][j] = 0;
            else
                m[i][j] = INT_MAX;
        }
    }
    for(l=2;l<=n;l++)  /*数组个数*/
    {
        for(i=0;i<n-l+1;i++)
        {
            j=i+l-1;
            m[i][j] = INT_MAX;
            for(k=i;k<j;k++)
            {
                if(j == i+1)
                {
                    m[i][j]=a[i]+a[j];
                    break;
                }
                else
                {   
                    m[i][j]=min(m[i][j],m[i][k]+m[k+1][j]+SUM(a,i,j+1));
                }
            }
        }
    }
    for(i=0;i<n;i++)
    {
        for(j=0;j<n;j++)
        {
            printf("%d ",m[i][j]);
        }
        printf("\n");
    }
    printf("%d",m[0][n-1]);
    return 0;
}
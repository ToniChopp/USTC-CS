#include<stdio.h>
#include<stdlib.h>
#include<string.h>
int Square[2000][2000];
int a[2000][2000];

int MIN(int a,int b,int c)
{
    if(a<=b && a<=c)
        return a;
    else if(b<=a && b<=c)
        return b;
    else if(c<=a && c<=b)
        return c;
}

int main()
{
    int n,m;
    scanf("%d %d",&n,&m);
    int i,j,k;
    int count=0;
    for(i=0;i<n;i++)
    {
        for(j=0;j<m;j++)
        {
            scanf("%d",&a[i][j]);
            a[i][j]=~a[i][j]+2;          /*取反，方便计数*/
            Square[i][j]=a[i][j];
        }
    }
    for(i=1;i<n;i++)
    {
        for(j=1;j<m;j++)
        {   
            if(a[i][j] == 1)
                Square[i][j]=MIN(Square[i-1][j-1],Square[i-1][j],Square[i][j-1])+1;
        }
    }
    for(i=0;i<n;i++)
    {
        for(j=0;j<m;j++)
        {
            count+=Square[i][j];
        }
    }
    printf("%d",count);
    return 0;
}
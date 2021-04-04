#include<stdio.h>
#include<stdlib.h>
#include<string.h>
int f[10001];

typedef struct ITEM{
    int w;
    int v;
    int num;
}ITM;

int MAX(int a,int b)         
{
    if(a >= b)
        return a;
    return b;
}

int main()
{
    int n,W;
    scanf("%d %d",&n,&W);
    ITM Goods [201];
    int i,j,k;
    int weight = 0;
    int value = 0;
    for(i=1;i<=n;++i)
    {
        scanf("%d %d %d",&Goods[i].w,&Goods[i].v,&Goods[i].num);
    }
    for(i=0;i<=W;i++)
        f[i] = 0;
    for(i=1;i<=n;++i)
    {
        if(Goods[i].w*Goods[i].num >= W)
        {
            for(j=Goods[i].w;j<=W;j++)
            {
                f[j] = MAX(f[j],f[j-Goods[i].w]+Goods[i].v);
            }
        }
        else
        {
            int cnt=1;
            while (1)
            {
                if(Goods[i].num > cnt)
                {
                    Goods[i].num-=cnt;
                    for(j=W;j>=cnt*Goods[i].w;--j)
                    {
                        f[j]=MAX(f[j],f[j-cnt*Goods[i].w]+cnt*Goods[i].v);
                    }
                    cnt*=2;
                }
                else
                {
                    for(j=W;j>=Goods[i].num*Goods[i].w;--j)
                    {
                        f[j]=MAX(f[j],f[j-Goods[i].num*Goods[i].w]+Goods[i].num*Goods[i].v);
                    }
                    break;
                }
            }
        }
    }
    printf("%d",f[W]);
    return 0;
}
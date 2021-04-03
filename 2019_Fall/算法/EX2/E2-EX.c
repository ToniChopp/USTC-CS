#include<stdio.h>
#include<stdlib.h>
#include<string.h>

struct Hazard
{
    int i;
    int j;
    int a;
};

struct Hazard EDEN[1000000];
int f[100001];
int rank[100001];

void Quick_Sort(struct Hazard *EDEN,int left,int right)
{
    struct Hazard tmp;
    if(left >= right)
        return ;
    if(right-left >= 3)
    {
        tmp=EDEN[(left+right)/2];
        EDEN[(left+right)/2]=EDEN[left];
        EDEN[left]=tmp;
    }  
    int p = left;
    int q = right;
    struct Hazard k=EDEN[p];
    while(p < q)   
    {
        while(p < q && EDEN[q].a<=k.a) 
        {
            q--;
        }
        EDEN[p]=EDEN[q];
        while(p < q && EDEN[p].a>=k.a)
        {
            p++;
        }
        EDEN[q]=EDEN[p];
    }
    EDEN[p]=k;
    Quick_Sort(EDEN, left, p-1);
    Quick_Sort(EDEN, p+1, right); 
}

int Find(int x)
{
    if(x==f[x])
        return x;
    return f[x]=Find(f[x]);
}

void Union(int x,int y)
{
	int fx=Find(x);
	int fy=Find(y);
	f[f[x]]=fy;
}

int main()
{
    int n,m;
    scanf("%d %d",&n,&m);
    int p,q;
    for(p=0;p<n;p++)
    {
        f[p]=p;
        rank[p]=0;
    }
    for(p=0;p<m;p++)
    {
        scanf("%d %d %d",&EDEN[p].i,&EDEN[p].j,&EDEN[p].a);
    }
    Quick_Sort(EDEN,0,m-1);
    for(p=0;p<m;p++)
    {
        if(Find(EDEN[p].i) == Find(EDEN[p].j))      /*在同一个集合*/
        {
            printf("%d",EDEN[p].a);
            return 0;
        }
        if(rank[EDEN[p].i]==0 && rank[EDEN[p].j]==0)
        {
            rank[EDEN[p].i]=EDEN[p].j;
            rank[EDEN[p].j]=EDEN[p].i;
        }
        else if(rank[EDEN[p].i]==0 && rank[EDEN[p].j]!=0)
        {
            rank[EDEN[p].i]=EDEN[p].j;
            Union(rank[EDEN[p].j],EDEN[p].i);
        }
        else if(rank[EDEN[p].i]!=0 && rank[EDEN[p].j]==0)
        {
            rank[EDEN[p].j]=EDEN[p].i;
            Union(rank[EDEN[p].i],EDEN[p].j);
        }
        else if(rank[EDEN[p].i]!=0 && rank[EDEN[p].j]!=0)
        {
            Union(rank[EDEN[p].i],EDEN[p].j);
            Union(EDEN[p].i,rank[EDEN[p].j]);
        }
    }
    printf("0");
    return 0;
}
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

struct Disjoint_Set
{
    int num;
    int parent;
    int rank;
}DS[5000000];

int Find(int x)
{
    while(DS[x].parent != x)
    {
        x=DS[x].parent;
    }
    if(DS[x].parent == x)
        return x;
    else 
        return Find(DS[x].parent);
    int i,j;           /*路径压缩*/
    i=x;
    while(DS[i].parent != x)
    {
        j=DS[i].parent;
        DS[i].parent=x;
        i=j;
    }
    return x;
}

void Union(int x,int y)
{
    x=Find(x);
    y=Find(y);
    if(DS[x].rank > DS[y].rank)
        DS[y].parent=x;
    else
    {
        DS[x].parent=y;
        if(DS[x].rank==DS[y].rank)
            DS[y].rank++;
    }
}

void Init(int n) 
{
    int i;
    for(i=0;i<n;i++)
    {
        DS[i].num=i;
        DS[i].rank=0;
        DS[i].parent=i;
    }
}

int main()
{
    int n,m,k;
    scanf("%d %d %d",&n,&k,&m);
    Init(n);
    int i;
    int x,y;
    int p,q;
    for(i=0;i<m;i++)
    {
        scanf("%d %d",&x,&y);
        Union(x,y);
    }
    for(i=0;i<k;i++)
    {
        scanf("%d %d",&p,&q);
        p=Find(p);
        q=Find(q);
        if(p==q)
            printf("1 ");
        else
            printf("0 ");
    }
    return 0;
}
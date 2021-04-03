#include<stdio.h>
#include<stdlib.h>
#include<string.h>

struct PATH
{
    int source;
    int terminal;
    int coast;
}path[1000000];
int parent[100000];

void Quick_Sort(struct PATH a[],int left,int right)
{
    struct PATH tmp;
    if(left >= right)
    return ;
    if(right-left>=3)
    {
        tmp=a[(left+right)/2];
        a[(left+right)/2]=a[left];
        a[left]=tmp;
    }  
    int i = left;
    int j = right;
    struct PATH k=a[i];
    while( i < j)   
    {
        while(i < j && k.coast<=a[j].coast) 
        {
		  
            j--;
        }
        a[i]=a[j];
        while(i < j && a[i].coast<=k.coast)
        {
            i++;
        }
        a[j]=a[i];
    }
    a[i]=k;
    Quick_Sort(a,left,i-1);
    Quick_Sort(a, i +1, right); 
}

int Find_Set(int x)
{
    if(parent[x] != x)
        parent[x] = Find_Set(parent[x]);
    return parent[x];
}

void Union(int x,int y)
{
    parent[Find_Set(y)] = Find_Set(x);
}

int main()
{
    int N,M;
    scanf("%d %d",&N,&M);
    int i,j;
    int budget = 0;
    int edge = 0;
    for(i=0;i<M;i++)
    {
        scanf("%d %d %d",&path[i].source,&path[i].terminal,&path[i].coast);
    }
    for(i=0;i<N;i++)
    {
        parent[i] = i;
    }
    Quick_Sort(path,0,M-1);
    /*for(i=0;i<M;i++)
    {
        printf("%d %d %d\n",path[i].source,path[i].terminal,path[i].coast);
    }*/
    for(i=0;i<M;i++)
    {
        if(edge == N-1)
            break;
        if(Find_Set(path[i].source) != Find_Set(path[i].terminal))
        {
            Union(path[i].source,path[i].terminal);
            budget += path[i].coast;
            edge++;
        }
    }
    printf("%d",budget);
    return 0;
}
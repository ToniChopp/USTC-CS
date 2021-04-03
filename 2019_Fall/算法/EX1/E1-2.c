#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int a[10];
int tmp[10];

int MERGE(int *arry,int *tmp,int begin,int mid,int end)
{
    int i=begin;
    int j=mid+1;
    int k=begin;
    int count=0;
    while (i<=mid & j<=end)
    {
        if(arry[i]>arry[j])
        {
            tmp[k++]=arry[i++];
            count+=end-j+1;
            count%=10000019;
        }
        else
        {
            tmp[k++]=arry[j++];
        }
    }
    while (i<=mid)
    {
        tmp[k++]=arry[i++];
    }
    while (j<=end)
    {
        tmp[k++]=arry[j++];
    }
    for(i=begin;i<=end;i++)
        arry[i]=tmp[i];
    return count;
}

int MERGE_SORTING_AND_COUNTING(int *arry,int *tmp,int begin,int end)
{
    if(begin==end)
        return 0;
    int mid=(begin+end)/2;
    int count=0;
    count+=MERGE_SORTING_AND_COUNTING(arry,tmp,begin,mid);
    count%=10000019;
    count+=MERGE_SORTING_AND_COUNTING(arry,tmp,mid+1,end);
    count%=10000019;
    count+=MERGE(arry,tmp,begin,mid,end);
    count%=10000019;
    return count;
}

int main()
{
    int n;
    scanf("%d",&n);
    int i,j;
    for(i=0;i<n;i++)
    {
        scanf("%d",&a[i]);
    }
    int pairs=0;
    pairs+=MERGE_SORTING_AND_COUNTING(a,tmp,0,n-1);
    pairs%=10000019;
    printf("%d",pairs);
}

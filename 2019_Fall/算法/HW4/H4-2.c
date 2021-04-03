#include<stdio.h>
#include<string.h>
#include<stdlib.h>

void Quick_Sort(int a[],int left,int right)
{
    int tmp;
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
    int k=a[i];
    while( i < j)   
    {
        while(i < j && k<=a[j]) 
        {
		  
            j--;
        }
        a[i]=a[j];
        while(i < j && a[i]<=k)
        {
            i++;
        }
        a[j]=a[i];
    }
    a[i]=k;
    Quick_Sort(a,left,i-1);
    Quick_Sort(a, i +1, right); 
}

int main()
{
    int n;
    int a[10000000];
    scanf("%d",&n);
    int i,j;
    for(i=0;i<n;i++)
    {
        scanf("%d",&a[i]);
    }
    Quick_Sort(a,0,n-1);
    for(i=0;i<n;i++)
    {
        printf("%d ",a[i]);
    }
    return 0;
}

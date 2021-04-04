#include<stdio.h>
#include<stdlib.h>
#include<string.h>

struct account{
    int day;
    int number;
};

int PARENT(int i)
{
    return i/2;
}

int LEFT(int i)
{
    return 2*i;
}

int RIGHT(int i)
{
    return 2*i+1;
}

void MAX_HEAPIFY(struct account*a,struct account tmp,int i,int heap_size)
{
    int largest;
    int l;
    int r;
    l=LEFT(i);
    r=RIGHT(i);
    if(l<=heap_size && a[l-1].number>a[i-1].number)
    {
        largest=l;
    }
    else
    {
        largest=i;
    }
    if(r<=heap_size && a[r-1].number>a[largest-1].number)
    {
        largest=r;
    }
    if(largest != i)
    {
        tmp=a[largest-1];
        a[largest-1]=a[i-1];
        a[i-1]=tmp;
        MAX_HEAPIFY(a,tmp,largest,heap_size);
    }
}

void BUILD_MAX_HEAP(struct account*a,struct account tmp,int heap_size)
{
    int i;
    for( i = heap_size/2;i > 0;i--)
    {
        MAX_HEAPIFY(a,tmp,i,heap_size);
    }
}

void INSERT_HEAP(struct account*a,struct account tmp,int heap_size,struct account key)
{
    a[heap_size]=key;
    int i;
    for(i=heap_size;i>=1;i=(i-1)/2)
    {
        if(a[i].number>a[(i-1)/2].number)
    	{
    	    tmp=a[i];
       		a[i]=a[(i-1)/2];
        	a[(i-1)/2]=tmp;
    	}
    }
}

void DELETE_HEAP_TOP(struct account*a,struct account tmp,int heap_size)
{
    a[0].number=0;
    MAX_HEAPIFY(a,tmp,1,heap_size);
}

int main()
{
    int n,k;
    scanf("%d %d",&n,&k);
    struct account a[1000000];
    struct account tmp;
    struct account key;
    int b[1000000];
    int i,j;
    int heap_size=k;
    int m=0;
    for(i=0;i<k;i++)
    {
        scanf("%d",&a[i].number);
        a[i].day=i;
    }
    BUILD_MAX_HEAP(a,tmp,k);
    b[0]=a[0].number;
    for(i=k;i<n;i++)
    {
        scanf("%d",&key.number);
        key.day=i;
        INSERT_HEAP(a,tmp,i,key);
        heap_size++;
        while(a[0].day<=i-k)
		{
			DELETE_HEAP_TOP(a,tmp,heap_size);
		}         
        b[++m]=a[0].number;
    }
    for(i=0;i<n-k+1;i++)
    {
        printf("%d ",b[i]);
    }
    return 0;
}

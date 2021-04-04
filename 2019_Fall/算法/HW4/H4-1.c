#include<stdio.h>
#include<stdlib.h>
#include<string.h>
void CountingSort(int A[], int n, int k)
{
    int *c, *b;
    int i;
    c = (int *)malloc(sizeof(int)*k); /*临时数组,注意它的大小是待排序序列中值最大的那个。如假定该排序序列中最大值为1000000，则该数组需要1000000*sizeof(int)个存储单元*/
    b = (int *)malloc(sizeof(int)*n);  /*存放排序结果的数组*/
    for (i = 0; i < k; i++)
        c[i] = 0;              /*初始化*/
    for (i = 0; i < n; i++)
        c[A[i]] += 1;               /*统计数组A中每个值为i的元素出现的次数*/
    for (i = 1; i < k; i++)
        c[i] = c[i - 1] + c[i];    /*确定值为i的元素在数组c中出现的位置*/
    for (i = n - 1; i >= 0; i--)
    {
        b[c[A[i]] - 1] = A[i];     /*对A数组，从后向前确定每个元素所在的最终位置;*/
        c[A[i]] -= 1;
    }
    for (i = 0; i < n; i++)
        A[i] = b[i];       /*这个目的是返回A数组作为有序序列*/
    free(c);
    free(b);
}

int main()
{
    int n,k;
    scanf("%d %d",&n,&k);
    int i;
    int a[10];
    for(i=0;i<n;i++)
    {
        scanf("%d",&a[i]);
    }
    CountingSort(a,n,10000);
    printf("%d",a[k-1]);
    return 0;
}

#include<stdio.h>
#include<stdlib.h>
#include<string.h>
void CountingSort(int A[], int n, int k)
{
    int *c, *b;
    int i;
    c = (int *)malloc(sizeof(int)*k); /*��ʱ����,ע�����Ĵ�С�Ǵ�����������ֵ�����Ǹ�����ٶ����������������ֵΪ1000000�����������Ҫ1000000*sizeof(int)���洢��Ԫ*/
    b = (int *)malloc(sizeof(int)*n);  /*���������������*/
    for (i = 0; i < k; i++)
        c[i] = 0;              /*��ʼ��*/
    for (i = 0; i < n; i++)
        c[A[i]] += 1;               /*ͳ������A��ÿ��ֵΪi��Ԫ�س��ֵĴ���*/
    for (i = 1; i < k; i++)
        c[i] = c[i - 1] + c[i];    /*ȷ��ֵΪi��Ԫ��������c�г��ֵ�λ��*/
    for (i = n - 1; i >= 0; i--)
    {
        b[c[A[i]] - 1] = A[i];     /*��A���飬�Ӻ���ǰȷ��ÿ��Ԫ�����ڵ�����λ��;*/
        c[A[i]] -= 1;
    }
    for (i = 0; i < n; i++)
        A[i] = b[i];       /*���Ŀ���Ƿ���A������Ϊ��������*/
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

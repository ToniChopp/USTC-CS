#include<stdio.h>
#include<stdlib.h>
#include<string.h>
int clothes[200000];

int Max(int a,int b)
{
    if(a >= b)
        return a;
    return b;
}

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
    int k = a[i];
    while( i < j)   
    {
        while(i < j && k<=a[j]) 
        {
		  
            j--;
        }
        a[i] = a[j];
        while(i < j && a[i]<=k)
        {
            i++;
        }
        a[j] = a[i];
    }
    a[i]=k;
    Quick_Sort(a, left, i-1);
    Quick_Sort(a, i +1, right); 
}

int Largest_Withdraw(int *clothes,int N,int k)
{
    int result = -1;
    int left = 0;
    int right = clothes[N-1]-clothes[0];
    int mid;
    int i;
    int position;
    int num;
    int flag = 0;
    while(left < right)
    {
        mid = (left+right)/2;
        position = clothes[0];
        num = 1;
        for(i=1;i<N;i++)
        {
            if(clothes[i]-position >= mid)
            {
                position = clothes[i];
                num ++;
                if(num == k)
                    break;
            }
        }
        if(num == k)
        {
            flag = 1;             /* 找到了合理放置N-M个的方法 */
        }
        else
            flag = 0;
        if(flag == 1)
        {
            left = mid+1;
            result = Max(result,mid);
        }
        else
            right = mid;
    }
    return result;
}

int main()
{
    int N,M;
    scanf("%d %d",&N,&M);
    int i,j;
    int consequence;
    for(i=0;i<N;i++)
    {
        scanf("%d",&clothes[i]);
    }
    Quick_Sort(clothes,0,N-1);
    consequence = Largest_Withdraw(clothes,N,N-M);
    printf("%d",consequence);
    return 0;
}
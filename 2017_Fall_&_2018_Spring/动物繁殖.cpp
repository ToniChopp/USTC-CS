#include<stdio.h>
int main()
{
	int i,N;
	long int a[1000]={0};
	scanf("%d",&N);
	a[0]=1;
	a[1]=1;
	for(i=2;i<N;i++)
	{
		a[i]=a[i-1]+a[i-2];
	}
	printf("%ld",a[N-1]);
	return 0;
}

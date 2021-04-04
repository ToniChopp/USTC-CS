#include<stdio.h>
int main()
{
	int Y,flag=0;
	scanf("%d",&Y);
	if(Y%100!=0 && Y%4==0)
    flag=1;
	if(Y%400==0)
	flag=1;
	if(flag==1)
	printf("YES");
	else
	printf("NO");
	return 0;
}

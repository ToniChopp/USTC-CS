#include<stdio.h>
int main()
{
	int k,a[5],i,j,m,n,sum1,sum2,sum3,sum4,sum5,flag;
	flag=0;
	scanf("%d",&k);
	scanf("%d %d %d %d %d",&a[0],&a[1],&a[2],&a[3],&a[4]);
	for(i=0;i<5;i++)
	{
		sum1=a[i];
		if(sum1==k){
		flag=1;
		break;}
		else
		sum5=a[0]+a[1]+a[2]+a[3]+a[4];
		if(sum5==k){
		flag=1;
		break;}
		for(j=0;j<5;j++)
		{
			if(j!=i){
			sum2=a[i]+a[j];}
			if(sum2==k){
			flag=1;break;} 
		    else
		    for(n=0;n<5;n++)
		    {
		    	if(n!=i && n!=j)
		    	{ sum3=a[i]+a[j]+a[n];}
		    	if(sum3==k){
		    		flag=1;break;}
			}
		}
		for(m=0;m<5;m++)
		{
			sum4=sum5-a[m];
			if(sum4==k)
			flag=1;
			break;
		}
	}
	if(flag==1)
	printf("Yes");
	else
	printf("No");
	return 0;
}

#include<stdio.h>
#include<string.h>
int main()
{
	int a[110],b[110],result[210];
	char c[110],d[110];
	int i,j,l1,l2;
	memset(a,0,sizeof(a));
	memset(b,0,sizeof(b));
	memset(result,0,sizeof(result));
	scanf("%s%s",c,d);
	l1=strlen(c);
	l2=strlen(d);
	j=0;
	for(i=l1-1;i>=0;i--)
	{
		a[j++]=c[i]-'0';
	}
	j=0;
	for(i=l2-1;i>=0;i--)
	{
		b[j++]=d[i]-'0';
	}
	for(i=0;i<l2+1;i++)
	{
		for(j=0;j<l1+1;j++)
		{
			result[i+j]+=b[i]*a[j];
		}
	}
	for(i=0;i<200;i++)
	{
		if(result[i]>=10)
		{
			result[i+1]+=result[i]/10;
			result[i]%=10;
		}
	}
	bool bStartOutput=false;
	for(i=200;i>=0;i--)
		if(bStartOutput)
		    printf("%d",result[i]);
		else if(result[i])
		{
			printf("%d",result[i]);
			bStartOutput=true;
		}
    	if(!bStartOutput)
		    printf("0");
		return 0;
 } 

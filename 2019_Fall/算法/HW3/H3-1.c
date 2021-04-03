#include<stdio.h>
#include<string.h>
#include<stdlib.h>
int main()
{
	int n;
	scanf("%d",&n);
	int a[1000];
	int b[1000];  
	int c[1000];
	int i,j,k=1,l=0;
	int tmp,x,tmp1,tmp2;
	int m;
	memset(c,0,sizeof(c));
	for(i=0;i<n;i++)
	{
		scanf("%d",&a[i]);
	} 
    for(i=0;i<n;i++)
    {
    	for(j=0;j<n-i-1;j++)
    	{
    		if(a[j]>a[j+1])
    		{
    			tmp=a[j+1];
    			a[j+1]=a[j];
    			a[j]=tmp;
			}
		}
	}
	x=a[0];
	b[0]=a[0];
	for(i=0;i<n;i++)
	{
		if(a[i]!=x)
		{
			x=a[i];
			b[k++]=a[i];
			l++;
			c[l]++;
		}
		else
		{
			c[l]++;
		}
	}
	m=l+1;
	for(i=0;i<m;i++)
	{
		for(j=0;j<m-i-1;j++)
		{
			if(c[j]<c[j+1])
			{
				tmp1=c[j+1];
				tmp2=b[j+1];
    			c[j+1]=c[j];
    			b[j+1]=b[j];
    			c[j]=tmp1;
    			b[j]=tmp2;
			}
		}
	}
	for(j=0;j<m;j++)
	{
	    printf("%d %d\n",b[j],c[j]);
	}
	 return 0;
}

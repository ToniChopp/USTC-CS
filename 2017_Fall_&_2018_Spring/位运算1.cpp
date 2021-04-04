#include<stdio.h>
#define N 16
int main()
{
	int i,j,n,flag;
	unsigned short a,b,p;
	scanf("%d",&n);
	for(i=0;i<n;i++)
	{
		scanf("%hu%hu",&a,&b);
		flag=0;
	    for(j=0;j<N;j++)
	    {
		     p=a;
			 p=(p<<j)|(p>>(N-j));
	         if(p==b)
		    {
	             flag=1;
	             break;
		    }
	    }
	     printf("%s\n",flag==1?"YES":"NO");
	}
	return 0;
}

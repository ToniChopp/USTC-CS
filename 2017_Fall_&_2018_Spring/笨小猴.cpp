#include<stdio.h>
#include<string.h>
int main()
{
	char str[100];
	int i,j,n,maxn=0,minn=100,p,q,r,flag=1;
	scanf("%s",str);
	n=strlen(str);
	for(j=97;j<123;j++)
	{
		p=0;
		for(i=0;i<=n;i++)
		{
			if(str[i]==j)
		    p++;
		    if(p>maxn)
		    maxn=p;
		    if(i==n)
		    {
		    	if(p!=0 && p<minn)
		    	minn=p;
			}
		}
		
	}
	q=maxn-minn;
	if(q<=1)
	{printf("No Answer\n0");}
	if(q==2)
	{printf("Lucky Word\n%d",q);}
	else if(q>2)
	{
	    for(r=2;r<q;r++)
	    {
		    if(q%r==0)
		    {
		        flag=0;
		        break;
	        }
	    }
	    if(flag==1){ 
	    printf("Lucky Word\n");
	    printf("%d",q);} 
	    else
	    printf("No Answer\n0");
    }
	return 0;
 }  

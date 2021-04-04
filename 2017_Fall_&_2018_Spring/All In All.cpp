#include<stdio.h>
#include<string.h>
int main()
{
	char s[100001],t[100001];
	int i,j,k,n1,n2,m=0,n=0;
	while(scanf("%d",&k)==0)
	{
	    m=n=0;
		scanf("%s %s",s,t);
	    n1=strlen(s);
	    n2=strlen(t);
	    for(i=0;i<n1;i++)
	    {
		    for(j=n;j<n2;j++)
		    {
			    if(s[i]==t[j])
			    {m++;n=j+1; break;}
		    }
	    }  
	    if(m==n1)
	    printf("Yes\n");
	    else
	    printf("No\n");
	}
	return 0;
 } 

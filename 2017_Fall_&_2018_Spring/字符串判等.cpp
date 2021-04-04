#include<stdio.h>
#include<string.h>
int main()
{
	char s1[101],s2[101],c;
	int n1,n2,i,j,k,p,q,m,flag=1;
	gets(s1);
	gets(s2);
	n1=strlen(s1);
	n2=strlen(s2);
	for(i=p=0;i<n1;i++)
	{
		if(s1[i]!=' ')
		s1[p++]=s1[i];
	}
	for(k=q=0;k<n2;k++)
	{
	    if(s2[k]!=' ')
		s2[q++]=s2[k];
	}
	if(p>q)
	m=p;
	else
	m=q;
	for(j=0;j<m;j++)
	{
	    if(s1[j]>='a')
	    s1[j]=s1[j]-32;
	    if(s2[j]>='a')
	    s2[j]=s2[j]-32;
	    if(s1[j]!=s2[j])
        {flag=0; break;}
    }
	if(flag==0)
	printf("NO\n");
	else
	printf("YES\n");
	return 0;
 } 

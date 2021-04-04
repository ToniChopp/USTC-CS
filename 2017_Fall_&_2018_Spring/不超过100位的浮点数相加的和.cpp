#include<stdio.h>
#include<string.h>
int an1[110];
int bn1[110];
int an2[110];
int bn2[110];
char s1[110];
char s2[110];
char s11[110]={0};
char s12[110]={0};
char s21[110]={0};
char s22[110]={0};

int main()
{
	scanf("%s%s",s1,s2);
	int i,j,k=0,m=0,n=0,p,l1,l2,flag=0,fuck=0;
	memset(an1,0,sizeof(an1));
	memset(an2,0,sizeof(an2));
	memset(bn1,0,sizeof(bn1));
	memset(bn2,0,sizeof(bn2));
	l1=strlen(s1);
	l2=strlen(s2);
	for(i=0;i<l1;i++)
	{
		if(s1[i]=='.')
		{
			m=i;
			break;
		}
	}
	for(i=0;i<m;i++)
	{
		s11[i]=s1[i];
	}
	for(i=m+1;i<l1;i++)
	{
		s12[i-m-1]=s1[i];
	}
	if(m==0)
	{
		for(i=0;i<l1;i++)
	    {
		    s11[i]=s1[i];
	    }
	}
	for(i=0;i<l2;i++)
	{
		if(s2[i]=='.')
		{
			n=i;
			break;
		}
	}
	for(i=0;i<n;i++)
	{
		s21[i]=s2[i];
	}
	for(i=n+1;i<l2;i++)
	{
		s22[i-n-1]=s2[i];
	}
	if(n==0)
	{
	    for(i=0;i<l2;i++)
	    {
		    s21[i]=s2[i];
		}
	}
	int l11=strlen(s11);
	int l12=strlen(s12);
	int l21=strlen(s21);
	int l22=strlen(s22);
	if(strlen(s12)>strlen(s22))
	    p=strlen(s12);
    else
	    p=strlen(s22);
	j=0;
	for(i=l11-1;i>=0;i--)
	{
		an1[j++]=s11[i]-'0';
	}
	j=0;
	for(i=l21-1;i>=0;i--)
	{
		an2[j++]=s21[i]-'0';
	}
	j=0;
	for(i=0;i<l12;i++)
	{
		bn1[j++]=s12[i]-'0';
	}
	j=0;
	for(i=0;i<l22;i++)
	{
		bn2[j++]=s22[i]-'0';
	}
	for(i=99;i>=0;i--)
	{
		bn1[i]+=bn2[i];
		if((bn1[i]>=10) && (i>0))
		{
			bn1[i]-=10;
			bn1[i-1]++;
		}
	}
	if(bn1[0]>=10)
	{
		bn1[0]-=10;
		an1[0]++;
	}
	for(i=0;i<100;i++)
	{
		an1[i]+=an2[i];
		if(an1[i]>9)
		{
			an1[i]-=10;
			an1[i+1]++;
		}
	}
	for(i=0;i<100;i++)
	{  
	    if(an1[i]==0)
	    flag++;
	}
	if(flag==100)
	printf("0");
	else
	{
	    bool bStartOutput=false;
	    for(i=100;i>=0;i--)
     	{
		    if(bStartOutput)
		        printf("%d",an1[i]);
		    else if(an1[i])
		    {
			    printf("%d",an1[i]);
			    bStartOutput=true;
		    }
	    }
    }
    for(i=0;i<100;i++)
    {
    	if(bn1[i]==0)
    	fuck++;
	}
	if((s1[m]=='.' || s2[n]=='.') && (fuck<100))
	{
		printf(".");
	    for(i=p-1;i>=0;i--)
        {
        	if(bn1[p-1]==0)
        	p=p-1;
	    }
	    for(i=0;i<p;i++)
	    {
	    	printf("%d",bn1[i]);
		}
	}
	return 0;
 } 

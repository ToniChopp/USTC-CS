#include<stdio.h>
#include<string.h>
int main()
{
	char Secret[101],Reality[101],Translation[101],Key[101]={0};
	int n1,n2,n3,i,j,p,q,Change[26]={};
	memset(Secret,0,sizeof(Secret));
	memset(Reality,0,sizeof(Reality));
	memset(Translation,0,sizeof(Translation));
	scanf("%s%s%s",Secret,Reality,Translation);
	n1=strlen(Secret);
	n2=strlen(Reality);
	n3=strlen(Translation);
	if(n1<26)
	{
		printf("Failed");
		return 0;
	}
	else
	for(i=0;i<n1;i++)
	{
		if(Change[Secret[i]-'A'] && Change[Secret[i]-'A']!=Reality[i])
		{
			printf("Failed");
			return 0;
		}
		else
		Change[Secret[i]-'A']=Reality[i];
	}
	for(p=0;p<26;p++)
	{
		for(q=p+1;q<26;q++)
		{
			if(Change[p]==Change[q])
			{printf("Failed");return 0;}
		}
	}
	for(j=0;j<n3;j++)
	Key[j]=Change[Translation[j]-'A'];
	printf("%s",Key);
	return 0;
 } 

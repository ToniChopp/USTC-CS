#include<stdio.h>
#include<string.h>
#include<math.h>
#include<stdlib.h>

int main()
{
	int i,j,k;
	int n,m,p;
	printf("Please enter the number of the keys: \n");
	scanf("%d",&n);
	printf("Please enter the length of Hash table: \n");
	scanf("%d",&m);
	printf("Please enter the divider: \n");
	scanf("%d",&p);
	int key[n],key2[n];
	int H[n];
	printf("Please enter %d keys:\n",n);
	for(i=0;i<n;i++)
	{
		scanf("%d",&key[i]);
		H[i]=key[i]%p;
	}
	printf("\nH(key):\n");
	for(i=0;i<n;i++)
	{
		printf("%d   ",H[i]);
	}
	printf("\n\n");
	int H1[n],H2[n];
	int HT1[m];
	int HT2[m][m];
	for(i=0;i<n;i++)
	{
		H1[i]=H[i];
		H2[i]=H[i];
		key2[i]=key[i];
	}
	memset(HT1,0,sizeof(HT1));
	memset(HT2,0,sizeof(HT2));
	int count1=n,count2=n;
	int count3=0,count4=p;
	for(k=0;k<m;k++)
	{
		for(i=0;i<n;i++)
	    {
		    for(j=i+1;j<n;j++)
		    {
			    if(H1[i]==H1[j])
			    {
				    H1[j]+=1;
				    H1[j]%=m;
				    count1++;
			    }
		    }
	    }
	}
	printf("\nH1(key):\n"); 
	for(i=0;i<n;i++)
	{
		printf("%d   ",H1[i]);
	}
	printf("\n\n");
	for(i=0;i<n;i++)
	{
		HT1[H1[i]]=key[i];
	}
	for(i=0;i<m;i++)
	{
		if(HT1[i]==0)
		{
			count3++;
			continue;
		}
		for(j=0;j<m;j++)
		{
			if(HT1[j]==0 && j>=i)
			{
			    count3+=j-i+1;
				break;	
			}
			else 
			{
				for(k=i+1;k<m;k++)
				{
					if(HT1[k]==0)
					    break;
				}
				if(k==m)
				{
					if(HT1[j]==0 && j<i)
					{
						count3+=m+1-i+j;
				        break;
					}
				}
			}
		}
	}
	printf("HT1:\n");
	for(i=0;i<m;i++)
	{
		printf("%d   ",HT1[i]);
	}
	printf("\n\n");
	printf("Success:\n");
	printf("ALS1=%d/%d\n\n",count1,n);
	printf("Unsuccess:\n");
	printf("ALS1'=%d/%d\n\n",count3,p);
	int tmp;
	for(i=0;i<n-1;i++)
	{
		for(j=i+1;j<n;j++)
		{
			if(H2[i]>H2[j])
			{
				tmp=H2[j];
				H2[j]=H2[i];
				H2[i]=tmp;
				tmp=key2[j];
			    key2[j]=key2[i];
				key2[i]=tmp;
			}
		}
	}
	for(i=0;i<n-1;i++)
	{
		for(j=i+1;j<n;j++)
		{
			if(H2[i]==H2[j])
			{
				if(key2[i]>key2[j])
				{
					tmp=key2[j];
			    	key2[j]=key2[i];
				    key2[i]=tmp;
				}
			}
		}
	}
	printf("\nH2[key]:\n");
	for(i=0;i<n;i++)
	{
		printf("%d   ",H2[i]);
	}
	j=0;
	for(i=0;i<n;i++)
	{
		if(H2[i]>H2[i-1])
		    j=0;
		for(k=0;k<m;k++)
		{
			if(k==H2[i])
			{
				HT2[k][j++]=key[i];
			}
		}
    }
	printf("\nHT2:\n");
	for(i=0;i<m;i++)
	{
		printf("%d   ",i);
		for(j=0;j<m;j++)
		{
			if(HT2[i][j]==0)
			{
				printf("¡Ä\n");
				break;
			}
			printf("¡ú%d",HT2[i][j]);
		}
		printf("\n");
	}
	for(i=0;i<m;i++)
	{
		for(j=0;j<m;j++)
		{
			if(HT2[i][j]!=0)
			{
				count2+=j;
			    count4++;
			}
		}
	}
	printf("\nSuccess:\n");
	printf("ASL2=%d/%d\n",count2,n);
	printf("\nUnsuccess:\n");
	printf("ASL2'=%d/%d\n",count4,p);
	
	int aim,temp,count5=0,count6=0;
	int flag=0;
	printf("\nPlease enter the number you want to search for:\n");
	scanf("%d",&aim);
	temp=aim%p;
	for(i=0;i<n;i++)
	{
		if(key[i]==aim)
	    {
	    	if(H1[i]>=H[i])
	    	    count5=H1[i]-H[i]+1;
	    	else
	    	    count5=m-H1[i]+H[i]+1;
	    	flag=1;
	    	break;
		}
	}
	if(count5==0)
	{
		flag=0;
		for(i=temp+1;i<m;i++)
		{
			if(HT1[i]==0)
			{
				count5=i-temp+1;
				break;
			}
			    
		}
		if(i==m)
		{
			for(j=0;j<m;j++)
			{
				if(HT1[j]==0)
				{
					count5=m-temp+j+1;
					break;
				}
			}
		}
	}
	for(i=0;i<m;i++)
	{
		if(HT2[temp][i]==aim)
		    count6=i+1;
	}
	if(count6==0)
	{
		for(i=0;i<m;i++)
		{
			if(HT2[temp][0]==0)
			{
				count6++;
			    break;
			}
			if(HT2[temp][i]!=0)
			    count6++;
		}
	}
	if(flag==1)
	    printf("\nSuccess:\n");
	else 
	    printf("\nUnsuccess:\n");
	printf("Table 1:  %d\n",count5);
	printf("Table 2:  %d\n",count6);
	return 0;
}

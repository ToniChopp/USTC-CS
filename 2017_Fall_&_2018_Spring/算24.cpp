#include<stdio.h>
#include<math.h>
double num[4];
int find(int k)
{
	int i,j;
	double num1,num2;
	if(k==1)
	{
		if(fabs(num[0]-24)<1e-3)
		    return 1;
		else
		    return 0;
	}
		for(i=0;i<k-1;i++)
		{
			for(j=i+1;j<k;j++)
			{
				num1=num[i];
				num2=num[j];
				num[i]=num1+num2;
				num[j]=num[k-1];
				if(find(k-1)==1)
				    return 1;
				num[i]=num1-num2;
				if(find(k-1)==1)
				    return 1;
				num[i]=num2-num1;
				if(find(k-1)==1)
				    return 1;
				num[i]=num1*num2;
				if(find(k-1)==1)
				    return 1;
				if(num2!=0)
				{
					num[i]=num1/num2;
					if(find(k-1)==1)
				        return 1;
				}
				if(num1!=0)
				{
					num[i]=num2/num1;
					if(find(k-1)==1)
				        return 1;
				}
				num[i]=num1;
				num[j]=num2;
			}
		}
		return 0;
 } 
 int main()
 {
 	int i;
 	int n=0;
 	while(1)
 	{
 		for(i=0;i<4;i++)
 		{
 			scanf("%lf",&num[i]);
 			if(num[i]==0)
 			n++;
		}
		if(n==4)
		    break;
		int cons;
		cons=find(4);
		if(cons==1)
		    printf("YES\n");
		else
		    printf("NO\n");
	 }
	 return 0;
 }

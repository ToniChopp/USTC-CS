#include<stdio.h>
#include<math.h>
float a,b,c,d;
float f(float x)
{
	float y;
	y=a*x*x*x+b*x*x+c*x+d;
	return y;
}
int main()
{
	int i,j,t,l;
	float min=-100,max=100,f1,f2,p,q,k[200000]={0},m,n,o;
	scanf("%f%f%f%f",&a,&b,&c,&d);
	j=0;
	for(i=0;i<200000;i++)
	{
		p=min+0.001*i;
		f1=f(p);
		q=p+0.0011;
		f2=f(q);
		if(f1*f2<=0)
		    k[j++]=p+0.0005;
	}
	for(i=1;i<200000;i++)
	{
		m=k[0];
		if((k[i]-m)<1)
	    {
	    	k[i]=0;
	    	continue;
		}
		else
		{
			n=k[i];
			t=i;
			break;
		}
	}
	for(i=t+1;i<200000;i++)
	{
		if((k[i]-n)<1)
		{
			k[i]=0;
	    	continue;
		}
		else
		{
			o=k[i];
			l=i;
			break;
		}
	}
	for(i=l+1;i<200000;i++)
	{
		if((k[i]-o)<1)
		{
			k[i]=0;
			continue;
		}
	}
	for(i=0;i<200000;i++)
	{
		if(k[i]!=0)
		{
			printf("%.2f ",k[i]);
		}
	}
	return 0; 
}

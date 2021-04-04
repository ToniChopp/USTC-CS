#include<stdio.h>
#include<string.h>
int main()
{
	int N;
	char Name[21],Judge1,Judge2;
	int Score1,Score2,Number,Scholarship; 
	int i,a,b,c,d,e;
	long int Max=0,Sum=0; 
	char tmp[21];
	scanf("%d",&N);
	for(i=0;i<N;i++)
	{
		scanf("%s %d %d %c %c %d",&Name,&Score1,&Score2,&Judge1,&Judge2,&Number);
		if((Score1>80) && (Number>0))
		{
			a=8000;
		}
		else
		a=0;
		if((Score1>85) && (Score2>80))
		{
			b=4000;
		}
		else
		b=0;
		if(Score1>90)
		{
			c=2000;
		}
		else
		c=0;
		if((Score1>85) && (Judge2=='Y'))
		{
			d=1000;
		} 
		else
		d=0;
		if((Score2>80) && (Judge1=='Y'))
		{
		    e=850;
		}
		else
		e=0;
		Scholarship=a+b+c+d+e;
		Sum+=Scholarship; 
	    if(i==0)
	    {
	    	Max=Scholarship;
	    	strcpy(tmp,Name);
	    	continue;
		}
		else
		if(Scholarship>Max)
		{
			Max=Scholarship;
			strcpy(tmp,Name);
		}
	}
	printf("%s\n%ld\n%ld\n",tmp,Max,Sum);
	return 0;
}
 

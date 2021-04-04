#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<math.h>
struct peanut
{
	int n;
	int x;
	int y;
}p[400];
int cmp(const void *a,const void *b)
{   
    return ((peanut *)b)->n-((peanut *)a)->n;
}
int main()
{
	int M,N,K;
	int i,j,k=0,tot=0,cons=0,det=0;
	scanf("%d%d%d",&M,&N,&K);
	memset(p,0,sizeof(p));
	for(i=0;i<M;i++)
	{
		for(j=0;j<N;j++)
		{
			p[k].x=i;
			p[k].y=j;
			scanf("%d",&p[k++].n);
		}
	}
	qsort(p,M*N,sizeof(peanut),cmp);
	for(i=0;p[i].n!=0 && tot<K;i++)
	{
		if(i!=0)
		det=abs(p[i+1].x-p[i].x)+abs(p[i+1].y-p[i].y);
		if(i==0)
		{
			if((2*p[i].x+3)>K)
		    break;
		    else if((2*p[i].x+3)==K)
		    {
			    cons+=p[i].n;
			    break;
		    }
		    else
		    {
			    tot+=p[i].x+2;
			    cons+=p[i].n;
			    det=abs(p[1].x-p[0].x)+abs(p[1].y-p[0].y);
			    if((tot+det+1+p[i+1].x+1)>K)
			    break;
			    else
			    {
				    tot+=det+1;
				    cons+=p[i+1].n;
			    }
		    }
		}
		else if((tot+det+1+p[i+1].x+1)<=K)
		{
			tot+=det+1;
			cons+=p[i+1].n;
		}
		else
		break;
	}
	printf("%d",cons);
	return 0;
}

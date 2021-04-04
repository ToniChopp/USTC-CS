#include<stdio.h>
#include<string.h> 
#include<math.h>
struct Team
{
	int Rank;
	int Score;
	int FGD;
	int GD;
	int PGD;
	int Goal;
	int Lose;
	char cons;
}t[10];
struct Result
{
	int get1;
	char c;
	int get2;
	int delta;
}r[15];
int main()
{
	unsigned int i,j,k=0,a[10],p,q,m,n,tem;
	memset(t,0,sizeof(t));
	memset(r,0,sizeof(r)); 
	for(i=0;i<6;i++)
	{
		scanf("%d%c%d",&r[i].get1,&r[i].c,&r[i].get2);
		r[i].delta=r[i].get1-r[i].get2;
	}
	t[0].Goal=r[0].get1+r[2].get1+r[5].get2;
	t[0].Lose=r[0].get2+r[2].get2+r[5].get1;
	t[1].Goal=r[0].get2+r[3].get2+r[4].get1;
	t[1].Lose=r[0].get1+r[3].get1+r[4].get2;
	t[2].Goal=r[1].get1+r[2].get2+r[4].get2;
	t[2].Lose=r[1].get2+r[2].get1+r[4].get1;
	t[3].Goal=r[1].get2+r[3].get1+r[5].get1;
	t[3].Lose=r[1].get1+r[3].get2+r[5].get2;
	for(i=0;i<4;i++)
	{
		t[i].GD=t[i].Goal-t[i].Lose;
		t[i].PGD=abs(t[i].Goal-t[i].Lose);
		if(t[i].Goal>=t[i].Lose)
		{
			t[i].FGD='+';
		}
		else
		    t[i].FGD='-';
	}
	if(r[0].delta>0)
	    t[0].Score+=3;
	else if(r[0].delta==0)
	{
		t[0].Score+=1;
		t[1].Score+=1;
	}
	else if(r[0].delta<0)
	    t[1].Score+=3;
	if(r[1].delta>0)
	    t[2].Score+=3;
	else if(r[1].delta==0)
	{
		t[2].Score+=1;
		t[3].Score+=1;
	}
	else if(r[1].delta<0)
	    t[3].Score+=3;
	if(r[2].delta>0)
	    t[0].Score+=3;
	else if(r[2].delta==0)
	{
		t[0].Score+=1;
		t[2].Score+=1;
	}
	else if(r[2].delta<0)
	    t[2].Score+=3;
	if(r[3].delta>0)
	    t[3].Score+=3;
	else if(r[3].delta==0)
	{
		t[3].Score+=1;
		t[1].Score+=1;
	}
	else if(r[3].delta<0)
	    t[1].Score+=3;
	if(r[4].delta>0)
	    t[1].Score+=3;
	else if(r[4].delta==0)
	{
		t[1].Score+=1;
		t[2].Score+=1;
	}
	else if(r[4].delta<0)
	    t[2].Score+=3; 
	if(r[5].delta>0)
	    t[3].Score+=3;
	else if(r[5].delta==0)
	{
		t[3].Score+=1;
		t[0].Score+=1;
	}
	else if(r[5].delta<0)
	    t[0].Score+=3;   
	for(i=0;i<4;i++)
	{
		a[k]=t[i].Score;
		k++;
	} 
	if((a[0]>=a[1])&&(a[0]>=a[2])&&(a[0]>=a[3]))
	{
		p=0;
		if((a[1]>=a[2])&&(a[1]>=a[3]))
		{
			m=1;
			if(a[2]>=a[3])
			{
				n=2;
				q=3;
			}
			else if(a[2]<a[3])
			{
				n=3;
				q=2;
			}
		}
		else if((a[2]>=a[1])&&(a[2]>=a[3]))
		{
			m=2;
			if(a[1]>=a[3])
			{
				n=1;
				q=3;
			}
			else if(a[1]<a[3])
			{
				n=3;
				q=1;
			}
		}
		else if((a[3]>=a[1])&&(a[3]>=a[2]))
		{
			m=3;
			if(a[1]>=a[2])
			{
				n=1;
				q=2;
			}
			else if(a[1]<a[2])
			{
				n=2;
				q=1;
			}
		}
	}
	if((a[1]>=a[0])&&(a[1]>=a[2])&&(a[1]>=a[3]))
	{
		p=1;
		if((a[0]>=a[2])&&(a[0]>=a[3]))
		{
			m=0;
			if(a[2]>=a[3])
			{
				n=2;
				q=3;
			}
			else if(a[2]<a[3])
			{
				n=3;
				q=2;
			}
		}
		else if((a[2]>=a[0])&&(a[2]>=a[3]))
		{
			m=2;
			if(a[0]>=a[3])
			{
				n=0;
				q=3;
			}
			else if(a[0]<a[3])
			{
				n=3;
				q=0;
			}
		}
		else if((a[3]>=a[0])&&(a[3]>=a[2]))
		{
			m=3;
			if(a[0]>=a[2])
			{
				n=0;
				q=2;
			}
			else if(a[0]<a[2])
			{
				n=2;
				q=0;
			}
		}
	}
	if((a[2]>=a[0])&&(a[2]>=a[1])&&(a[2]>=a[3]))
	{
		p=2;
		if((a[0]>=a[1])&&(a[0]>=a[3]))
		{
			m=0;
			if(a[1]>=a[3])
			{
				n=1;
				q=3;
			}
			else if(a[1]<a[3])
			{
				n=3;
				q=1;
			}
		}
		else if((a[1]>=a[0])&&(a[1]>=a[3]))
		{
			m=1;
			if(a[0]>=a[3])
			{
				n=0;
				q=3;
			}
			else if(a[0]<a[3])
			{
				n=3;
				q=0;
			}
		}
		else if((a[3]>=a[0])&&(a[3]>=a[1]))
		{
			m=3;
			if(a[0]>=a[1])
			{
				n=0;
				q=1;
			}
			else if(a[0]<a[1])
			{
				n=0;
				q=1;
			}
		}
	}
	if((a[3]>=a[0])&&(a[3]>=a[1])&&(a[3]>=a[2]))
	{
		p=3;
		if((a[0]>=a[1])&&(a[0]>=a[2]))
		{
			m=0;
			if(a[1]>=a[2])
			{
				n=1;
				q=2;
			}
			else if(a[1]<a[2])
			{
				n=2;
				q=1;
			}
		}
		else if((a[1]>=a[0])&&(a[1]>=a[2]))
		{
			m=1;
			if(a[0]>=a[2])
			{
				n=0;
				q=2;
			}
			else if(a[0]<a[2])
			{
				n=2;
				q=0;
			}
		}
		else if((a[2]>=a[0])&&(a[2]>=a[1]))
		{
			m=2;
			if(a[0]>=a[1])
			{
				n=0;
				q=1;
			}
			else if(a[1]<a[0])
			{
				n=1;
				q=0;
			}
		}
	}
	if(t[p].Score==t[m].Score)
	{
		if(t[p].GD<t[m].GD)
		{
			tem=p;
		    p=m;
		    m=tem;
		}
		else if(t[p].GD==t[m].GD)
		{
			if(t[p].Goal<t[m].Goal)
			{
				tem=p;
		        p=m;
		        m=tem;
			}
		}
	}
	if(t[m].Score==t[n].Score)
	{
		if(t[m].GD<t[n].GD)
		{
			tem=m;
		    m=n;
		    n=tem;
		}
		else if(t[m].GD==t[n].GD)
		{
			if(t[m].Goal<t[n].Goal)
			{
				tem=m;
		        m=n;
		        n=tem;
			}
		}
	}
	if(t[n].Score==t[q].Score)
	{
		if(t[n].GD<t[q].GD)
		{
			tem=n;
		    n=q;
		    q=tem;
		}
		else if(t[n].GD==t[q].GD)
		{
			if(t[n].Goal<t[q].Goal)
			{
				tem=n;
		        n=q;
		        q=tem;
			}
		}
	}
	t[m].Rank=2;
	t[n].Rank=3;
	t[p].Rank=1;
	t[q].Rank=4;
	for(i=0;i<4;i++)
	{
		if(t[i].Rank<=2)
		{
			t[i].cons='Y';
		}
		else t[i].cons='N';
	}
	for(i=0;i<4;i++)
	{
		printf("%d %d %c%d %d %d %c\n",t[i].Rank,t[i].Score,t[i].FGD,t[i].PGD,t[i].Goal,t[i].Lose,t[i].cons);
	}
	return 0;
 } 

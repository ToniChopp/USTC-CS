#include<stdio.h>
#include<string.h>
#define N 1001
char map[N][N];
int m=0,n=0;
void dfs(int x,int y)
{
	map[x][y]='.';
	if(x>0&&map[x-1][y]=='*') dfs(x-1,y);
	if(x<m&&map[x+1][y]=='*') dfs(x+1,y);
	if(x>0&&map[x][y-1]=='*') dfs(x,y-1);
	if(x<m&&map[x][y+1]=='*') dfs(x,y+1);
 } 
int main()
{
	int i,j,count=0;
	memset(map,0,sizeof(map));
	for(i=0;i<N;i++)
	{
		scanf("%c",&map[0][i]);
		if(map[0][i]=='\n')
		{
			m=i;
			break;
		}
	}
	for(i=1;i<m;i++)
	{
		scanf("%s",map[i]);
	}
	n=m;
	for(i=0;i<=m;i++)
	for(j=0;j<=n;j++)
	if(map[i][j]=='*')
    {
    	dfs(i,j);
		count++;
	}
	printf("%d",count);
	return 0; 
}

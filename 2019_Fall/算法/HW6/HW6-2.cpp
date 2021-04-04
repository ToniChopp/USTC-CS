#include <stdio.h>
#include <string.h>
#include<iostream>
#include<stack>
using namespace std;
int dp[5000000];
 
void init(int n)
{
	for (int i = 0; i <= n; i++)
	{
		dp[i] = i;
	}
}
 
int find(int x)//查找
{
	if (dp[x] == x)
		return x;
	return dp[x] = find(dp[x]);
}
 
void merge(int x, int y)//合并
{
	int xx = find(x);
	int yy = find(y);
	if (xx < yy)
	{
		dp[yy] = xx;
	}
	else if (xx>yy)
	{
		dp[xx] = yy;
	}
}
 
int main() 
{
	int n, m, k;
	while (cin >> n >> k >> m)
	{
		init(n);
		int x, y;
		for (int i = 0; i < m; i++)
		{
			scanf("%d%d", &x, &y);
			if (dp[x] != dp[y])
			{
				merge(x, y);
			}
		}
		for (int i = 0; i < k; i++)
		{
			scanf("%d%d", &x, &y);
			if (find(x)==find(y))
				printf("1\n");
			else
			{
				printf("0\n");
			}
		}
 
	}
	return 0;
}

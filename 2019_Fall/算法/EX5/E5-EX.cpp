#include<stdio.h>
#include<stdlib.h>
#include<string.h>
const int MAXM = 1e5+10;
const int MAXN = 5e3+10;

int min(int a,int b)
{
    if(a <= b)
        return a;
    return b;
}

int max(int a,int b)
{
    if(a >= b)
        return a;
    return b;
}

struct Edge
{
    int to, next;
}edge[MAXM], edge0[MAXM];   //edge为初始图， edge0为重建图
int total, head[MAXN], total1, head0[MAXN];

int Index, dfn[MAXN], low[MAXN];
int top, Stack[MAXN], instack[MAXN];
int scc, belong[MAXN], num[MAXN];
int dp[MAXN];

void addedge(int u, int v, Edge edge[], int head[], int &total)
{
    edge[total].to = v;
    edge[total].next = head[u];
    head[u] = total++;
}

void Tarjan(int u)
{
    dfn[u] = low[u] = ++Index;
    Stack[top++] = u;
    instack[u] = true;
    for(int i = head[u]; i!=-1; i = edge[i].next)
    {
        int v = edge[i].to;
        if(!dfn[v])
        {
            Tarjan(v);
            low[u] = min(low[u], low[v]);
        }
        else if(instack[v])
            low[u] = min(low[u], dfn[v]);
    }

    if(dfn[u]==low[u])
    {
        int v;
        scc++;
        do
        {
            v = Stack[--top];
            instack[v] = false;
            belong[v] = scc;
            num[scc]++;
        }while(v!=u);
    }
}

int dfs(int u)
{
    if(dp[u]!=-1) return dp[u];
    dp[u] = num[u];
    for(int i = head0[u]; i!=-1; i = edge0[i].next)
    {
        int v = edge0[i].to;
        dp[u] = max(dp[u], num[u]+dfs(v));
    }
    return dp[u];
}

void init()
{
    total = total1 = 0;
    memset(head, -1, sizeof(head));
    memset(head0, -1, sizeof(head0));

    Index = top = 0;
    memset(dfn, 0, sizeof(dfn));
    memset(low, 0, sizeof(low));
    memset(instack, 0, sizeof(instack));

    scc = 0;
    memset(num, 0, sizeof(num));
    memset(dp, -1, sizeof(dp));
}

int main()
{
    int n, m;
    scanf("%d%d", &n, &m);
    init();
    for(int i = 1; i<=m; i++)
    {
        int u, v;
        scanf("%d%d", &u, &v);
        addedge(u, v, edge, head, total);
    }

    for(int i = 1; i<=n; i++)
        if(!dfn[i])
            Tarjan(i);

    for(int u = 1; u<=n; u++)
    {  //重建建图
        for(int i = head[u]; i!=-1; i = edge[i].next)
        {
            int tmpu = belong[u];
            int tmpv = belong[edge[i].to];
            if(tmpu!=tmpv)
                addedge(tmpu, tmpv, edge0, head0, total1);
        }
    }

    int ans = 0;
    for(int i = 1; i<=scc; i++)
        if(dp[i]==-1)
            ans = max(ans, dfs(i));
    
    printf("%d ", ans);
    return 0;
}
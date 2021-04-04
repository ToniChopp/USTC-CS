#include<cstdio>
#include<cstring>
#include<algorithm>
#include<queue>
using namespace std;
const int inf=1e9;

int n,m,x,y,z,MaxFlow,deep[40001];/* deep深度 */
struct Edge{
    int next;
    int to;
    int dis;
}Edge[40001];
int num_Edge = -1;
int head[40001],cur[40001];/* cur用于复制head */
queue <int> q;

void add_Edge(int from,int to,int dis,bool flag)
{
    Edge[++num_Edge].next = head[from];
    Edge[num_Edge].to = to;
    if (flag) 
        Edge[num_Edge].dis = dis;/* 反图的边权为 0 */
    head[from] = num_Edge;
}

//BFS用来分层 
bool BFS(int s,int t)
{
    memset(deep,0x7f,sizeof(deep));
    while (!q.empty()) 
        q.pop();
    for (int i=1; i<=n; i++) 
        cur[i]=head[i];
    deep[s] = 0;
    q.push(s);

    while (!q.empty())
    {
        int now = q.front(); 
        q.pop();
        for (int i=head[now]; i!=-1; i=Edge[i].next)
        {
            if (deep[Edge[i].to]>inf && Edge[i].dis)/* dis在此处用来做标记 是正图还是反图 */
            {
                deep[Edge[i].to] = deep[now]+1;
                q.push(Edge[i].to);
            }
        }
    }
    if (deep[t] < inf) 
        return true;
    else 
        return false;
}

//DFS找增加的流的量 
int DFS(int now,int t,int limit)/* limit为源点到这个点的路径上的最小边权 */ 
{
    if (!limit || now == t) 
        return limit;
    int flow = 0;
    int f;
    for (int i=cur[now]; i!=-1; i=Edge[i].next)
    {
        cur[now] = i;
        if (deep[Edge[i].to]==deep[now]+1 && (f=DFS(Edge[i].to,t,min(limit,Edge[i].dis))))
        {
            flow += f;
            limit -= f;
            Edge[i].dis -= f;
            Edge[i^1].dis += f;
            if (!limit) break;
        }
    }
    return flow;
}

void Dinic(int s,int t)
{
    while (BFS(s,t))
    {
        MaxFlow += DFS(s,t,inf);
    }
}

int main()
{
    memset(head,-1,sizeof(head));
    int s,t;
    scanf("%d%d%d%d",&n,&m,&s,&t);
    for (int i=1; i<=m; i++)
    {
        scanf("%d%d%d",&x,&y,&z);
        add_Edge(x,y,z,1); 
        add_Edge(y,x,z,0);
    }
    Dinic(s,t);
    printf("%d",MaxFlow);
    return 0;
}
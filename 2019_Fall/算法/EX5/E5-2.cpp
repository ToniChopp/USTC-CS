#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<set>
#define SMALL 0
#define EQUAL 1
#define BIG 2
#define MAX 100000

int count = 0;
int h[100001];
int size[100001];

struct PATH{
    int U;
    int V;
    int W;
}path[1000000];
struct PATH route[1000000];

typedef struct TreeNode{
    struct PATH PathNode;
    struct TreeNode *left;
    struct TreeNode *right;
}BST;

int Compare(struct PATH a,struct PATH b)
{
    if(a.U < b.U)
    {
        return SMALL;
    }
    else if((a.U == b.U) && (a.V == b.V))
        return EQUAL;
    return BIG;
}

BST* NewNode(struct PATH a)
{
    struct TreeNode *Node = (BST*)malloc(sizeof(struct TreeNode));
    Node->PathNode.U = a.U;
    Node->PathNode.V = a.V;
    Node->PathNode.W = a.W;
    Node->left = NULL;
    Node->right = NULL;
    return Node; 
}

BST* Insert(BST *N,int i,struct PATH *path)
{
    struct PATH a = path[i];
    if(N == NULL)
        return (NewNode(a));
    else if(Compare(a,N->PathNode) == SMALL)
        N->left = Insert(N->left,i,path);
    else if(Compare(a,N->PathNode) == BIG)
        N->right = Insert(N->right,i,path);
    else if(Compare(a,N->PathNode) == EQUAL)
    {
        if(a.W < N->PathNode.W)
            N->PathNode.W = a.W;
    }
    return N;
}

void Inorder_Travers(BST *Root)
{
    if(Root == NULL)
        return;
    else
    {
        Inorder_Travers(Root->left);
        route[count].U = Root->PathNode.U;
        route[count].V = Root->PathNode.V;
        route[count].W = Root->PathNode.W;
        count++;
        Inorder_Travers(Root->right);
    }  
}

typedef struct Edge_Node{                  /* 边表 */
    int end;                /* 邻顶 */
    int lenth;              /* 边长 */
    struct Edge_Node *next;
}EdgeNode;

typedef struct Adjicent_List{               
    EdgeNode *start = NULL;
    EdgeNode *end = NULL;
    std::set<int> VertexList;
}AdjList;
AdjList Vertex[100000];

struct HeapNode{
    int end;
    int lenth;
}H[100000];

struct Heap{
    struct HeapNode *Heap_Element;
    int Heap_Size;
}Heap;

void Heapify(struct Heap heap,int i)
{
    int left = 2*i;
    int right = 2*i+1;
    int min;
    if((left < heap.Heap_Size) && (heap.Heap_Element[left].lenth < heap.Heap_Element[i].lenth))
        min = left;
    else
    {
        min = i;
    }
    if((right < heap.Heap_Size) && (heap.Heap_Element[right].lenth < heap.Heap_Element[min].lenth))
        min = right;
    if(min != i)
    {
        struct HeapNode tmp = Heap.Heap_Element[i];
        Heap.Heap_Element[i] = Heap.Heap_Element[min];
        Heap.Heap_Element[min] = tmp;
        int tmp1 = h[i];
        h[i] = h[min];
        h[min] = tmp1;
        size[h[i]] = i;
        size[h[min]] = min;
        Heapify(heap,min);
    }
}

EdgeNode *Find_Node(int target,AdjList list)             /* 在邻接表中找目的结点 */
{
    EdgeNode *temp = list.start;
    while(temp != NULL)
    {
        if(temp->end == target)
            return temp;
        temp = temp->next;
    }
    return NULL;
}

void Build_Heap(struct Heap h,int size)
{
    for(int i=size/2;i>0;i--)
        Heapify(h,i);
}

int main() 
{
    int N,M,S,T;
    scanf("%d %d %d %d",&N,&M,&S,&T);
    int i,j;
    BST *root = NULL;
    for(i=0;i<M;i++)
    {
        scanf("%d %d %d",&path[i].U,&path[i].V,&path[i].W);
    }
    for(i=0;i<M;i++)
    {
        root = Insert(root,i,path);
    }
    Inorder_Travers(root);
    for(i=0;i<count;i++)
    {    
        EdgeNode *temp = (EdgeNode*)malloc(sizeof(EdgeNode));
        temp->end = route[i].V;
        temp->lenth = route[i].W;
        temp->next = NULL;
        if(Vertex[route[i].U].start == NULL)
            Vertex[route[i].U].start = temp;
        else
            Vertex[route[i].U].end->next = temp;
        Vertex[route[i].U].end = temp;
        Vertex[route[i].U].VertexList.insert(route[i].V);
    }

    for(i=1;i<=N;i++)
    {
        H[i].end = i;
        h[i] = i;
        size[i] = i;
        if(S == i)
        {
            H[i].lenth = 0;
        }
        else
        {
            EdgeNode *found = Find_Node(i,Vertex[S]);
            if(found == NULL)
                H[i].lenth = MAX;
            else
                H[i].lenth = found->lenth;
        }   
    }

    Heap.Heap_Element = H;
    Heap.Heap_Size = N;
    Build_Heap(Heap,N);             /* Build and Extract min */
    struct HeapNode temp = H[1];
    H[1] = H[Heap.Heap_Size];
    H[Heap.Heap_Size] = temp;
    h[1] = H[1].end;
    h[Heap.Heap_Size] = H[Heap.Heap_Size].end;
    size[h[1]] = 1;
    size[h[Heap.Heap_Size]] = Heap.Heap_Size;
    Heap.Heap_Size--;
    Heapify(Heap,1);

    int destination;
    int result;
    for(i=1;i<N;i++)
    {
        destination = H[1].end;
        result = H[1].lenth;
        if(destination == T)
            break;
        else
        {
            struct HeapNode temp = H[1];
            H[1] = H[Heap.Heap_Size];
            H[Heap.Heap_Size] = temp;
            int tmp = h[Heap.Heap_Size];
            h[Heap.Heap_Size] = h[1];
            h[1] = tmp;
            size[h[1]] = 1;
            size[h[Heap.Heap_Size]] = Heap.Heap_Size;
            Heap.Heap_Size--;
            Heapify(Heap,1);
            for(auto node = Vertex[destination].start ; node!=NULL ; node=node->next)
            {
                if(H[size[node->end]].lenth > (result+node->lenth))
                {
                    int current = size[node->end];
                    H[size[node->end]].lenth = result+node->lenth;
                    while((H[current].lenth < H[current/2].lenth) && (current > 1))
                    {
                        struct HeapNode temp = H[current];
                        H[current] = H[current/2];
                        H[current/2] = temp;
                        int tmp = h[current];
                        h[current] = h[current/2];
                        h[current/2] = tmp;
                        size[h[current]] = current;
                        size[h[current/2]] = current/2;
                        current /= 2;
                    }
                }
            }
        }
    }
    if(result == 100000)
        result = -1;
    printf("%d",result);
    return 0;
}
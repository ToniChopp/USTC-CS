#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<math.h>
#include<float.h>
int Cache[10005];

struct Data_Sequence{
    int time;
    int position;
};

typedef struct FibNode{
    struct Data_Sequence k;
    int degree;
    FibNode *left;
    FibNode *right;
    FibNode *parent;
    FibNode *child;
    int marked;
}FibNode;

typedef struct FibHeap{
    int KeyNum;      /* Num of Node in the heap */
    int MaxDegree;
    FibNode *min;    /* MinNode */
    FibNode **cons;  /* 在删除节点时来暂时保存堆数据的临时空间 */
}FibHeap;

int Compare(struct Data_Sequence a,struct Data_Sequence b)
{
    if(a.time < b.time)
        return 1;
    return 0;
}

void Remove_FibNode(FibNode *Node)       /* Delete Node from the root DuLinklist */
{
    Node->left->right = Node->right;
    Node->right->left = Node->left;
}

void Add_FibNode(FibNode *root,FibNode *Node)  /* Add node to the root DuLinklist */
{
    Node->left = root->left;
    root->left->right = Node;
    Node->right = root;
    root->left = Node;
}

void Cat_FibNode(FibNode *a,FibNode *b)          /* Cat b to a */
{
    FibNode *tmp;
    tmp = a->right;
    a->right = b->right;
    b->right->left = a;
    b->right = tmp;
    tmp->left = b;
}

FibHeap* Create_Heap()         /* Create a new Fibonacci heap */
{
    FibHeap *Heap;
    Heap = (FibHeap*)malloc(sizeof(FibHeap));
    if(Heap == NULL)
        return NULL;
    Heap->KeyNum = 0;
    Heap->MaxDegree = 0;
    Heap->min = NULL;
    Heap->cons = NULL;
    return Heap;
}

FibNode* Create_Node(int time,int position)
{
    FibNode *Node;
    Node = (FibNode*)malloc(sizeof(FibNode));
    if(Node == NULL)
        return NULL;
    Node->k.time = time;
    Node->k.position = position;
    Node->degree = 0;
    Node->left = Node;
    Node->right = Node;
    Node->parent = NULL;
    Node->child = NULL;
    return Node;
}

void FibHeap_Insert_Node(FibHeap *Heap,FibNode *Node)
{
    if(Heap->KeyNum == 0)
        Heap->min = Node;
    else
    {
        Add_FibNode(Heap->min,Node);
        if(Node->k.time < Heap->min->k.time)
            Heap->min = Node;
    }
    Heap->KeyNum ++;
}

void FibHeap_Insert_Key(FibHeap *Heap,int time,int position)
{
    FibNode *Node;
    if(Heap == NULL)
        return;
    Node = Create_Node(time,position);
    if(Node == NULL)
        return;
    FibHeap_Insert_Node(Heap,Node);
}

FibHeap* Union(FibHeap *a,FibHeap *b)
{
    FibHeap *tmp;
    if(a == NULL)
        return b;
    if(b == NULL)
        return a;
    if(a->MaxDegree < b->MaxDegree)     /* Make sure a.degree >= b.degree */
    {
        tmp = a;
        a = b;
        b = tmp;
    }
    if(a->min == NULL)
    {
        a->min = b->min;
        a->KeyNum = b->KeyNum;
        free(b->cons);
        free(b);
    }
    else if(b->min == NULL)
    {
        free(b->cons);
        free(b);
    }
    else
    {
        Cat_FibNode(a->min,b->min);
        if(Compare(a->min->k,b->min->k) == 0)
            a->min = b->min;
        a->KeyNum += b->KeyNum;
        free(b->cons);
        free(b);
    }
    return a;
}

FibNode *FibHeap_Remove_Min(FibHeap *Heap)
{
    FibNode *Min = Heap->min;
    if(Heap->min == Min->right)
        Heap->min = NULL;
    else
    {
        Remove_FibNode(Min);
        Heap->min = Min->right;
    }
    Min->left = Min->right = Min;
    return Min;
}

void FibHeap_Link(FibHeap *Heap,FibNode *Node,FibNode *root)    /* Link node to the root */
{
    Remove_FibNode(Node);
    if(root->child == NULL)
        root->child = Node;
    else
        Add_FibNode(root->child,Node);
    Node->parent = root;
    root->degree ++;
    Node->marked = 0;
}

void FibHeap_Create_cons(FibHeap *Heap)     /* 创建fib_heap_consolidate所需空间 */
{
    int old = Heap->MaxDegree;
    Heap->MaxDegree = log((double)(Heap->KeyNum))/log((double)(2.0))+1;
    if(old >= Heap->MaxDegree)
        return;
    else
        Heap->cons = (FibNode**)realloc(Heap->cons,sizeof(FibHeap*)*(Heap->MaxDegree+1));
}

void FibHeap_Consolidate(FibHeap *Heap)     /* 合并斐波那契堆的根链表中左右相同度数的树 */
{
    int i,d,D;
    FibNode *x,*y,*tmp;
    FibHeap_Create_cons(Heap);
    D = Heap->MaxDegree+1;
    for(i=0;i<D;i++)
    {
        Heap->cons[i] = NULL;
    }
    while(Heap->min != NULL)
    {
        x = FibHeap_Remove_Min(Heap);
        d = x->degree;
        while (Heap->cons[d] != NULL)
        {
            y = Heap->cons[d];
            if(x->k.time > y->k.time)
            {
                tmp = x;
                x = y;
                y = tmp;
            }
            FibHeap_Link(Heap,y,x);
            Heap->cons[d] = NULL;
            d++;
        }
        Heap->cons[d] = x;
    }
    Heap->min = NULL;
    for(i=0;i<D;i++)
    {
        if(Heap->cons[i] != NULL)
        {
            if(Heap->min == NULL)
                Heap->min = Heap->cons[i];
            else
            {
                Add_FibNode(Heap->min,Heap->cons[i]);
                if(Compare(Heap->cons[i]->k,Heap->min->k) == 1)
                    Heap->min = Heap->cons[i];
            }
        }
    }
}

FibNode* FibHeap_Extract_Min(FibHeap *Heap)       /* 删除最小结点 */
{
    if((Heap == NULL) || (Heap->min == NULL))
        return NULL;
    FibNode *child = NULL;
    FibNode *min = Heap->min;
    while(min->child != NULL)
    {
        child = min->child;
        Remove_FibNode(child);
        if(child->right == child)
            min->child = NULL;
        else
            min->child = child->right;
        Add_FibNode(Heap->min,child);
        child->parent = NULL;
    }
    Remove_FibNode(min);
    if(min->right == min)
    {
        Heap->min = NULL;
    }
    else
    {
        Heap->min = min->right;
        FibHeap_Consolidate(Heap);
    }
    Heap->KeyNum --;
    return min;
}

void Renew_Degree(FibNode *parent)
{
    parent->degree --;
}

void FibHeap_Cut(FibHeap *Heap,FibNode * Node,FibNode* parent)
{
    Remove_FibNode(Node);
    Renew_Degree(parent);
    if(Node == Node->right)
        parent->child = NULL;
    else
        parent->child = Node->right;
    Node->parent = NULL;
    Node->left = Node;
    Node->right = Node;
    Node->marked = 0;
    Add_FibNode(Heap->min,Node);
}

void FibHeap_Cascading_Cut(FibHeap *Heap,FibNode *Node)
{
    FibNode *parent = Node->parent;
    if(parent == NULL)
        return;
    if(Node->marked == 0)
        Node->marked = 1;
    else
    {
        FibHeap_Cut(Heap,Node,parent);
        FibHeap_Cascading_Cut(Heap,parent);
    }
}

void FibHeap_Decrease(FibHeap *Heap,FibNode *Node,int key)
{
    FibNode *parent;
    if((Heap == NULL) || (Heap->min == NULL) || (Node == NULL))
        return;
    if(key >= Node->k.time)
        return;
    Node->k.time = key;
    parent = Node->parent;
    if((parent != NULL) && (Node->k.time < parent->k.time))
    {
        FibHeap_Cut(Heap,Node,parent);
        FibHeap_Cascading_Cut(Heap,parent);
    }
    if(Node->k.time < Heap->min->k.time)
        Heap->min = Node;
}

void FibHeap_Increase(FibHeap *Heap,FibNode *Node,int key)
{
    FibNode *child,*parent,*right;
    if((Heap == NULL) || (Heap->min == NULL) || (Node == NULL))
        return;
    if(key <= Node->k.time)
        return;
    while(Node->child != NULL)
    {
        child = Node->child;
        Remove_FibNode(child);
        if(child->right == child)
            Node->child = NULL;
        else
            Node->child = child->right;
        Add_FibNode(Heap->min,child);
        child->parent = NULL;
    }
    Node->degree = 0;
    Node->k.time = key;
    parent = Node->parent;
    if(parent!=NULL)
    {
        FibHeap_Cut(Heap,Node,parent);
        FibHeap_Cascading_Cut(Heap,parent);
    }
    else if(Heap->min == Node)
    {
        right = Node->right;
        while (right != Node)
        {
            if(Node->k.time > right->k.time)
                Heap->min = right;
            right = right->right;
        }
    }
}

void FibHeap_Update(FibHeap *Heap,FibNode *Node,int key)
{
    if(key < Node->k.time)
        FibHeap_Decrease(Heap,Node,key);
    else if(key > Node->k.time)
        FibHeap_Increase(Heap,Node,key);
}

void FibNode_Destroy(FibNode *Node)
{
    FibNode *start = Node;
    if(Node == NULL)
        return;
    do
    {
        FibNode_Destroy(Node->child);
        Node = Node->right;
        free(Node->left);
    } while (Node != start);  
}

void FibHeap_Destroy(FibHeap *Heap)
{
    FibNode_Destroy(Heap->min);
    free(Heap->cons);
    free(Heap);
}

FibNode* FibNode_Search(FibNode *root,int key)
{
    FibNode *t = root;
    FibNode *p = NULL;
    if(root == NULL)
        return root;
    do{
        if(t->k.time == key)
        {
            p = t;
            break;
        }
        else
        {
            if((p = FibNode_Search(t->child,key)) != NULL)
                break;
        }
        t = t->right;
    }while(t != root);
    return p;
}

FibNode* FibHeap_Search(FibHeap *Heap,int key)
{
    if((Heap == NULL) || (Heap->min == NULL))
        return NULL;
    return FibNode_Search(Heap->min,key);
}

int main() {
    int N,K;
    scanf("%d %d",&N,&K);
    int i,j;
    int MISS = 0;
    for(i=0;i<N;i++)
    {
        scanf("%d",&Cache[i]);
    }
    FibHeap *Heap= Create_Heap();
    for(i=0;i<N;i++)
    {
        FibNode *find;
        find = FibNode_Search(Heap->min,N-i);
        if(find == NULL)     /* miss */
        {
            if(Heap->KeyNum < K)
            {
                for(j=i+1;j<N;j++)
                {
                    if(Cache[i] == Cache[j])
                        break;
                }
                FibHeap_Insert_Key(Heap,N-j,Cache[i]);
            }
            else
            {
                FibNode *tmp = FibHeap_Extract_Min(Heap);
                for(j=i+1;j<N;j++)
                {
                    if(Cache[i] == Cache[j])
                        break;
                }
                FibHeap_Insert_Key(Heap,N-j,Cache[i]);
            }
            MISS ++;
        }
        else
        {
            for(j=i+1;j<N;j++)
            {
                if(Cache[i] == Cache[j])
                    break;
            }
            FibHeap_Decrease(Heap,find,N-j);
        }
    }
    FibHeap_Destroy(Heap);
    printf("%d",MISS);
    return 0;
}

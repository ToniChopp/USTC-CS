#include<stdio.h>
#include<stdlib.h>
#include<string.h>

typedef struct INTERVAL{
    int low;
    int high;
    int max;
    int height;
    struct INTERVAL *left;
    struct INTERVAL *right;
}ITVNODE;

int MAX(int a,int b,int c)
{
    if(a >= b && a >= c)
        return a;
    else if(b >= a && b >= c)
        return b;
    else if(c >= a && c >= b)
        return c;
}

int height(struct INTERVAL *N)
{
    if(N==NULL)
        return 0;
    else
        return N->height;
}

ITVNODE* newnode(int x,int y)
{
    struct INTERVAL *node = (ITVNODE*)malloc(sizeof(struct INTERVAL));
    node->low=x;
    node->high=y;
    node->max=y;
    node->height=1;
    node->left=NULL;
    node->right=NULL;
    return node;
}

ITVNODE* LL_Rotate(ITVNODE *y)
{
    ITVNODE *x=y->left;
    y->left=x->right;
    x->right=y;
    if(y->right && y->left)
        y->max = MAX(y->high,y->left->max,y->right->max);
    else if(y->left)
        y->max = MAX(y->high,y->left->max,0);
    else if(y->right)
        y->max = MAX(y->high,y->right->max,0);
    else
        y->max = y->high;
    if(x->right && x->left)
        x->max = MAX(x->high,x->left->max,x->right->max);
    else if(x->left)
        x->max = MAX(x->high,x->left->max,0);
    else if(x->right)
        x->max = MAX(x->high,x->right->max,0);
    else
        x->max = x->high;
    y->height=MAX(height(y->left),height(y->right),-10)+1;
    x->height=MAX(height(x->left),height(x->right),-10)+1;
    return x;
}

ITVNODE* RR_Rotate(ITVNODE *y)
{
    ITVNODE *x=y->right;
    y->right=x->left;
    x->left=y;
    if(y->left && y->right)
        y->max = MAX(y->high,y->left->max,y->right->max);
    else if(y->right)
        y->max = MAX(y->high,y->right->max,0);
    else if(y->left)
        y->max = MAX(y->high,y->left->max,0);
    else
        y->max = y->high;
    if(x->right && x->left)
        x->max = MAX(x->high,x->left->max,x->right->max);
    else if(x->left)
        x->max = MAX(x->high,x->left->max,0);
    else if(x->right)
        x->max = MAX(x->high,x->right->max,0);
    else
        x->max = x->high;
    y->height=MAX(height(y->left),height(y->right),-10)+1;
    x->height=MAX(height(x->left),height(x->right),-10)+1;
    return x;
}

int Get_BF(ITVNODE *N)                        /* get balance factor */
{
    if(N==NULL)
        return 0;
    else
        return height(N->left)-height(N->right);
}

ITVNODE* Insert(ITVNODE *N,int x,int y)
{
    if(N==NULL)
    {
        return(newnode(x,y));
    }
    if(x < N->low)
    {
        N->left=Insert(N->left,x,y);
        if(N->right)
            N->max=MAX(N->high,N->left->max,N->right->max);
        else
            N->max=MAX(N->high,N->left->max,0);
    }
    else if(x > N->low)
    {
        N->right=Insert(N->right,x,y);
        if(N->left)
            N->max=MAX(N->high,N->left->max,N->right->max);
        else
            N->max=MAX(N->high,N->right->max,0);
    }
    else
    {
        return N;
    }
    N->height=MAX(height(N->left),height(N->right),0)+1;
    int BF=Get_BF(N);
    if(BF > 1 && x < N->left->low)                /* LL_Rotate  */
    {
        return LL_Rotate(N);
    }
    else if(BF > 1 && x > N->left->low)           /* LR_Rotate  */
    {
        N->left=RR_Rotate(N->left);
        return LL_Rotate(N);
    }
    else if(BF < -1 && x > N->right->low)         /* RR_Rotate  */
    {
        return RR_Rotate(N);
    }
    else if(BF < -1 && x < N->right->low)        /* RL_Rotate   */
    {
        N->right=LL_Rotate(N->right);
        return RR_Rotate(N);
    }
    return N;
}

int OVERLAP(ITVNODE *a,int x,int y)
{
    if(a->high < x || a->low > y)  /* do not overlap */
        return 0;
    else
        return 1;
}

ITVNODE* FIND_OVERLAP(struct INTERVAL *root,int x,int y)
{
    while(root != NULL && !OVERLAP(root,x,y))
    {
        if(root->left != NULL && root->left->max >= x)
            root=root->left;
        else
            root=root->right;
    }
    return root;
}

int main()
{
    int n;
    int x,y;
    scanf("%d",&n);
    int i=0;
    ITVNODE *root = NULL;
    struct INTERVAL *node = (ITVNODE*)malloc(sizeof(struct INTERVAL));
    while(i < n)
    {
        scanf("%d %d",&x,&y);
        node = FIND_OVERLAP(root,x,y);
        if(node == NULL)
        {
            root = Insert(root,x,y);
            printf("0\n");
        }
        else
            printf("-1\n");
        i++;
    }
    return 0;
}
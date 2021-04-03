#include<stdio.h>
#include<stdlib.h>
#include<string.h>

typedef struct Node{
    int key;
    struct Node *left;
    struct Node *right;
    int height;
}BTNode;

int max(int a,int b)
{
    if(a > b)
        return a;
    else
        return b;
}

int height(struct Node *N)
{
    if(N==NULL)
        return 0;
    else
        return N->height;
}

BTNode* newnode(int key)
{
    struct Node *node = (BTNode*)malloc(sizeof(struct Node));
    node->key=key;
    node->left=NULL;
    node->right=NULL;
    node->height=1;
    return node;
}

BTNode* LL_Rotate(BTNode *y)
{
    BTNode *x=y->left;
    y->left=x->right;
    x->right=y;
    y->height=max(height(y->left),height(y->right))+1;
    x->height=max(height(x->left),height(x->right))+1;
    return x;
}

BTNode* RR_Rotate(BTNode *y)
{
    BTNode *x=y->right;
    y->right=x->left;
    x->left=y;
    y->height=max(height(y->left),height(y->right))+1;
    x->height=max(height(x->left),height(x->right))+1;
    return x;
}

int Get_BF(BTNode *N)                        /* get balance factor */
{
    if(N==NULL)
        return 0;
    else
        return height(N->left)-height(N->right);
}

BTNode* Insert(BTNode *N,int key)
{
    if(N==NULL)
    {
        return(newnode(key));
    }
    if(key < N->key)
    {
        N->left=Insert(N->left,key);
    }
    else if(key > N->key)
    {
        N->right=Insert(N->right,key);
    }
    else
    {
        return N;
    }
    N->height=max(height(N->left),height(N->right))+1;
    int BF=Get_BF(N);
    if(BF > 1 && key < N->left->key)                /* LL_Rotate  */
    {
        return LL_Rotate(N);
    }
    else if(BF > 1 && key > N->left->key)           /* LR_Rotate  */
    {
        N->left=RR_Rotate(N->left);
        return LL_Rotate(N);
    }
    else if(BF < -1 && key > N->right->key)         /* RR_Rotate  */
    {
        return RR_Rotate(N);
    }
    else if(BF < -1 && key < N->right->key)        /* RL_Rotate   */
    {
        N->right=LL_Rotate(N->right);
        return RR_Rotate(N);
    }
    return N;
}

BTNode * maxValueNode(BTNode* node)    /* Find the max key of node's left child  */
{
    BTNode* current = node;
    if(current->right)
    {
        while (current->right != NULL)
        {
            current = current->right;
        }
    }
    return current;
}

BTNode * minValueNode(BTNode* node)    /* Find the minium key  */
{
    BTNode* current = node;
    while (current->left != NULL)
    {
        current = current->left;
    }
    return current;
}

int FIND_KEY(struct Node *root,int k)
{
    if(root->key==k)
        return root->key;
    else if(root->key > k && root->left)
    {
        BTNode* temp=maxValueNode(root->left);
        if(temp->key <= k)
            return temp->key;
        return FIND_KEY(root->left,k);
    }
    else if(root->key < k && root->right)
    {
        BTNode* tmp=minValueNode(root->right);
        if(tmp->key > k )
            return root->key;
        return FIND_KEY(root->right,k);
    }
}

int main()
{
    int n;
    BTNode *root = NULL;
    scanf("%d",&n);
    int j;
    int a;
    char command[10];
    int k;
    while(1)
    {
        scanf("%s",command);
        if(command[0]=='I')
        {
        	scanf("%d",&k);
            root = Insert(root,k);
        }
        else if(command[0]=='F') 
        {
        	scanf("%d",&k);
            a=FIND_KEY(root,k);
            printf("%d\n",a);
        }
        else if(command[0]=='E')
            return 0;
    }
    return 0;
}
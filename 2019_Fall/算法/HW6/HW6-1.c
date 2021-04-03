#include<stdio.h>
#include<stdlib.h>
#include<string.h>

typedef struct Node{
    int key;
    struct Node *left;
    struct Node *right;
    int height;
    int size;
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
    node->size=1;
    return node;
}

BTNode* LL_Rotate(BTNode *y)
{
    BTNode *x=y->left;
    y->left=x->right;
    x->right=y;
    x->size=y->size;
    if(y->right!=NULL && y->left!=NULL)
        y->size=y->left->size+y->right->size+1;
    else if(y->left != NULL)
        y->size=y->left->size+1;
    else if(y->right != NULL)
        y->size=y->right->size+1;
    else
        y->size=1;
    y->height=max(height(y->left),height(y->right))+1;
    x->height=max(height(x->left),height(x->right))+1;
    return x;
}

BTNode* RR_Rotate(BTNode *y)
{
    BTNode *x=y->right;
    y->right=x->left;
    x->left=y;
    x->size=y->size;
    if(y->right!=NULL && y->left!=NULL)
        y->size=y->left->size+y->right->size+1;
    else if(y->left!=NULL)
        y->size=y->left->size+1;
    else if(y->right!=NULL)
        y->size=y->right->size+1;
    else
        y->size=1;
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
        N->size++;
    }
    else if(key > N->key)
    {
        N->right=Insert(N->right,key);
        N->size++;
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

BTNode * minValueNode(BTNode* node)    /* Find the minium key  */
{
    BTNode* current = node;
    while (current->left != NULL)
    {
        current = current->left;
    }
    return current;
}

BTNode* Delete(BTNode *node,int key)
{
    if(node==NULL)
        return node;
    if(key < node->key)
    {
        node->left=Delete(node->left,key);
        node->size--;
    }
    else if(key > node->key)
    {
        node->right=Delete(node->right,key);
        node->size--;
    }
    else
    {
        if((node->left == NULL) || (node->right == NULL)) 
        {
            BTNode* temp = node->left ? node->left : node->right;
            if(temp==NULL)             /* node->left && node->right =NULL  */
            { 
                temp=node;
                node=NULL;
            }
            else
                *node=*temp;
            free(temp);
        }
        else
        {
            BTNode* temp = minValueNode(node->right);      /* 将被删除的结点的右子树最小叶子补到原位置 */
            node->key = temp->key;
            node->right = Delete(node->right, temp->key);
            if(node->left && node->right)
                node->size = node->left->size+node->right->size+1;
            else if(node->left)
                node->size = node->left->size+1;
            else if(node->right)
                node->size = node->right->size+1;
            else
                node->size = 1;
        }
    }
    if(node==NULL)
    {
        return node;
    }
    node->height=max(height(node->left),height(node->right))+1;
    int BF=Get_BF(node);
    if(BF > 1 && Get_BF(node->left) >= 0)                /* LL_Rotate  */
    {
        return LL_Rotate(node);
    }
    else if(BF > 1 && Get_BF(node->left) < 0)           /* LR_Rotate  */
    {
        node->left=RR_Rotate(node->left);
        return LL_Rotate(node);
    }
    else if(BF <-1 && Get_BF(node->right) <= 0)         /* RR_Rotate  */
    {
        return RR_Rotate(node);
    }
    else if(BF <-1 && Get_BF(node->right) > 0)        /* RL_Rotate  */
    {
        node->right=LL_Rotate(node->right);
        return RR_Rotate(node);
    }
    return node;
}

int AVL_OS_SELECT(struct Node *root,int k)
{
    int r;
    if(root->left)
        r=root->left->size+1;
    else 
        r=1;
    if(r==k)
        return root->key;
    else if(k<r && root->left)
        return AVL_OS_SELECT(root->left,k);
    else if(k>r && root->right)
        return AVL_OS_SELECT(root->right,k-r);
}

int main()
{
    int n;
    BTNode *root = NULL;
    scanf("%d",&n);
    int j;
    int cnt=0;
    int a;
    char command[10];
    int k;
    while(cnt < n)
    {
        scanf("%s",command);
        if(command[0]=='I')
        {
        	scanf("%d",&k);
            if(cnt==0 || root==NULL)
                root = newnode(k);
            else
                root = Insert(root,k);
        }
        else if(command[0]=='D')
        {
        	scanf("%d",&k);
            root = Delete(root,k);
        }
        else if(command[0]=='K') 
        {
        	scanf("%d",&k);
            a=AVL_OS_SELECT(root,k);
            printf("%d\n",a);
        }
        cnt++;
    }
    return 0;
}
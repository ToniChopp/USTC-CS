#include<stdio.h>
#include<stdlib.h>
#include<string.h>

struct Mission
{
    int r;
    int p;
}Mission[100000];

typedef struct TreeNode{
    int r;
    int p;
    struct TreeNode *left;
    struct TreeNode *right;
}BST;

int CMP(struct Mission a,struct Mission b)
{
    if(a.r < b.r)
        return 1;
    else if((a.r == b.r) && (a.p <= b.p))
        return 1;
    else
        return 0;
}

void Quick_Sort(struct Mission a[],int left,int right)
{
    struct Mission tmp;
    if(left >= right)
    return ;
    if(right-left>=3)
    {
        tmp=a[(left+right)/2];
        a[(left+right)/2]=a[left];
        a[left]=tmp;
    }  
    int i = left;
    int j = right;
    struct Mission k=a[i];
    while( i < j)   
    {
        while(i < j && CMP(k,a[j]) == 1) 
        {
		  
            j--;
        }
        a[i]=a[j];
        while(i < j && CMP(a[i],k) == 1)
        {
            i++;
        }
        a[j]=a[i];
    }
    a[i]=k;
    Quick_Sort(a,left,i-1);
    Quick_Sort(a, i +1, right); 
}

BST* NewNode(struct Mission a)
{
    struct TreeNode *Node = (BST*)malloc(sizeof(struct TreeNode));
    Node->r = a.r;
    Node->p = a.p;
    Node->left = NULL;
    Node->right = NULL;
    return Node; 
}

BST* Insert(BST *N,int i,struct Mission *Mission)
{
    struct Mission a = Mission[i];
    if(N == NULL)
        return (NewNode(a));
    if(a.p < N->p)
        N->left = Insert(N->left,i,Mission);
    if(a.p >= N->p)
        N->right = Insert(N->right,i,Mission);
    return N;
}

BST* FindMin(BST *N)
{
    if(N != NULL)
    {
        if(N->left != NULL)
            return (FindMin(N->left));
        return N;
    }
}

BST* Delete(BST *root,int a)
{
    if(root == NULL)
    {
        return root;
    }
    if(a < root->p)
    {
        root->left = Delete(root->left,a);
    }
    else if(a > root->p)
    {
        root->right = Delete(root->right,a);
    }
    else
    {
        if(root->right != NULL)
        {
            BST* tmp = FindMin(root->right);
            root->r = tmp->r;
            root->p = tmp->p;
            root->right = Delete(root->right,tmp->p);
        }
        else
        {
            BST* temp = root->left? root->left:root->right;
            if(temp == NULL)
            {
                temp = root;
                root = NULL;
            }
            free(temp);
        }
    }
    return root;
}

int main()
{
    int N;
    scanf("%d",&N);
    BST *root = NULL;
    int i,j;
    int time = 0;
    int result = 0;
    for(i=0;i<N;i++)
    {
        scanf("%d %d",&Mission[i].r,&Mission[i].p);
    }
    Quick_Sort(Mission,0,N-1);
    /*for(i=0;i<N;i++)
        printf("%d %d \n",Mission[i].r,Mission[i].p);*/
    for(i=0;i<N;i++)
    {
        if(i+1 < N)
        {
            if((Mission[i].r+Mission[i].p <= Mission[i+1].r) && (root == NULL))
            {
                time = Mission[i].r+Mission[i].p;
                result += Mission[i].p;
                /*printf("%da%d ",time,result);*/
            }
            else if((Mission[i].r+Mission[i].p > Mission[i+1].r) && (root == NULL)) 
            {
                time = Mission[i+1].r;
                Mission[i].p -= Mission[i+1].r-Mission[i].r;
                result += Mission[i+1].r-Mission[i].r;
                Mission[i].r = Mission[i+1].r;
                root = Insert(root,i,Mission);
                /*printf("%db%d ",time,result);*/
            }
            else if(root != NULL)
            {
                time = Mission[i].r;
                while((root != NULL) && (FindMin(root)->p <= Mission[i].p))
                {
                    if(time+FindMin(root)->p <= Mission[i+1].r)
                    {
                        time += FindMin(root)->p;
                        result += time-FindMin(root)->r;
                        root = Delete(root,FindMin(root)->p);
                        /*printf("%dc%d ",time,result);*/
                    }
                    else
                    {
                        result += Mission[i+1].r-time;
                        FindMin(root)->p -= Mission[i+1].r-time;
                        FindMin(root)->r += Mission[i+1].r-time;
                        time = Mission[i+1].r;
                        /*printf("%dd%d ",time,result);*/
                        break;
                    }
                }
                if((time+Mission[i].p <= Mission[i+1].r))
                {
                    time += Mission[i].p;
                    result += time-Mission[i].r;
                    /*printf("%de%d ",time,result);*/
                    while((root != NULL) && (time < Mission[i+1].r))
                    {
                        if(time+FindMin(root)->p <= Mission[i+1].r)
                        {
                            time += FindMin(root)->p;
                            result += time-FindMin(root)->r;
                            root = Delete(root,FindMin(root)->p);
                            /*printf("%df%d",time,result);*/
                        }
                        else
                        {
                            result += Mission[i+1].r-time;
                            FindMin(root)->p -= Mission[i+1].r-time;
                            FindMin(root)->r += Mission[i+1].r-time;
                            time = Mission[i+1].r;
                            /*printf("%dg%d ",time,result);*/
                            break;
                        }
                    }
                }
                else if((time+Mission[i].p > Mission[i+1].r) && (time < Mission[i+1].r))
                {
                    Mission[i].p -= Mission[i+1].r-time;
                    result += Mission[i+1].r-time;
                    Mission[i].r += Mission[i+1].r-time;
                    time = Mission[i+1].r;
                    root = Insert(root,i,Mission);
                    /*printf("%dh%d ",time,result);*/
                }
                else if(time >= Mission[i+1].r)
                {
                    root = Insert(root,i,Mission);
                }
            }
        }
        else
        {
            time = Mission[i].r;
            if(root == NULL)
            {
                result += Mission[i].p;
                /*printf("%di%d ",time,result);*/
            }
            else
            {
                while((root != NULL) && (FindMin(root)->p <= Mission[i].p))
                {
                    time += FindMin(root)->p;
                    result += time-FindMin(root)->r;
                    /*printf("r:%dp:%d;",FindMin(root)->r,FindMin(root)->p);*/
                    root = Delete(root,FindMin(root)->p);
                    /*printf("%dj%d ",time,result);*/
                }                
                time += Mission[i].p;
                result += time-Mission[i].r;
                /*printf("%dk%d ",time,result);*/
                while (root != NULL)
                {
                    time += FindMin(root)->p;
                    result += time-FindMin(root)->r;
                    root = Delete(root,FindMin(root)->p);
                    /*printf("%dl%d ",time,result);*/
                }
            }
        }
    }
    printf("%d",result);
    return 0;
}
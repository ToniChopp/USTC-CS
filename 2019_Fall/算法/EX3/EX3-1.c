#include<stdio.h>
#include<stdlib.h>
#include<string.h>

struct DOT{
    int a;
    int b;
}DOT[10000];
int MaxLen[10000];

int Compare(struct DOT m,struct DOT n)
{
    if((m.a <= n.a) && (m.b <= n.b))
        return 1;
    else
        return 0;
}

void CountingSort(struct DOT *A, int n, int k)
{
    int *c;
    struct DOT *b;
    int i;
    c = (int *)malloc(sizeof(int)*k); 
    b = (struct DOT *)malloc(sizeof(struct DOT)*n);
    for (i = 0; i < k; i++)
        c[i] = 0;              
    for (i = 0; i < n; i++)
        c[A[i].a] += 1;               
    for (i = 1; i < k; i++)
        c[i] = c[i - 1] + c[i];    
    for (i = n - 1; i >= 0; i--)
    {
        b[c[A[i].a] - 1] = A[i];     
        c[A[i].a] -= 1;
    }
    for (i = 0; i < n; i++)
        A[i] = b[i];       
    free(c);
    free(b);
}

int main()
{
    int n;
    scanf("%d",&n);
    int i,j;
    int tmp=0;
    for(i=0;i<n;i++)
    {
        scanf("%d %d",&DOT[i].a,&DOT[i].b);
    }
    CountingSort(DOT,n,10000);
    MaxLen[0] = 1;
    for(i=1;i<n;i++)
    {
        tmp=0;
        for(j=0;j<i;j++)
        {
            if(DOT[j].b <= DOT[i].b)
            {
                if(tmp < MaxLen[j])
                    tmp = MaxLen[j];
            }
        }
        MaxLen[i] = tmp+1;
    }
    int Consequence = -1;
    for(i=0;i<n;i++)
    {
        if(Consequence < MaxLen[i])
            Consequence = MaxLen[i];
    }
    printf("%d",Consequence);
}
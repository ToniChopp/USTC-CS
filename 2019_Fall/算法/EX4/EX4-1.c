#include<stdio.h>
#include<stdlib.h>
#include<string.h>

struct Country{
    int x;
    int build;
}Country[100000];

void Quick_Sort(struct Country a[],int left,int right)
{
    struct Country tmp;
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
    struct Country k=a[i];
    while( i < j)   
    {
        while(i < j && k.x<=a[j].x) 
        {
		  
            j--;
        }
        a[i]=a[j];
        while(i < j && a[i].x<=k.x)
        {
            i++;
        }
        a[j]=a[i];
    }
    a[i]=k;
    Quick_Sort(a,left,i-1);
    Quick_Sort(a, i +1, right); 
}

int main()
{
    int N,R;
    scanf("%d %d",&N,&R);
    int i,j,k;
    for(i=0;i<N;i++)
    {
        scanf("%d",&Country[i].x);
        Country[i].build = 0;
    }
    Quick_Sort(Country,0,N-1);
    j=0;
    for(i=1;i<N;i++)
    {
        if((Country[i].x-R <= Country[j].x) && ((i+1<N) && (Country[i+1].x-R > Country[j].x)))
        {
            Country[i].build = 1;
            k = i;
            while(Country[j].x <= Country[i].x+R && j<N)
                j++;
            i = j-1;
        }
        else if(Country[i].x-R > Country[j].x)
        {
            Country[j].build = 1;
            k = j;
            j = i;
        }
        if(i==N-1 && Country[i].x > Country[k].x+R)
            Country[i].build = 1;
            
    }
    int cnt=0;
    for(i=0;i<N;i++)
    {
        printf("%d %d\n",Country[i].x,Country[i].build);
        cnt += Country[i].build;
    }
    printf("%d",cnt);
    return 0;
}
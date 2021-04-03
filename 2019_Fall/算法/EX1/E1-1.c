#include<stdio.h>
#include<string.h>
#include<stdlib.h>

struct database
{
	int id;
	int a;
};

void MERGE(struct database*data,struct database*tmp,int start,int mid,int end)
{
    int i=start;
    int j=mid+1;
    int k=start;
    while (i<=mid && j<=end)
    {
        if(data[i].a<data[j].a)
        {
            tmp[k++]=data[i++];
        }
        else
        {
            tmp[k++]=data[j++];
        }
    }
    while(i<=mid)
    {
        tmp[k++]=data[i++];
    }
    while(j<=end)
    {
        tmp[k++]=data[j++];
    }
    for(i=start;i<=end;i++)
        data[i]=tmp[i];
}

void MERGE_SORTING(struct database*data,struct database*tmp,int start,int end)
{
    if(start < end)
    {
        int mid=start+(end-start)/2;
        MERGE_SORTING(data,tmp,start,mid);
        MERGE_SORTING(data,tmp,mid+1,end);
        MERGE(data,tmp,start,mid,end);
    }
}

int BINARY_SEARCHING(struct database*data,int low,int high,int target)
{
    while (low<=high)
    {
        int mid=(low+high)/2;
        if(data[mid].a==target)
            return mid;
        else if(data[mid].a<target)
            low=mid+1;
        else if(data[mid].a>target)
            high=mid-1;
    }
    return -1;
}

int main()
{
    int i=0;
    int j;
    int flag=0;
    struct database data[1000000];
    struct database tmp[1000000];
    char command[10];
    int key;
    while (1)
    {
        scanf("%s",command);
        if(command[0]=='I')
        {
            scanf("%d %d",&data[i].id,&data[i].a);
            i++;
            continue;
        }
        else if(command[0]=='F')
        {
            if(flag==0)
            {
                MERGE_SORTING(data,tmp,0,i-1);
                flag=1;
            }
            scanf("%d",&key);
            j=BINARY_SEARCHING(data,0,i,key);
            if(j>=0)
            {
                printf("%d\n",data[j].id);
                continue;
            }
            else
            {
                printf("-1\n");
                continue;
            }
        }
        else
        {
            break;
        }
	}
    return 0;
}

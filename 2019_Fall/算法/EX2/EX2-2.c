#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int *c;

int Str_To_Num(char *str)
{
    int a[5]={0,0,0,0,0};
    int NUM=0;
    int len=strlen(str);
    int i;
    for(i=0;i<len;i++)
    {
        a[i]=str[i]-'a';
    }
    a[1]*=26;
    a[2]*=676;
    a[3]*=17576;
    a[4]*=456976;
    NUM=a[0]+a[1]+a[2]+a[3]+a[4];
    return NUM;
}

int SubQueue(int NUM[],int c[],int n,int k)
{
    int cnt=0;
    int l=0;
    int r=k-1;
    int i;
    int flag=0,f=0;
    int rst=0;
    int delta;
    while(l < n-k+1 && r < n)
    {
        delta=0;
        if(flag == 0)
        {
            for(i=l;i<=r;i++)
            {
                if(c[NUM[i]] == 0)            /*统计不重复出现的字符串个数*/
                {
                    c[NUM[i]]+=1;
                    cnt++;
                }
                else
                {
                    c[NUM[i]]++;
                }
            }
            flag=1;
        } 
        if(cnt == k)
        {
            if(r < n-1)
            {
                rst++;
                r++;
                if(c[NUM[r]] == 0)
                {
                    cnt++;
                }
                c[NUM[r]]++;
                continue;   
            }
            else if(r==n-1 && cnt==k)
            {
                if(f == 0)
                {
                    rst++;
                    f=1;
                    continue;
                }
                c[NUM[l]]--;
                if(c[NUM[l]] == 0)
                {
                    cnt--;
                }
                l++;
                if(cnt < k)
                    continue;
                for(i=r;i>=l+k-1;i--)
                {
                    c[NUM[i]]--;
                    if(c[NUM[i]] == 0)
                    {
                        cnt--;
                    }
                    if(cnt == k-1)
                        break;
                }
                delta=r-i+1;
                rst+=delta;
                for(i=r-delta+1;i<=r;i++)
                {
                    if(c[NUM[i]] == 0)
                        cnt++;
                    c[NUM[i]]++;
                }
            }
        }
        else if(cnt < k)
        {
            r++;
            if(c[NUM[r]] == 0)
            {
                c[NUM[r]]+=1;
                cnt++;
            }
            else
            {
                c[NUM[r]]++;
            }
        }
        else if(cnt > k)
        {
            c[NUM[l]]--;
            if(c[NUM[l]] == 0)
            {
                cnt--;
            }
            l++;
            if(cnt == k)
                continue;
            c[NUM[r]]--;
            if(c[NUM[r]] == 0)
            {
                cnt--;
            }
            r--;
            for(i=r;i>=l+k-1;i--)
            {
                c[NUM[i]]--;
                if(c[NUM[i]] == 0)
                {
                    cnt--;
                }
                if(cnt == k-1)
                    break;
            }
            delta=r-i+1;
            rst+=delta;
            for(i=r-delta+1;i<=r;i++)
            {
                if(c[NUM[i]] == 0)
                    cnt++;
                c[NUM[i]]++;
            }
            r++;
            if(c[NUM[r]]==0)
            {
                cnt++;
            }
            c[NUM[r]]++;
        }
    }
    return rst;
}

int main()
{
    int n,k;
    int i;
    scanf("%d %d",&n,&k);
    char str[10];
    int NUM[100];
    int cnt;
    c = (int*)malloc(sizeof(int)*11900000);
    for(i=0;i<11900000;i++)
    {
        c[i]=0;
    }
    for(i=0;i<n;i++)
    {
        scanf("%s",str);
        NUM[i] = Str_To_Num(str);
    }
    cnt=SubQueue(NUM,c,n,k);
    printf("%d",cnt);
    free(c);
    return 0;
}
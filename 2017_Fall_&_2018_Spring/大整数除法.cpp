#include<stdio.h>  
#include<string.h>  
#define M 1000005  
char s1[M],s2[M];  
int a[M];  
void ss(int m)//减运算  
{  
    int i=0,j;  
    while(1)  
    {  
        if(s1[i]=='0') i++;  
        else  
        {  
            j=i;  
            break;  
        }  
    }  
    for(; i<m; i++)  
        s1[i]=s1[i]-s2[i]+'0';  
    for(i=m-1; i>j; i--)  
        if(s1[i]<'0')  
        {  
            s1[i]+=10;;  
            s1[i-1]--;  
        }  
}  
int main()  
{  
    int i,j,k,n,m;  
    while(~scanf("%s%s",s1,s2))  
    {  
        n=strlen(s1);  
        m=strlen(s2);  
        if(n<m||n==m&&strcmp(s1,s2)<0)//特殊情况判断  
        {  
            printf("0\n");//求余数  
            for(i=0; i<n; i++)  
                printf("%d",s1[i]-'0');  
            printf("\n");  
            continue;  
        }  
        k=0;  
        while(1)  
        {  
            a[k]=0;  
            while(strcmp(s1,s2)>=0)//一直进行减法，直到不能减为止  
            {  
                ss(m);  
                a[k]++;  
            }  
            k++;  
            if(n==m)   break;  
            for(i=m-1; i>=0; i--) //在s2前面补0，以便进行减法运算  
                s2[i+1]=s2[i];  
            s2[0]='0';  
            m++;  
            s2[m]='\0';//strcmp()函数遇到字符'\0'结束  
        }  
        i=0;  
        while(a[i]==0) i++;//去除前导0  
        for(; i<k; i++)  
            printf("%d",a[i]);  
        printf("\n");  
        j=0;//求余数  
        while(s1[j]=='0')  j++;  
        if(j==n)  
        {  
            printf("0\n");  
            continue;  
        }  
        for(; j<n; j++)  
            printf("%d",s1[j]-'0');  
        printf("\n");  
    }  
    return 0;  
}  

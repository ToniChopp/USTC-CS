#include<stdio.h>
#include<stdlib.h> 
#include<string.h>
int i,j;
int main()
{
     void sort(char *str[],int n);
     void* malloc(size_t);
	 int t,n,m;
     char *str[20];
	 printf("请输入字符串个数\n");
	 scanf("%d",&m);
	 printf("请输入 %d 个字符串\n",m);
	 n=m+1;
     for(i=0;i<n;i++)
     {
	     str[i]=(char*)malloc(20);
	     str[i]=(char*)realloc(str[i],strlen(str[i]));
	     gets(str[i]);
	 }
	 sort(str,n) ;
	 for(i=0;i<n;i++)
	 printf("%s\n",str[i]);
	 return 0;
}
void sort(char *str[],int n) 
{
     char temp;
     int i,j,k;
     for(i=1;i<n-1;i++)
     {
         k=i;
         for(j=i+1;j<n;j++)
         if(strcmp(str[k],str[j])>0)
         k=j;
         if(k!=i)
         {
             temp=*str[i];
             *str[i]=*str[k];
             *str[k]=temp;
         }
     }
}


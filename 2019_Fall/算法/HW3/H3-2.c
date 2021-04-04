#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<math.h>
#include<ctype.h>
struct student
{
    int id;
    int math;
    int eng;
    int total;
};

int compare(struct student stu1, struct student stu2)
{
    if(stu1.total>stu2.total)
        return 1;
    if(stu1.total==stu2.total&&stu1.math>stu2.math)
        return 1;
    if(stu1.total==stu2.total&&stu1.math==stu2.math&&stu1.eng>stu2.eng)
        return 1;
    if(stu1.total==stu2.total&&stu1.math==stu2.math&&stu1.eng==stu2.eng&&stu1.id>stu2.id)
        return 1;
    else
    {
        return 0;
    }    
};

void Quick_Sort(struct student*stu,int left,int right)
{
    if(left >= right)
    return ;
    int i = left;
    int j = right;
    struct student k=stu[i];
    while( i < j)   
    {
        while(i < j && compare(k,stu[j])==1) 
        {
		  
            j--;
        }
        stu[i]=stu[j];
        while(i < j && compare(stu[i],k)==1)
        {
            i++;
        }
        stu[j]=stu[i];
    }
    stu[i]=k;
    Quick_Sort(stu,left,i-1);
    Quick_Sort(stu, i +1, right); 
}

int main()
{
    int n;
    scanf("%d",&n);
    struct student stu[10];
    int i,j;
    for(i=0;i<n;i++)
    {
        scanf("%d %d %d",&stu[i].id,&stu[i].math,&stu[i].eng);
        stu[i].total=stu[i].math+stu[i].eng;
    }
    Quick_Sort(stu,0,n-1);
    for(i=0;i<n;i++)
    {
        printf("%d ",stu[i].id);
    }
    return 0;
}

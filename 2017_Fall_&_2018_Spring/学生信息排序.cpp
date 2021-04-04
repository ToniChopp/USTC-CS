#include<stdio.h>
#include<string.h>
#include<stdlib.h>
struct student
{
	char Name[18];
	int ID;
	char Sex;
	int Age;
}r[100];
int cmp(const void*a,const void*b)
{
	struct student*p1=(struct student*)a;
	struct student*p2=(struct student*)b;
	return strcasecmp(p1->Name,p2->Name);
}
 int main()
 {
 	int i=0,j,t;
 	while((scanf("%d,&t"))==0)
    {
	    gets(r[i].Name);
 	    scanf("%d,%c%d",&r[i].ID,&r[i].Sex,&r[i].Age);
 	    i++;
 	}
 	qsort(r,i,sizeof(r[0]),cmp);
 	for(j=0;j<i;j++)
 	printf("%s\n%08d,%c %d\n",r[j].Name,r[j].ID,r[j].Sex,r[j].Age);
 	return 0;
 }

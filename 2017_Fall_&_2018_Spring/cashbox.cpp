#include<stdio.h>
#include<time.h>
#include<stdlib.h>
#include<windows.h>
struct cashbox
{ 
     long logID; 
     char time[11];
     char note[15];
     double charge; 
     double balance; 
}r[5000];

long Size=sizeof(struct cashbox);
long Present;

void ReadeFile(void)
{
	 long begin,end,len;
	 FILE *fp;
	 if((fp=fopen("My Cashbox.dat","rb"))==NULL)
	 {
	 	printf("Soryy,I can't find the file");
	 	exit (0);
	 }
	 fseek(fp,0L,SEEK_SET);
	 begin=ftell(fp);
	 fseek(fp,0L,SEEK_END);
	 end=ftell(fp);
	 len=(end-begin)/Size;
	 fseek(fp,0L,SEEK_SET);
	 long i;
	 Present=len;
	 for(i=0;i<len;i++)
	 {
	 	fread(&r[i],Size,1,fp);
	 }
	 if(fclose(fp))
	 {
	 	printf("Unable to close it");
	 	exit(0);
	 } 
}

void NewFile(void)
{
	 FILE *fp;
	 if((fp=fopen("My Cashbox.dat","w"))==NULL)
	 {
	     printf("Unable to creat a new file");
	     exit(0);
	 }
	 r[0].logID=1;
	 printf("%d,r[0].logID\n");
	 printf("Please enter the time like '2017-11-1' : ");
	 scanf("%s",r[0].time);
	 printf("Please enter the note like 'entertainment': ");
	 scanf("%s",r[0].note);
	 printf("Input Charge:Income+and expend-: ");
	 scanf("%lf",&r[0].charge);
	 r[0].balance=r[0].charge;
	 fwrite(&r[0],Size,1,fp);
	 if(fclose(fp))
	 {
	 	printf("Unable to close it");
	 	exit(0);
	 }
}

void AddFile(void)
{
	 ReadeFile();
	 FILE *fp;
	 if((fopen("My Cashbox.dat","ab+"))==NULL)
	 {
	 	 printf("Unable to open one");
	 	 exit (0);
	 }
	 r[Present].logID=r[Present-1].logID+1;
	 printf("%f,r[Present].logID\n");
	 printf("Please enter the time like '2017-11-1' : ");
	 scanf("%s",r[Present].time);
	 printf("Please enter the note like 'entertainment': ");
	 scanf("%s",r[Present].note);
	 printf("Input Charge:Income+and expend-: ");
	 scanf("%lf",&r[Present].charge);
	 long i;
	 r[Present].balance=r[Present-1].balance+r[Present].charge;
	 fwrite(&r[Present],Size,1,fp);
	 if(fclose(fp))
	 {
	 	 printf("Unable to close it");
	 	 exit(0);
	 }
}

void DelFile(void)
{
	 ReadeFile();
	 FILE *fp;
	 if((fopen("My Cashbox.dat","w+"))==NULL)
	 {
		 printf("Unable to open one");
		 exit(0);
	 }
	 long i=0;
 	 while(i<Present)
	 {
	     printf("%d",r[i].logID);
		 printf("\t%s",r[i].time);
	 	 printf("\t%s",r[i].note);
		 printf("\t%.2lf",r[i].charge);
		 printf("\t%.2lf\n",r[i].balance);
		 i++;	
	 }
	 printf("Please choose the one that you want to delete\n");
	 int j;
	 scanf("%d",&j);
	 for(i=j;i<Present;i++){
		r[i].balance-=r[j].charge;
	 }
	 for(i=0;i<j-1;i++){
		fwrite(&r[i],Size,1,fp);
	 }
	 for(i=j;i<Present;i++){
		r[i].logID--;
		fwrite(&r[i],Size,1,fp);
	 }
	 if(fclose(fp)){
		printf("Unable to close file!");
		exit(0);
	}
}

void InsertFile(void)
{
	ReadeFile();
	FILE *fp;
	if((fopen("My Cashbox.dat","w+"))==NULL)
	{
		 printf("Unable to open one");
		 exit(0);
	}
	 long i,j;
	 printf("Please enter the time like '2017-11-1' : ");
	 scanf("%s",r[Present].time);
	 printf("Please enter the note like 'entertainment': ");
	 scanf("%s",r[Present].note);
	 printf("Input Charge:Income+and expend-: ");
	 scanf("%lf",&r[Present].charge);
	 for(i=0;i<Present;i++)
	 {
	 	 if(strcmp(r[Present].time,r[i].time)<0)
	 	 {
	 	 	 struct cashbox sheet0;
	 	 	 sheet0=r[Present];
	 	 	 for(j=Present-1;j>=i;j--)
	 	 	 {
	 	 	 	 r[j+1]=r[j];
			 }
			 r[i]=sheet0;
			 break;
		 }
	 }
	 r[0].balance=r[0].charge;
	 for(i=1;i<=Present;i++)
	 {
		 r[i].balance=r[i-1].balance+r[i].charge;
	 }
	 for(i=0;i<=Present;i++)
	 {
		 r[i].logID=i+1;
	 }
	 for(i=0;i<=Present;i++)
	 {
		 fwrite(&r[i],Size,1,fp);
	 }
	 if(fclose(fp))
	 {
		 printf("Unable to close file!");
		 exit(0);
	 }
}

void SearchFile(void)
{
	 ReadeFile();
	 FILE *fp;
	 if((fopen("My Cashbox.dat","w+"))==NULL)
	{
		 printf("Unable to open one");
		 exit(0);
	}
	long i,j;
	char s[11],t[11];
	int k,l;
	printf("1\tLogID\n2\tTimepoint\n3\tPeriod\n");
	scanf("%d",&k);
	switch(k)
	{
	     case 1:
		     {
		         printf("please enter ID:\n");
			     scanf("%d",&l);
			     printf("%d",r[l-1].logID);
			     printf("\t%s",r[l-1].time);
			     printf("\t%s",r[l-1].note);
			     printf("\t%.2lf",r[l-1].charge);
			     printf("\t%.2lf\n",r[l-1].balance);
			     break;
		     }
		 case 2:
		 	{
		 		 printf("please enter time:");
			     scanf("%s",s);
			     while(i<Present){
				 while(strcmp(r[i].time,s)==0)
				 {
				     printf("%d",r[i].logID);
			 	     printf("\t%s",r[i].time);
				     printf("\t%s",r[i].note);
				     printf("\t%.2lf",r[i].charge);
				     printf("\t%.2lf\n",r[i].balance);
				     i++;
				 }
				 i++;
			}
			break;
			}
		 case 3:
		 	{
		 		 printf("Please enter begin date(like 2017-11-1):");
			     scanf("%s",s);
			     printf("Please enter end date(like 2017-11-1):");
			     scanf("%s",t);
			     i=0;
			     while(i<Present)
				 {
			 	     while(strcmp(r[i].time,s)>=0&&strcmp(r[i].time,t)<=0)
					 {
					     printf("%d",r[i].logID);
					     printf("\t%s",r[i].time);
					     printf("\t%s",r[i].note);
					     printf("\t%.2lf",r[i].charge);
					     printf("\t%.2lf\n",r[i].balance);
					     i++;
				     }
				     i++;
			     }
			     break;
			}
			default:
				printf("Warning : Out of expectation!\n");
	 }
	 if(fclose(fp))
	 {
		 printf("Unable to close file!");
		 exit(0);
	 }		
}

void RewriteFile (void)
{
	 ReadeFile();
	 FILE *fp;
	 if((fopen("My Cashbox.dat","w+"))==NULL)
	{
		 printf("Unable to open one");
		 exit(0);
	}
	long i=0,j,k;
	for(i;i<Present;i++)
	{
		printf("%d",r[i].logID);
		printf("\t%s",r[i].time);
		printf("\t%s",r[i].note);
		printf("\t%.2lf",r[i].charge);
		printf("\t%.2lf\n",r[i].balance);
	}
	printf("Please select the position you want to operate:\n");
	scanf("%d",&j);
	while(k!=4)
	 {
		printf("Which one in detail?\n(1 for time,2 for note,3 for charge\nand 4 to quit):\n");
		scanf("%d",&k);
		switch(k)
		 {
			 case 1:
			     {
				     char *s=r[j-1].time;
				     printf("Enter new time:");
				     scanf("%s",s);
				     break;
			     }
			 case 2:
			     {
				     char *s=r[j-1].note;
				     printf("Enter new note:");
				     scanf("%s",s);
				     break;
			     }
			 case 3:
			     {
				     printf("Enter new charge:");
				     scanf("%lf",&r[j-1].charge);
				     for(i=j-1;i<Present;i++)
				     {
					     r[i].balance=r[i-1].balance+r[i].charge;
				     }
				 break;
			}
			default:break;
		 }
	 }
	 for(i=0;i<Present;i++)
	 {
	     printf("%d",r[i].logID);
		 printf("\t%s",r[i].time);
		 printf("\t%s",r[i].note);
		 printf("\t%.2lf",r[i].charge);
		 printf("\t%.2lf\n",r[i].balance);
		 fwrite(&r[i],Size,1,fp);
	 }
	 if(fclose(fp))
	 {
		 printf("Unable to close file!");
		 exit(0);
	 }		
}

int main()
{
	 printf("1\tCreate new box(and delete old)\n2\tAdd new data\n3\tDelete old data\n");
	 printf("4\tInsert missing data\n5\tSearch data\n6\tRewrite data\n7\tQuit Program\n");
	 int i;
	 while(1)
	 {
		 scanf("%d",&i);
		 switch(i)
		 {
			 case 1:NewFile();break;
			 case 2:AddFile();break;
			 case 3:DelFile();break;
			 case 4:InsertFile();break;
			 case 5:SearchFile();break;
			 case 6:RewriteFile();break;
			 case 7:
			     {
				     printf("Goodbye~");
				     return 0;	
				     break;
			     }
			 default: printf("Warning: Out of expectation!");break;
	     }
	     printf("Please continue\n");
	 }
	 return 0;
}

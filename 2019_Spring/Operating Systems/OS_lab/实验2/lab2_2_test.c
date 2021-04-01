#include<stdio.h>
#include<sys/syscall.h>
#include<unistd.h>
#include<string.h>
#include<stdlib.h>
int main()
{
        char cmdline[256];
	int i,j,k;
	char cmd[10][20];
	int cmd_num=0;
	while(1)
	{
	    printf("OSLab2->");
	    gets(cmdline);
	    j=0;
	    k=0;
	    for(i=0;i<strlen(cmdline);i++)
	    {
	        if(cmdline[i]==' ' || cmdline[i]==';')
	        {
	            cmd[j][k]='\0';
	            j++;
	            k=0;
	            cmd_num++;
	        }
	        else
	        {
	            cmd[j][k]=cmdline[i];
	            k++;
	        }
	    }
	}
	for(i=0;i<cmd_num;i++)
	{
	    if(strchr(cmd[i],'|'))
	    {
	        FILE *fp=popen(cmd[i],"w");
	        fclose(fp);
	    } 
	    else
            {
	        system(cmd[i]);
	    }
	}  
}

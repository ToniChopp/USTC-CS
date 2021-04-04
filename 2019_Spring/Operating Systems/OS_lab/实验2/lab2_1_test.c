#include<stdio.h>
#include<string.h>
#include<unistd.h>
#include<sys/syscall.h>
int main()
{
        printf("Give me a string:\n");
	char string[10];
	int str_len;
	int out;
	scanf("%s",string);
	str_len=strlen(string);
	syscall(328,&string,str_len,&out);
	syscall(327,out);
	return 0;
}

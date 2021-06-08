// cryptoDemo.cpp : Defines the entry point for the console application.
// Windows: cl cryptoDemo.cpp
// Linux: gcc -o cryptoDemo cryptoDemo.cpp -lcrypto

#include <memory.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "openssl/aes.h"

#pragma comment(lib,"libeay32.lib")

void testAes(char inString[], int inLen, char passwd[], int pwdLen)
{
	int i,j, len, nLoop, nRes;
	char enString[1024];
	char deString[1024];

	unsigned char buf[16];
	unsigned char buf2[16];
	unsigned char aes_keybuf[32];
	AES_KEY aeskey;
	// prepare 32 bytes AES password
	memset(aes_keybuf,0x90,32);
	if(pwdLen<32)
	{
		len=pwdLen;
	}
	else
	{ 
		len=32;
	}
	for(i=0;i<len;i++)
	{
		aes_keybuf[i]=passwd[i];
	}
	// divide the input string into 16 bits blocks	
	nLoop=inLen/16; nRes = inLen%16;
	// encryption
	AES_set_encrypt_key(aes_keybuf,256,&aeskey);
	for(i=0;i<nLoop;i++)
	{
		memset(buf,0,16);
		for(j=0;j<16;j++)
		{
			buf[j]=inString[i*16+j];
		}
		AES_encrypt(buf,buf2,&aeskey);
		for(j=0;j<16;j++)
		{
			enString[i*16+j]=buf2[j];
		}
	}
	if(nRes>0)
	{
		memset(buf,0,16);
		for(j=0;j<nRes;j++)
		{
			buf[j]=inString[i*16+j];
		}
		AES_encrypt(buf,buf2,&aeskey);
		for(j=0;j<16;j++)
		{
			enString[i*16+j]=buf2[j];
		}
	}
	enString[i*16+j]=0;
	AES_set_decrypt_key(aes_keybuf,256,&aeskey);
	for(i=0;i<nLoop;i++)
	{
		memset(buf,0,16);
		for(j=0;j<16;j++)
		{
			buf[j]=enString[i*16+j];
		}
		AES_decrypt(buf,buf2,&aeskey);
		for(j=0;j<16;j++)
		{
			deString[i*16+j]=buf2[j];
		}
	}
	if(nRes>0)
	{
		memset(buf,0,16);
		for(j=0;j<16;j++)
		{
			buf[j]=enString[i*16+j];
		}
		AES_decrypt(buf,buf2,&aeskey);
		for(j=0;j<16;j++)
		{
			deString[i*16+j]=buf2[j];
		}
	}
	deString[i*16+nRes]=0;
	if(memcmp(inString,deString,strlen(inString))==0)
	{ 
		printf("test success\r\n");
	} 
	else 
	{ 
		printf("test fail\r\n");
	}
   	printf("The original string is:\n  %s ", inString);
   	printf("The encrypted string is:\n  %s ", enString);
   	printf("The decrypted string is:\n  %s ", deString);
}

int Encrypt(char inString[], int inLen, char passwd[], int pwdLen, char enString[])
{
	int i,j, len, nLoop, nRes;
	unsigned char buf[16];
	unsigned char buf2[16];
	unsigned char aes_keybuf[32];
	AES_KEY aeskey;

	// prepare 32 bytes AES password
	memset(aes_keybuf,0x90,32);
	if(pwdLen<32)
	{ 
		len=pwdLen; 
	} 
	else
	{ 
		len=32;
	}
	for(i=0;i<len;i++)
	{
		aes_keybuf[i]=passwd[i];
	}
	// divide input string into 16-bit blocks	
	nLoop=inLen/16; nRes = inLen%16;
	AES_set_encrypt_key(aes_keybuf,256,&aeskey);
	for(i=0;i<nLoop;i++)
	{
		memset(buf,0,16);
		for(j=0;j<16;j++)
		{
			buf[j]=inString[i*16+j];
		}
		AES_encrypt(buf,buf2,&aeskey);
		for(j=0;j<16;j++)
		{
			enString[i*16+j]=buf2[j];
		}
	}
	if(nRes>0)
	{
		memset(buf,0,16);
		for(j=0;j<nRes;j++)
		{
			buf[j]=inString[i*16+j];
		}
		AES_encrypt(buf,buf2,&aeskey);
		for(j=0;j<16;j++)
		{
			enString[i*16+j]=buf2[j];
		}
	}
	enString[i*16+j]=0;
    return 0; 
}

int Decrypt(char enString[], int inLen, char passwd[], int pwdLen, char deString[] )
{
    int i,j, len, nLoop, nRes;
	unsigned char buf[16];
	unsigned char buf2[16];
	unsigned char aes_keybuf[32];
	AES_KEY aeskey;

	memset(aes_keybuf,0x90,32);
	if(pwdLen<32)
	{ 
		len=pwdLen; 
	} 
	else 
	{ 
		len=32;
	}
	for(i=0;i<len;i++) 
	{
		aes_keybuf[i]=passwd[i];
	}
	nLoop=inLen/16; nRes = inLen%16;
    AES_set_decrypt_key(aes_keybuf,256,&aeskey);
	for(i=0;i<nLoop;i++)
	{
		memset(buf,0,16);
		for(j=0;j<16;j++)
		{
			buf[j]=enString[i*16+j];
		}
		AES_decrypt(buf,buf2,&aeskey);
		for(j=0;j<16;j++)
		{
			deString[i*16+j]=buf2[j];
		}
	}
	if(nRes>0)
	{
		memset(buf,0,16);
		for(j=0;j<16;j++)
		{
			buf[j]=enString[i*16+j];
		}
		AES_decrypt(buf,buf2,&aeskey);
		for(j=0;j<16;j++)
		{
			deString[i*16+j]=buf2[j];
		}
	}
	deString[i*16+nRes]=0;
	return 0;
}

char* inString = (char*)malloc(65535);
char* enString = (char*)malloc(65535);
char* deString = (char*)malloc(65535);

int main(int argc, char* argv[])
{
	if(argv[1][0] == '1')
	{
		FILE* src = fopen(argv[2],"r");
		if(src==NULL)
		{
			printf("Cannot open file.\n");
			return 1;
		}
		char new_name[100];
		int name_len = strlen(argv[2]);
		strncpy(new_name ,argv[2], name_len);
		new_name[name_len] = '.';
		new_name[name_len+1] = 'e';
		new_name[name_len+2] = 'n';
		new_name[name_len+3] = 'c';
		new_name[name_len+4] = '\0';
		FILE* dst = fopen(new_name,"wb+");
		fseek(src,0,SEEK_END);
		long lSize = ftell(src);
		rewind(src); 
		fread(inString,sizeof(char),lSize,src);
		Encrypt(inString, lSize, argv[3], strlen(argv[3]), enString);
		enString[lSize]='\0';
		fwrite(enString, sizeof(char), lSize, dst);
		fclose(src);
		fclose(dst);
	}
	else 
	{
		FILE* src = fopen(argv[2],"r");
		if(src==NULL)
		{
			printf("Cannot open file.\n");
			return 1;
		}
		char new_name[100];
		int name_len = strlen(argv[2]);
		strncpy(new_name,argv[2], name_len-4);
		new_name[name_len-4] = '\0';
		FILE* dst = fopen(new_name,"wb+");
		fseek(src,0,SEEK_END);
		long lSize = ftell(src);
		rewind(src); 
		fread(enString,sizeof(char),lSize,src);
		Decrypt(enString, lSize, argv[3], strlen(argv[3]), deString);
		enString[lSize]='\0';
		fwrite(deString, sizeof(char), lSize, dst);
		fclose(src);
		fclose(dst);
	}
	return 0;
}



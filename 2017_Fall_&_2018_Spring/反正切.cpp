#include<stdio.h>
int main()
{
	int long a,i;
	scanf("%ld",&a);
    for(i = a;i>=1;i--)
    {
        if(!((a*a+1)%i))
        break;
    }
    printf("%ld",2*a+i+(a*a+1)/i);
	return 0;
}

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

int main()
{
    int e=7;
    int m=2008;
    int k = m^e;
    k %= 7373;
    printf("%d", k); 
    return 0;
}
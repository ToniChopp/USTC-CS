#include <stdio.h>  
   
int n, allPlacedState, count;  
   
void queen(int row, int ld, int rd)  
{  
    if (row != allPlacedState)  
    {  
        int pos = allPlacedState & ~(row | ld | rd);  
        while (pos)  
        {  
            int p = pos & -pos;  
            pos -= p;  
            queen(row+p, (ld+p)<<1, (rd+p)>>1);  
        }  
    }  
    else  
    {  
        count ++;  
    }  
}  
   
int main()  
{  
    while (scanf("%d", &n) != EOF)  
    {  
        allPlacedState = (1<<n)-1;  
        count = 0;  
        queen(0, 0, 0);  
        printf("%d\n", count);  
    }  
    return 0;  
}  

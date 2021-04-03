#include<stdio.h>
#include<stdlib.h>
#include<string.h>
char P[10000];
char S[1000000];
int next[10000];

void Get_Next()
{
    int i = 0;
    int j = -1;
    next[i] = j;
    while(P[i])
    {
        if((j == -1) || (P[i] == P[j]))
        {
            i++;
            j++;
            if(P[i] == P[j])
                next[i] = next[j];
            else
            {
                next[i] = j;
            }  
        }
        else
        {
            j = next[j];
        } 
    }
}

int main() 
{
    int T;
    scanf("%d",&T);
    int i,j;
    int result;
    while(T--)
    {
        scanf("%s",P);
        scanf("%s",S);
        Get_Next();
        i = 0;
        j = 0;
        result = 0;
        while(S[i])
        {
            if((j == -1) || (S[i] == P[j]))
            {
                i++;
                j++;
                if(!P[j])
                {
                    result++;
                    j = next[j];
                }
            }
            else
                j = next[j];
        }
        printf("%d\n",result);
    }

    return 0;
}
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>

typedef struct
{
    double coef;
    int expn;
}term;

typedef struct LNode
{
    term data;
    LNode *next;
}*Link, *Linklist;

Linklist La, Lb, Lc, Ld, Le, Lf;

int cmp(term a, term b)
{
    if(a.expn == b.expn) return 0;
    else return (a.expn - b.expn) / abs(a.expn - b.expn);
}

int ElemLocate(Linklist L, term e, Link &S, Link &Q, int (*compara)(term, term))
{
    Link p;
    S = L; p = S->next;
    while(p && compara(p->data, e) != 0)
    {
        S = p;
        p = p->next;
    }
    if(!p)
    {
        S = Q = NULL;
        return 0;
    }
    else
    {
        Q = p;
        return 1;
    }
}

void Orderinsert(Linklist &L, term e, int (*compara)(term, term))
{
    Link o, p, q;
    q = L; p = q->next;
    while(p && compara(p->data, e) < 0)
    {
        q = p;
        p = p->next;
    }
    o = (Link)malloc(sizeof(LNode));
    o->data = e;
    q->next = o;
    o->next = p;
}

void DeleteElem(Linklist &L, Link S)
{
    Link Q = S->next;
    S->next = Q->next;
    free(Q);
}

void InsertElem(Linklist &L, term e, int (*compara)(term, term), char op)
{
    Link Q, S;
    if(ElemLocate(L, e, S, Q, compara))
    {
        switch(op)
        {
            case '+': Q->data.coef += e.coef; break;
            case '-': Q->data.coef -= e.coef;
        }
        if(!Q->data.coef)
            DeleteElem(L, S);
    }
    else
        Orderinsert(L, e, compara);
}

void inputpolynomial(Linklist &L)
{
    L = (Link)malloc(sizeof(LNode));
    L->next = NULL;
    int m;
    printf("Please enter the number of polynomial: \n");
    scanf("%d", &m);
    printf("Please enter the coef and expn of each term: \n");
    for(int i = 1; i <= m; i++)
    {
        term e;
        printf("the coef and expn of the %d th term: ", i);
        scanf("%lf%d", &e.coef, &e.expn);
        InsertElem(L, e, cmp, '+');
    }
}

void outputpolynomial(Linklist &L)
{
    Link Q = L->next;
    printf("Output the polynomial:\n");
    if(Q==NULL)
        printf("0 \n");
    while(Q)
    {
        if(Q->data.expn == 0)
            printf("%.2lf", Q->data.coef);
        else if(Q->data.coef == 1 && Q->data.expn == 1)
            printf("x");
        else if(Q->data.coef == -1 && Q->data.expn == 1)
            printf("-x");
        else if(Q->data.coef == 1)
            printf("x^%d", Q->data.expn);
        else if(Q->data.coef == -1)
            printf("-x^%d", Q->data.expn);
        else if(Q->data.expn == 1)
            printf("%.2lf*x", Q->data.coef);
        else
            printf("%.2lf*x^%d", Q->data.coef, Q->data.expn);
        if(Q->next)
        {
            if(Q->next->data.coef > 0)
                printf("+");
        }
        Q = Q->next;
    }
    printf("\n\n");
}

void polynomialadd_sub(Linklist &L1, Linklist &L2, Linklist &L3, char op)
{
    L3 = (Link)malloc(sizeof(LNode));
    L3->next = NULL;
    Link S = L1->next;
    term e;
    while(S)
    {
        e.coef = S->data.coef;
        e.expn = S->data.expn;
        InsertElem(L3, e, cmp, op);
        S = S->next;
    }
    S = L2->next;
    while(S)
    {
        e.coef = S->data.coef;
        e.expn = S->data.expn;
        InsertElem(L3, e, cmp, op);
        S = S->next;
    }
    switch(op)
    {
        case '+': printf("Successfully adding the two polynomials \n"); break;
        case '-': printf("Successfully subtracting the two polynomials \n");
    }
}

void polynomialmui_div(Linklist &L1, Linklist &L2, Linklist &L3)
{
    L3 = (Link)malloc(sizeof(LNode));
    L3->next = NULL;
    Link S = L1->next;
    term s, e;
    while(S)
    {
        s.coef = S->data.coef;
        s.expn = S->data.expn;
        Link Q = L2->next;
        while(Q)
        {
            e.coef = s.coef * Q->data.coef;
            e.expn = s.expn + Q->data.expn;
            InsertElem(L3, e, cmp, '+');
            Q = Q->next;
        }
        S = S->next;
    }
    printf("Successfully multiplying the two polynomials");
}
void Chooseoperator(int op)
{
    int C;
    switch(op)
    {
        case 1:
                printf("Please choose what to do \n");
                printf("1:Start the programme\n");
                printf("2:Exit the programme\n");
                printf("Your choice:\n"); 
				scanf("%d", &C);
                while(C < 1 || C > 2)
                {
                    printf("Ilegal input,please enter your choice again \n");
                    printf("Your choice:\n"); 
					scanf("%d", &C);
                }
                switch(C)
                {
                    case 1: Chooseoperator(2); break;
                }
                break;
        case 2:
                printf("Please choose what to do\n");
                printf("1:Enter the polynomial a\n");
                printf("2:Enter the polynomial b\n");
                printf("3:Print polynomial c,c=a+b\n");
                printf("4:Print polynomial d,d=a-b\n");
                printf("5:Print polynomial e,e=a*b\n");
                printf("6:Go back to the last step\n\n");
                printf("Enter your choice:\n"); 
				scanf("%d", &C);
                while(C < 1 || C > 11)
                {
                    printf("Illegal input,please enter your choice again \n:");
                    printf("Your choice:\n"); 
					scanf("%d", &C);
                }
                switch(C)
                {
                    case 1: inputpolynomial(La); outputpolynomial(La); Chooseoperator(2); break;
                    case 2: inputpolynomial(Lb); outputpolynomial(Lb); Chooseoperator(2); break;
                    case 3: polynomialadd_sub(La, Lb, Lc, '+'); outputpolynomial(Lc); Chooseoperator(2); break;
                    case 4: polynomialadd_sub(La, Lb, Ld, '-'); outputpolynomial(Ld); Chooseoperator(2); break;
                    case 5: polynomialmui_div(La, Lb, Le); outputpolynomial(Le); Chooseoperator(2); break;
                    case 6: Chooseoperator(1);
                }
    }
}
int main()
{
    Chooseoperator(1);
    return 0;
}

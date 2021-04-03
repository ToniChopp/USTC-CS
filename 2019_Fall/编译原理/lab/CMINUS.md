# C-
`C MINUS`��C���Ե�һ���Ӽ��������Ե��﷨�ڡ�����ԭ����ʵ�����ھ��¸�¼������ϸ�Ľ��ܡ�
##  Lexical Conventions
1. �ؼ���  
`else if int return void while`  
2. ר�÷���  
`+ - * / < <= > >= == != = ; , ( ) [ ] { } /* */`  
3. ��ʶ��ID������NUM��ͨ������������ʽ����:   
`ID=letter letter*`  
`NUM=digit digit*`  
`letter = a|...|z|A|...|Z`  
`digit = 0|...|9`  

4. ע����`/*...*/`��ʾ�����Գ���һ�С�ע�Ͳ���Ƕ�ס�  
`/*...*/`  

> ˼��
> 1. ʶ��C-����Token��DFA���
> 2. note that: [, ], �� [] �����ֲ�ͬ��tokens��[]���������������ͣ�[]�м䲻���пո�

## Syntax
1. program �� declaration-list
2. declaration-list �� declaration-list declaration | declaration
3. declaration �� var-declaration | fun-declaration
4. var-declaration �� type-specifier `ID` ; | type-specifier `ID` `[` `NUM` `]`; 
5. type-specifier �� `int` | `void`
6. fun-declaration �� type-specifier `ID` `(`params`)` compound-stmt
7. params �� param-list | `void`
8. param-list�� param-list , param | param
9. param �� type-specifier `ID` | type-specifier `ID` `[]`
10. compound-stmt �� `{` local-declarations statement-list `}`
11. local-declarations �� local-declarations var-declaration | empty 
12. statement-list �� statement-list statement | empty
13. statement �� expression-stmt | compound-stmt| selection-stmt
| iteration-stmt | return-stmt
14. expression-stmt �� expression ; | ;
15. selection-stmt �� `if` `(` expression `)` statement | `if` `(` expression `)` statement `else` statement
16. iteration-stmt �� `while` `(` expression `)` statement
17. return-stmt �� `return` ; | `return` expression ;
18. expression �� var `=` expression | simple-expression
19. var �� `ID` | `ID` `[` expression `]`
20. simple-expression �� additive-expression relop additive- expression | additive-expression
21. relop �� `<=` | `<` | `>` | `>=` | `==` | `!=`
22. additive-expression �� additive-expression addop term | term 
23. addop �� `+` | `-`
24. term �� term mulop factor | factor
25. mulop �� `*` | `/`
26. factor �� `(` expression `)` | var | call | `NUM`
27. call �� `ID` `(` args `)`
28. args �� arg-list | empty
29. arg-list �� arg-list , expression | expression

> ˼����
> 1. C-�����﷨���ص㣬����CFG

# Sample Programs of C-
```c
int gcd (int u, int v) { /* calculate the gcd of u and v */
    if (v == 0) return u;
    else return gcd(v, u - u / v * v); /* v,u-u/v*v is equals to u mod v*/
}
int main() {
    int x; int y; int temp;
    x = 72;
    y = 18;
    if (x<y) {
        temp = x;
        x = y;
        y = temp;
    }
    gcd(x,y);
    return 0;
}
```
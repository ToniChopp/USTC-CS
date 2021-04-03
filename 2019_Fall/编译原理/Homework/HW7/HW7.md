# HW7
## 4.6 (b)
```
产生式            语义规则
E→E1+T          
                if(E1.type==real && T.type==integer)
                {   
                    E.type=real;
                    print(T.lexeme);
                    print('inttoreal');
                }
                else if(E1.type==integer && T.type==real)
                {
                    E.type=real;
                    print('inttoreal');
                    print(T.lexeme);
                }
                else
                {
                    E.type=T.type;
                    print(T.lexeme);
                }
                print('+');
E→T             E.type=T.type; print(T.lexeme);
T→num.num       T.type=real; T.lexeme=num.num.lexeme;
T→num           T.type=integer;  T.lexeme=num.lexeme;
```
## 4.11
```
产生式                语义规则
S→E                 
E→E1=E2             if(E1.val=rvalue)
                    {
                        if(E1.val==rvalue)
                            print('error');
                        E.val=rvalue;
                    }
E→E1+E2             E.val=rvalue;
E→(E1)              E.val=E1.val;
E→id                E.val=lvalue;
```
## 4.14 (b)
```
P→{D.depth=1;}D
D→{D1.depth=D.depth;}D1;{D2.depth=D.depth;}D2
D→id:T{print(id.name,D.depth);}
D→proc id;{D1.depth=D.depth+1;}D1;S
```
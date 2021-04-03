# HW4
## 3.16
### 3.16(a)
S⇒<sub>rm</sub><u>(L)</u>⇒<sub>rm</sub>(<u>L,S</u>)⇒<sub>rm</sub>(L,<u>(L)</u>)⇒<sub>rm</sub>(L,(<u>L,S</u>))⇒<sub>rm</sub>(L,(L,<u>a</u>))⇒<sub>rm</sub>(L,(<u>S</u>,a))⇒<sub>rm</sub>(L,(<u>a</u>,a))⇒<sub>rm</sub>(<u>S</u>,(a,a))⇒<sub>rm</sub>(<u>a</u>,(a,a))
### 3.16(b)
![](./figs/HW4-1.png)
### 3.16(c)
![](./figs/2.jpg)
## 3.17
拓广文法：  
S'→S  
S→(L) | a  
L→L,S | S  
I<sub>0</sub>=closure(I)  
I<sub>0</sub>:S'→ · S  
&emsp;S→ · (L)  
&emsp;S→ · a  
I<sub>1</sub>=goto(I<sub>0</sub>,S)  
I<sub>1</sub>:S'→S ·   
I<sub>2</sub>=goto(I<sub>0</sub>,( )   
I<sub>2</sub>:S→( · L)  
&emsp;L→ · L,S  
&emsp;L→ · S  
&emsp;S→ · (L)  
&emsp;S→ · a  
I<sub>3</sub>=goto(I<sub>0</sub>,a)  
I<sub>3</sub>:S→a ·   
I<sub>4</sub>=goto(I<sub>2</sub>,L)  
I<sub>4</sub>:S→(L · )  
&emsp;L→L · ,S  
I<sub>5</sub>=goto(I<sub>2</sub>,S)  
I<sub>5</sub>:L→S ·     
goto(I<sub>2</sub>,( )=I<sub>2</sub>  goto(I<sub>2</sub>,a)=I<sub>3</sub>  
I<sub>6</sub>=goto(I<sub>4</sub>,) )  
I<sub>6</sub>:S→(L) ·   
I<sub>7</sub>=goto(I<sub>4</sub>, ,)  
I<sub>7</sub>:L→L, · S  
&emsp;S→ · (L)  
&emsp;S→ · a  
I<sub>8</sub>=goto(I<sub>7</sub>,S)  
I<sub>8</sub>:L→L,S ·   
goto(I<sub>7</sub>,( )=I<sub>2</sub>  goto(I<sub>7</sub>,a)=I<sub>3</sub>  
![](./figs/3.jpg)
## 3.19(a)
拓广文法：  
E'→E  
E→E+T | T  
T→TF | F  
F→F* | a | b   
I<sub>0</sub>=closure(I)  
I<sub>0</sub>:E'→·E  
&emsp;E→·E+T  
&emsp;E→·T  
&emsp;T→·TF  
&emsp;T→·F  
&emsp;F→·F*  
&emsp;F→·a  
&emsp;F→·b  
I<sub>1</sub>=goto(I<sub>0</sub>,E)  
I<sub>1</sub>:E'→E·  
&emsp;E→E·+T  
I<sub>2</sub>=goto(I<sub>0</sub>,T)  
I<sub>2</sub>:E→T·  
&emsp;T→T·F  
&emsp;F→·F*  
&emsp;F→·a  
&emsp;F→·b  
I<sub>3</sub>=goto(I<sub>0</sub>,F)  
I<sub>3</sub>:T→F·  
&emsp;F→F·F*  
&emsp;F→·a  
&emsp;F→·b  
I<sub>4</sub>=goto(I<sub>0</sub>,a)  
I<sub>4</sub>:F→a·    
I<sub>5</sub>=goto(I<sub>0</sub>,b)  
I<sub>5</sub>:F→b·    
I<sub>6</sub>=goto(I<sub>1</sub>,+)  
I<sub>6</sub>:E→E+·T  
&emsp;T→·TF  
&emsp;T→·F  
&emsp;F→·F*  
&emsp;F→·a  
&emsp;F→·b    
I<sub>7</sub>=goto(I<sub>2</sub>,F)  
I<sub>7</sub>:T→TF·  
&emsp;F→F·F*  
&emsp;F→·a  
&emsp;F→·b  
goto(I<sub>2</sub>,a)=I<sub>4</sub>  goto(I<sub>2</sub>,b)=I<sub>5</sub>  
I<sub>8</sub>=goto(I<sub>6</sub>,T)  
I<sub>8</sub>:E→E+T·  
&emsp;T→T·F  
&emsp;F→·F*  
&emsp;F→·a  
&emsp;F→·b    
goto(I<sub>6</sub>,F)=I<sub>3</sub>  goto(I<sub>6</sub>,a)=I<sub>4</sub>  goto(I<sub>6</sub>,b)=I<sub>5</sub>  goto(I<sub>8</sub>,F)=I<sub>7</sub>  goto(I<sub>8</sub>,a)=I<sub>4</sub>  goto(I<sub>8</sub>,b)=I<sub>5</sub>  
I<sub>9</sub>=goto(I<sub>7</sub>,F)  
I<sub>9</sub>:F→F·F*  
&emsp;F→·a  
&emsp;F→·b  
goto(I<sub>9</sub>,F)=I<sub>9</sub>  
![](./figs/4.png)
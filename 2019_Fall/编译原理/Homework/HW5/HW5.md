# HW5
## 3.21(a)
First(AaAb)=ε  
First(BbBa)=ε    
First(AaAb) ∩ First(BbBa)=Ø  
BbBa无法推出ε  
所以文法是LL（1）文法  
对此文法做拓广：  
S'→S  
S→AaAb  
S→BbBa  
A→ε  
B→ε  
则I<sub>0</sub>：S'→·S  S→·AaAb  S→·BbBa  A→·  B→·  
对于I<sub>0</sub>，action[0,A]={a,b},action[0,B]={a,b},规约冲突，所以不是SLR（1）
## 3.25
拓广文法：  
L'→L  
L→MLb | a  
M→ε  
I<sub>0</sub>:L'→·L  
&emsp;L→·MLb,$  
&emsp;L→·a,$  
&emsp;M→·,a  
I<sub>1</sub>=goto(I<sub>0</sub>,L)  
I<sub>1</sub>:L'→L·,$  
I<sub>2</sub>=goto(I<sub>0</sub>,M)  
I<sub>2</sub>:L→M·Lb,$  
&emsp;L→·MLb,b  
&emsp;L→·a,b  
&emsp;M→·,a  
I<sub>3</sub>=goto(I<sub>0</sub>,a)  
I<sub>3</sub>:L→a·,$    
I<sub>4</sub>=goto(I<sub>2</sub>,L)  
I<sub>4</sub>:L→ML·b,$  
I<sub>5</sub>=goto(I<sub>2</sub>,M)  
I<sub>5</sub>:L→M·Lb,b   
&emsp;L→·MLb,b  
&emsp;L→·a,b  
&emsp;M→·,a  
I<sub>6</sub>=goto(I<sub>2</sub>,a)  
I<sub>6</sub>:L→a·,b  
I<sub>7</sub>=goto(I<sub>4</sub>,b)  
I<sub>7</sub>:L→MLb·,$  
I<sub>8</sub>=goto(I<sub>5</sub>,L)  
I<sub>8</sub>:L→ML·b,b  
goto(I<sub>5</sub>,M)=I<sub>5</sub>    
I<sub>9</sub>=goto(I<sub>8</sub>,b)  
I<sub>9</sub>:L→MLb·,b  
所以I<sub>0</sub> I<sub>2</sub> I<sub>5</sub>面临a产生移进规约冲突，由此可以说明不是LR(1)
## 3.27
### 3.27(a)
以下皆为非负数：  
S：整数或小数  
I：整数  
R：浮点数  
W：整数或浮点数整数部分  
F：浮点数小数部分  
### 3.27(b)
拓广文法：  
S'→S  
S→I | R  
I→d | Id  
R→WpF  
W→Wd | ε  
F→Fd | d  
I<sub>0</sub>=closure(I)  
I<sub>0</sub>:S'→·S,$  
&emsp;S→·I,$  
&emsp;S→·R,$  
&emsp;I→·d,$ / d  
&emsp;I→·Id,$ / d  
&emsp;R→·WpF,$  
&emsp;W→·Wd,p/d  
&emsp;W→·,p/d  
&emsp;F→·Fd,d/$  
&emsp;F→·d,d/$  
显然I<sub>0</sub>面临p/d存在移进规约冲突所以不是LR(1)文法  
## 3.29
### 3.29(a)
![](./figs/1.jpg)
![](./figs/2.jpg)
### 3.29(b)
有，合并同心项目集后I<sub>9</sub> I<sub>10</sub> I<sub>12</sub>状态被合并，没有冲突
## 3.30
产生的语言是在任何位置截断时，前缀中a的个数比b多的字符串  
S→aS' | ε  
S'→S | TbS  
T→S | ε  
即为所求
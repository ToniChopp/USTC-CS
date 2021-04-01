             .ORIG x3000
Start        LD R6,Addr         ;Stack Pointer      
             LD R4,MINUS_ASCII
             JSR main
             LDR R0,R6,#0
             HALT

main         ADD R6,R6,#-1
             STR R7,R6,#0       ;Store the address to return
             ADD R6,R6,#-1
             STR R5,R6,#0
             ADD R5,R6,#-1
             ADD R6,R6,#-2       
             TRAP x23
             ADD R0,R0,R4      
             STR R0,R5,#0      ;Push n into the stack

             AND R2,R2,#0
             STR R2,R6,#0
             STR R2,R6,#-1
             STR R2,R6,#-2
             STR R2,R6,#-3
             STR R2,R6,#-4
             STR R2,R6,#-5    ;Push a,b,c,d,e,f into the stack (They are all zero in main)
             STR R0,R6,#-6      
             ADD R6,R6,#-6             

             JSR Func
             LDR R0,R6,#-1
             STR R0,R5,#3
             ADD R6,R5,#3
             LDR R5,R5,#1      ;Frame pointer
             LDR R7,R6,#-1     ;Return address
             RET

Func         LD R1,Delta       ;Judge if the stack overflows
             ADD R1,R1,R6
             BRnz Overflow

             ADD R6,R6,#-2
             STR R7,R6,#0
             ADD R6,R6,#-1
             STR R5,R6,#0
             ADD R5,R6,#-1
             ADD R6,R6,#-3
             TRAP x23
             ADD R0,R0,R4     ;GetC()-0

             LDR R3,R5,#5     ;Calculate t
             ADD R0,R0,R3
             LDR R3,R5,#6
             ADD R0,R0,R3
             LDR R3,R5,#7
             ADD R0,R0,R3
             LDR R3,R5,#8
             ADD R0,R0,R3
             LDR R3,R5,#9
             ADD R0,R0,R3
             LDR R3,R5,#10
             ADD R0,R0,R3
             STR R0,R5,#0     ;Push t into stack
             
             LDR R1,R5,#4     ; n>1 ?
             ADD R1,R1,#-1
             BRnz Little

             LDR R3,R5,#10    ;Change the stack position of a,b,c,d,e,f to recursion
             STR R3,R6,#-1
             LDR R3,R5,#9
             STR R3,R6,#-2
             LDR R3,R5,#8
             STR R3,R6,#-3
             LDR R3,R5,#7
             STR R3,R6,#-4
             LDR R3,R5,#6
             STR R3,R6,#-5
             LDR R3,R5,#5
             STR R3,R6,#-6
             STR R1,R6,#-7
             ADD R6,R6,#-7
             JSR Func       ;Calculate x
             
             LDR R1,R6,#-1
             STR R1,R5,#-1
             LDR R2,R6,#0
             ADD R2,R2,#-1
             STR R2,R6,#0
             JSR Func       ;Calculate y

             LDR R1,R6,#-1
             STR R1,R5,#-2
             LDR R0,R5,#0     ;R0<-t
             LDR R1,R5,#-1    ;R1<-x
             ADD R0,R0,R1
             LDR R1,R5,#-2    ;R1<-y
             ADD R0,R0,R1
             ADD R0,R0,#-1

Little       STR R0,R5,#3      ;n<=1,return t
             LDR R7,R5,#2
             ADD R6,R5,#4
             LDR R5,R5,#1
             RET

Overflow     LEA R0,String
             TRAP x22
             HALT

MINUS_ASCII  .FILL xFFD0
Addr         .FILL xF000
Delta        .FILL x4000
String       .STRINGZ "You idoit,the stack overflows!"

.END


DATA SEGMENT
    STT DB 'Please enter the number N:$'
    NUMBER DB ?  ;用于存输入数字
    ROUND DB ?   ;存放当前进行的轮数
    CRLF  DB 0AH,0DH,"$" ;回车换行

    TEN DB 10
DATA ENDS

CODE SEGMENT
    ASSUME CS: CODE,DS: DATA
     
START:
    MOV AX,DATA
    MOV DS,AX

    LEA DX,STT
    MOV AH,09H
    INT 21H
    
    LEA DX,CRLF   ;换行
    MOV AH,9
    INT 21H

    MOV AH,07H
    INT 21H
    MOV BL,AL     ;把收到的数字存储到BL对应的位置
    SUB BL,'0'
    MOV number,BL
    
    MOV CL,1      ;记录打印的数字
    MOV BH,1      ;记录当前为第几轮
    MOV ROUND,BH
    JMP COMP1
NEXT1:  
    MOV CH,0
    MOV AX,CX
    DIV TEN     ;判断是否为两位数
    MOV DH,AH   ;记录余数
    MOV DL,AL   ;记录商
    CMP DL,0
    JE ONES
TENS:   
    ADD DL,'0'
    MOV AH,02H
    INT 21H
    
ONES:   
    MOV DL,DH
    ADD DL,'0'
    MOV AH,02H
    INT 21H
    MOV DL,20H  ;发送空格
    MOV AH,02H
    INT 21H
    
    INC CL
    INC BH
COMP2:  
    CMP BH,ROUND
    JBE NEXT1
    
    MOV ROUND,BH
    MOV BH,1
    MOV DL,0AH  ;发送换行
    MOV AH,02H
    INT 21H
    SUB BL,1
    ADD CL,BL
    
COMP1:  
    CMP BL,0
    JNE COMP2
EXIT:
    MOV AX,4C00H      ;返回DOS
    INT 21H     
CODE  ENDS
END   START
DATA SEGMENT
     FILENAME1 DB 'Input1.txt',0
     FILENAME2 DB 'Output1.txt',0
     BUFFER1 DB 100          ;写缓冲区
     ACTLEN DB ?
     BUFFER2 DB 100  DUP(?)  ;读缓冲区                  
     ;STT DB 'ENTER THE STRING:$'
DATA  ENDS

CODE  SEGMENT
     ASSUME CS: CODE,DS: DATA
     
START:
     MOV  AX,DATA
     MOV  DS,AX
;Creat Input1.txt     
     MOV DX,OFFSET FILENAME1  ; ASCIZ串地址置入DS: DX
     MOV CX,0H          ; 文件属性为0(普通文件)   
     MOV AH,3CH
     INT 21H            ; 建立该文件
     JNC GETSTRING
     JMP EXIT            ;创建失败，结束
;get string from keyboard
GETSTRING:
     MOV BX,AX
     
     ;MOV DX,OFFSET STT
     ;MOV AH,09H          ;输出'Enter a string:'
     ;INT 21H

     MOV DX,OFFSET BUFFER1
     MOV AH,0AH           
     INT 21H             ;从键盘接收一个字符串
     
     ;MOV DL,0AH
     ;MOV AH,02H
     ;INT 21H             ;屏幕回显
;Write into Input1.txt
     MOV DX,OFFSET BUFFER2
     XOR CX,CX
     MOV CL,ACTLEN
     MOV AH,40H          ;INT 21H的40H功能，写文件
     INT 21H             ;把缓冲区内容写入文件
     
     MOV AH,3EH
     INT 21H             ;关闭文件
;Read from Input1.txt
     MOV DX,OFFSET FILENAME1
     MOV AL,2H
     MOV AH,3DH
     INT 21H             ;打开Input1.txt
     JNC READ
     JMP EXIT
READ:
     MOV BX,AX
     MOV DX,OFFSET BUFFER2
     MOV CX,100
     MOV AH,3FH
     INT 21H
     MOV CX,AX           
     MOV AH,3EH
     INT 21H
     
     MOV BX,CX
     MOV SI,OFFSET BUFFER2
;Change to capital letters
CHANGE:
     MOV DL,[SI]
     CMP DL,61H
     JB NXT
     SUB DL,20H
     MOV [SI],DL
NXT:
     INC SI
     MOV AH,02H
     INT 21H       ;输出到屏幕
     LOOP CHANGE
    
     MOV DX,OFFSET FILENAME2
     MOV CX,0H
     MOV AH,3CH
     INT 21H
     MOV CX,BX
     MOV BX,AX
     MOV DX,OFFSET BUFFER2
     MOV AH,40H
     INT 21H
     MOV AH,3EH
     INT 21H
EXIT:
     MOV AX,4C00H      ;返回DOS
     INT 21H     
CODE  ENDS
END   START

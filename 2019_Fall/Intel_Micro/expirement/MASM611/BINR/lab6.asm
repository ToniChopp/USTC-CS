.model small
.386
.387

.data
    In_Output db 'Please enter x,a1,a2,a3',0ah,0dh,'$'
    Error_Output db 'Error: x<0!$'
    data dd 4 dup(?)
    ten dd 10.0                   ;用于fmul乘10
    two dd 2.0
    tmp dw ?                      ;暂时存储读入的处理后字符
    sign db ?                     ;记录负号
    result dd ?                   ;计算结果
    status dw ?
    whole dd ?                    ;整数部分
    fract dd ?                    ;小数部分 

.stack 40960

.code
Input proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di

loop1:            ;单个字符循环读入，判断是否为负数
    mov sign,00h
    fldz         ;将+0.0h压入栈
    mov ah,01h   
    int 21h
    .if al=='-' ;负数
        mov sign,1h
        mov ah,01h
        int 21h
    .endif
    .while al>='0' && al<='9'
        fmul ten 
        mov ah,00h
        sub al,30h
        mov tmp,ax
        fiadd tmp       ;将单个读入的字符处理后合并成一个整数
        mov ah,01h
        int 21h
    .endw

loop2:
    .if sign==1         ;负数则将栈内存的数做取反操作
        fchs
    .endif
    fstp data[ecx*4]    ;存储转换结果
    .if al==0dh         ;是否是回车
        jmp return1
    .endif
    inc ecx
    jmp loop1

return1:
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax

    ret
Input endp

Compute proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    fstcw status           ;获取控制寄存器
    or status,0c00h        ;将舍入控制改为11，截为0
    fldcw status           ;存取控制寄存器

    fld data[0]
    ftst                ;比较st0和0.0
    fstsw	ax
	and	ax, 4500H
	cmp	ax, 0100H
	jz  Error

    fld  data[0]  	;a1√𝒙
	fsqrt
	fld  data[4]
	fmul 
	fst result

	fld data[8]
    fld data[0]     ;+a2log2x
	fyl2x
	fld result
	fadd 
	fstp result

    fld  data[0]    ;+a3sinx
	fsin 
	fld data[12]
	fmul
	fld result
	fadd 
	fstp  result

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax

    ret
Compute endp

Printchar	proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di

	mov ah, 02H
	mov	dl, al
	int 21h

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
	ret
Printchar	endp

Print proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    fstcw status	;以小数形式显示浮点数data
	or status,0c00h	;设定截取舍入方式
	fldcw status

    fld result	
	ftst			;判断是否是正数
	fstsw ax
	and	ax,4500h
	cmp ax,0100h
	jnz	Positive	;正数则跳转

	mov	al,'-'		;如果是负数
	call Printchar
	fabs

Positive:
    fld st
    frndint          ;舍入为整数
    fist whole       ;保存整数部分
    fsubr            ;浮点反减，减掉整数部分
    fabs
    fstp fract		;保存小数部分

    mov eax,whole	;转换为整数部分
	mov ebx,10		;bx用于存取整数10
	mov cx,0		;cx用于记录位数
	push bx
loop3:
	mov	edx,0
	div	ebx
	add	dl,30h		;变成ascii
	push dx			;存余数
	inc	cx
	cmp	eax,0		;比较商
	jnz	loop3
Disp1:

	pop	ax
	call Printchar		;输出整数部分
	loop	Disp1

	mov al,'.'
	call	Printchar	;输出小数点

	mov	eax, fract
	fstcw status
	xor	status, 0C00H
	fldcw status
	
	fld fract		
	fxtract
	fstp fract	;存取有效数
	fabs
	fistp whole	 ;存取指数位数

	mov	ecx,whole
	mov	eax,fract
	shl	eax,9		;逻辑左移
	rcr	eax,CL		;循环右移
loop4:
	mul ebx
	push eax
	xchg eax,edx		;交换eax，edx
	add	al, 30H
	call Printchar
	pop	eax
	cmp	eax, 0
	jnz	loop4

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
Print endp

.startup
    finit
    mov ecx,0
	lea dx,In_Output
	mov ah,09h
	int 21h					;输入提示字符串

    call Input				;调用接受输入的函数
	call Compute			;调用计算函数
	call Print				;调用打印函数
	jmp  Finish

Error:					    ;x小于0的情况	
	lea dx,Error_Output
	mov AH,09H
	int 21H	

Finish:
    .exit
end
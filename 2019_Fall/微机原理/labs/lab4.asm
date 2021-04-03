.model small

.data
    result db 100 dup(0)
    tmp db 100 dup(0)
    inbuffer db 3, ?, 3 dup(?)
    N db 00H

.stack 40960

.code

Input proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    lea dx, inbuffer
    mov ah, 0AH
    int 21h
    mov al, byte ptr inbuffer[1]        
    .if al == 01H
        mov al, byte ptr inbuffer[2]  ;输入为一位十进制整数
        sub al, 30H
        mov byte ptr N, al

    .else
        mov al, byte ptr inbuffer[2]   ;输入为两位十进制整数
        sub al, 30H
        mov dl, 10
        mul dl
        mov dl, byte ptr inbuffer[3]
        sub dl, 30H
        add al, dl
        mov byte ptr N, al 
    .endif
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret 
Input endp

Factorial proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    .if cl == 1                            ;N=1
        mov byte ptr result[0], 1
    .else
        push cx
        sub cl, 1
        call Factorial                     ;递归调用，N!=N*(N-1)!
        pop cx

        mov si, 99
        mov al, byte ptr result[si]        

        .while al == 00h                   ;找最高位
            dec si
            mov al, byte ptr result[si]
        .endw

        mov ax, si                         ;存储最高位位数
        mov si, 0
        .while si <= ax
            mov bl, byte ptr result[si]
            mov byte ptr tmp[si], bl
            inc si
        .endw

        .while cl > 1
            mov si, 99
            mov al, byte ptr result[si]

            .while al == 00h
                dec si
                mov al, byte ptr result[si]
            .endw

            mov ax, si
            mov si, 0
            .while si <= ax
                mov bl, byte ptr tmp[si]
                mov dl, byte ptr result[si]
                add dl, bl
                .if dl > 9
                    sub dl, 10
                    add byte ptr result[si+1], 1
                .endif
                mov byte ptr result[si], dl
                inc si
            .endw
            dec cl
        .endw
    .endif
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret 
Factorial endp

Printnum proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov bl, 99

    .while bx >= 0
        mov al, byte ptr result[bx]
        .if al != 00H
            .break
        .endif
        sub bx, 1
    .endw

    .while sword ptr bx >= 0           ;从最高位开始输出
        mov dl, byte ptr result[bx]
        add dl, 30H
        mov ah, 02h
        int 21h
        sub bx, 1
    .endw
    
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret 
Printnum endp

.startup

main:
    call Input
    mov cl, byte ptr N
    call Factorial
    call Printnum
.exit
end
.model small

.data
    infile db "lab3.txt",00H
    numberbuffer db 1000 dup(0)
    numbercount dw 0000H
    char db 00H
    isneg db 00h
    printcount dw 0000H

.stack 4096


.code


readnumbers proc    ; openfile and read all numbers in file
                    ; store them in numberbuffer
    push ax
    push bx
    push cx
    push dx
    push di
    push si

    lea dx, infile
    mov ax, 3D00H
    int 21H

    mov bx, ax ;bx is handle 
    mov ah, 3fh
    mov cx, 1
    lea dx, char
    int 21h
    mov di, 0
    mov si, 0
    .while ax != 0
        mov al, char
        .if al == 20h
            mov cl, isneg
            .if cl == 01h
                mov al, byte ptr numberbuffer[di]
                mov ah, byte ptr numberbuffer[di+1]
                not ax
                add ax, 1
                mov byte ptr numberbuffer[di], al
                mov byte ptr numberbuffer[di+1], ah
            .endif
            mov isneg, 00h
            
            add si, 1
            add di, 2
            mov byte ptr numberbuffer[di], 00H
            mov byte ptr numberbuffer[di+1], 00H
            jmp nextchar

        .endif

        .if al == 2dh
            mov isneg, 01h
            jmp nextchar
        .endif

        
        sub al, 30h
        mov ch, 00h
        mov cl, al
        mov al, byte ptr numberbuffer[di]
        mov ah, byte ptr numberbuffer[di+1]
        mov dx, 10
        mul dx

        add ax, cx
        
        mov byte ptr numberbuffer[di], al
        mov byte ptr numberbuffer[di+1], ah

nextchar:
        lea dx, char
        mov ah, 3fh
        mov cx, 1
        int 21h
    .endw

    mov cl, isneg
    .if cl == 1
        mov al, byte ptr numberbuffer[di]
        mov ah, byte ptr numberbuffer[di+1]
        not ax
        add ax, 1
        mov byte ptr numberbuffer[di], al
        mov byte ptr numberbuffer[di+1], ah
    .endif

    add si,1
    mov numbercount, si
    mov ah, 3eh
    int 21H

    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret
readnumbers endp


sort proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    
    mov di, 0           ;循环计数器
    mov si, 0
    mov dx, numbercount
    mov ax, 2
    mul dx
    mov dx, ax

    .while di < dx       ;外层循环N次
        
        mov si, di
        add si, 2

        mov al, byte ptr numberbuffer[di]
        mov ah, byte ptr numberbuffer[di+1]
        .while si < dx
            mov al, byte ptr numberbuffer[di]
            mov ah, byte ptr numberbuffer[di+1]

            mov bl, byte ptr numberbuffer[si]
            mov bh, byte ptr numberbuffer[si+1]

            .if sword ptr ax > sword ptr bx
                xchg ax, bx
            .endif

            mov byte ptr numberbuffer[di], al
            mov byte ptr numberbuffer[di+1], ah
            mov byte ptr numberbuffer[si], bl
            mov byte ptr numberbuffer[si+1], bh
     
            add si, 2
        .endw
        add di, 2
    .endw

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax

    ret

sort endp

printallnums proc        ;打印数字
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov di, 0
    mov cx, numbercount
    mov ax, 2
    mul cx
    mov cx, ax

    .while di < cx
        mov al, byte ptr numberbuffer[di]
        mov ah, byte ptr numberbuffer[di+1]
        .if sword ptr ax < 0
            mov dl, '-'
            call printchar
            neg ax
        .endif

        mov printcount, 0000h

        mov bl, 10
        div bl
        mov dl, ah
        add dl, 30h
        push dx
        mov bx, printcount
        add bx, 1
        mov printcount, bx

        .while al != 0
            mov ah, 00h
            mov bl, 10
            div bl
            mov dl, ah
            add dl, 30h
            push dx
            mov bx, printcount
            add bx, 1
            mov printcount, bx
        .endw

        mov bx, printcount
        .while bx > 0
            pop dx
            call printchar
            sub bx, 1
        .endw

        add di, 2
        mov dl, ' '
        call printchar
    .endw
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

printallnums endp

printchar proc      ;打印字符
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    mov ah, 02h
    int 21h
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
printchar endp

.startup

main:
    
    call readnumbers
    call sort  
    call printallnums

.exit

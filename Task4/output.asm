PUBLIC PrintMat

outputStr SEGMENT para public 'DATA'
    moutput db 13
           db 10
           db "Matrix: "
           db "$"
    newline db 13
            db 10
            db "$"
outputStr ENDS

codeOutput SEGMENT para public 'CODE' ; сегмент вывода матрицы по адресу ds:di
    ASSUME es:outputStr
    PrintMat:
        push di 

        mov ax, outputStr
        mov es, ax

        mov dx, OFFSET moutput
        call writeMsgES

        mov al, [di] ; Столбцы
        jz printMatReturn
        inc di
        mov ah, [di] ; Строки
        jz printMatReturn
        inc di

        xor cx, cx

        mat:
            call printRow
            inc ch
            cmp ch, ah
            jl mat
        
        printMatReturn:
        pop di
        retf

    printRow:
        push cx

        xor cx, cx

        mov dx, OFFSET newline
        call writeMsgES

        row:
            call printNum
            inc di
            inc cl
            cmp cl, al
            jl row

        pop cx
        ret
    
    printNum:
        push ax

        mov ah, 02h
        mov dl, 20h
        int 21h

        mov dl, [di]
        add dl, 30h
        int 21h

        pop ax
        ret


    writeMsgES: ; Пишет в консоль строку по адресу es:dx
        push ax
        push ds
        mov ax, es
        mov ds, ax

        mov ah, 09h
        int 21h

        pop ds
        pop ax
        ret
codeOutput ENDS
END

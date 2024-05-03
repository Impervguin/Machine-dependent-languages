PUBLIC PrintMat

outputStr SEGMENT para public 'DATA'
    moutput db 13
            db 10
            db "Matrix: "
            db "$"
    
    newline db 13
            db 10
            db "$"

    emptyoutput db 13
                db 10
                db "Empty matrix."
                db "$"

outputStr ENDS

codeOutput SEGMENT para public 'CODE' ; сегмент вывода матрицы по адресу ds:di
    ; Первые два байта - количество столбцов и строк матрицы, далее построчно байты матрицы чисел
    ASSUME es:outputStr
    PrintMat:
        push di ; Запоминаем адрес матрицы в стеке

        ; В es храним строки вывода
        mov ax, outputStr
        mov es, ax

        ; ah - строки матрицы, al - столбцы
        mov al, [di] ; Столбцы
        jz printMatEmpty ; Если один из размеров нулевой, то выходим
        inc di
        mov ah, [di] ; Строки
        jz printMatEmpty ; Пустая матрица
        inc di


        ; Выводим обозначение матрицы
        mov dx, OFFSET moutput
        call writeMsgES

        xor cx, cx ; Обнуляем cx, и используем его как счётчик цикла

        mat:
            call printRow ; Пишем строку матрицы по [di]
            inc ch
            cmp ch, ah
            jl mat ; Пока ch < al
        
        jmp printMatReturn ; Успешное завершение
        

        printMatEmpty:
            mov dx, OFFSET emptyoutput
            call writeMsgES
            jmp printMatReturn

        printMatReturn:
            pop di
            retf

    printRow: ; Вывод строки матрицы, расположенной по адресу ds:di
    ; ah - столбцы матрицы, al - строки матрицы
    ; Переводит di на следующую строку матрицы
        push cx

        xor cx, cx ; Обнуляем cx для использования счётчиком

        ; Переводим на новую строку
        mov dx, OFFSET newline
        call writeMsgES


        row: ; Вывод строки матрицы
            call printNum ; Вывод числа по ds;di
            inc di
            inc cl
            cmp cl, al
            jl row ; Пока cl < al
        
        ; Из-за хранения
        mov ch ,9
        sub ch, cl
        xor cl, cl
        xchg cl, ch
        add di, cx

        pop cx
        ret
    
    printNum: ; Вывод числа по адресу ds:di
        push ax

        mov ah, 02h 
        mov dl, 20h ; Пробел
        int 21h

        mov dl, [di] ; Число
        add dl, 30h ; Перевод в ascii символ
        int 21h

        pop ax
        ret


    writeMsgES: ; Пишет в консоль строку по адресу es:dx
        push ax
        push ds
        ; Переводим регистр es в ds
        mov ax, es
        mov ds, ax

        mov ah, 09h ; Вывод строки по адресу ds:dx
        int 21h

        pop ds
        pop ax
        ret
codeOutput ENDS
END

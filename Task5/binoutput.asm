public BinaryOutput

outputtext SEGMENT para public 'data'
    prompt db 10
           db 13
           db "Unsigned number in binary format: "
           db "$"
outputtext ENDS

binarynum SEGMENT para public 'data'
    binary db 15 dup(0) ; Строка с бинарным числом в виде строки
    lastdigit db 1 dup(0)
              db "$"
binarynum ENDS


outputcode SEGMENT para public 'code'
    BinaryOutput: ; Вывод числа в двоичной системе счисления в беззнаковой интерпретации
        ; es:di - Число
        ASSUME ds:outputtext

        mov ax, outputtext
        mov ds, ax

        ; Выводим пояснение
        mov ah, 09h
        mov dx, offset prompt
        int 21h

        mov ax, es
        mov ds, ax ; es -> ds

        mov ax, [di] ; Считываем число в ax
        
        ASSUME ds:binarynum
        mov bx, binarynum
        mov ds, bx

        mov bx, offset lastdigit
        mov si, bx ; ds:si - Младший разряд числа в двоичном виде

        mov bx, 2 ; Делитель
        writeloop:
            xor dx, dx
            div bx ; Делим число на 2

            add dl, 30h ; Переводим остаток в ascii-символ
            mov [si], dl ; Записываем символ в строку
            dec si ; Смещаем указатель к старшему разряду

            cmp ax, 0 ; Пока число не стало 0
            jg writeloop
        
        inc si ; Смещаем к последнему заполненному разряду

        mov ah, 09h ; Выводим число в виде строки
        mov dx, si
        int 21h

        xor ax, ax ; Успешный код возврата

        retf
outputcode ENDS
END
public HexOutput

outputtext SEGMENT para public 'data'
    prompt db 10
           db 13
           db "Signed cutted number in hex format: "
           db "$"
outputtext ENDS

hexnum SEGMENT para public 'data'
    hex db 3 dup(0) ; Строка шестнадцатеричного числа
    lastdigit db 1 dup(0) ; Младший разряд числа
              db "$"
hexnum ENDS


outputcode SEGMENT para public 'code'
    HexOutput: ; Выводит урезанное до 8 бит число в шестнадцатеричном виде в знаковой интерпретации
        ; es:di - число
        ASSUME ds:outputtext

        mov ax, outputtext
        mov ds, ax

        ; Вывод пояснения
        mov ah, 09h
        mov dx, offset prompt
        int 21h

        mov ax, es
        mov ds, ax

        xor ah, ah
        mov al, [di] ; Считываем младшие 8 бит числа
    

        add al, 0 ; Получаем в CF старший бит числа
        jns write ; Если cf != 1, то сразу пишем число
        mov bx, ax ; Запоминаем число
        
        ; Выводим -
        mov ah, 02h 
        mov dl, '-'
        int 21h
        mov ax, bx

        dec al ; Переводим из доп кода число
        not al

        write: ; Пишем число al в шестнадцатеричном виде
            ASSUME ds:hexnum
            mov bx, hexnum
            mov ds, bx
            mov bx, offset lastdigit

            mov si, bx ; ds:si - Младший разряд шестнадцатеричного числа
            mov bl, 16 ; Делитель
        writeloop:
            xor ah, ah
            div bl ; Делим al на bl
            cmp ah, 10 ; ah - остаток от деления
            ; Если ah > 10 - Выводим символ
            ; Если ah <= 9 - цифру
            jge letter
            jmp number
            
            letter:
                add ah, 7 ; Разница между 9 и A в таблице ascii
            number:
                add ah, 30h ; Смещение от числа до '0' в ascii
            
            mov [si], ah ; Записываем текущий разряд
            dec si ; Смещаемся к старшему
            cmp al, 0 ; Пока число не равно 0
            jg writeloop
        
        inc si ; Возвращаемся к ближайшему заполненному разряду

        ; Выводим созданное число как строку
        mov ah, 09h
        mov dx, si
        int 21h
        xor ax, ax ; Успешный код возврата
        retf
outputcode ENDS
END
EXTRN DecimalInput:far
EXTRN BinaryOutput:far
EXTRN HexOutput:far
EXTRN BinDegree:far

stk SEGMENT para stack 'stack'
    db 200 dup(0)
stk ENDS

textdata SEGMENT para public 'data'
    menutext db 13
             db 10 
             db "Menu:"
             db 10
             db 13
             db "1. Input decimal number."
             db 10
             db 13
             db "2. Print unsigned bin number."
             db 10
             db 13
             db "3. Print cutted hex number."
             db 10
             db 13
             db "4. Print minimal degree of 2 higher then number."
             db 10
             db 13
             db "5. Exit"
             db 10
             db 13
             db "Choice: "
             db "$"
    menuErrText db 10
                db 13
                db "Incorrect input."
                db "$"
textdata ENDS

commandsarr SEGMENT para public 'data'
    commands dd 1 dup(DecimalInput) ; Ввод десятичного числа
    dd 1 dup(BinaryOutput) ; Вывод беззнакового в двоичном виде
    dd 1 dup(HexOutput) ; Вывод урезанного(8 бит) в знаковом шестнадцатиричном виде
    dd 1 dup(BinDegree) ; Минимальная степень двойки большая числа
    dd 1 dup(exit) ; Выход
commandsarr ENDS

numberseg SEGMENT para public 'data'
    number dw 1 dup(0) ; 2 байта по хранение числа
numberseg ENDS

menuseg SEGMENT para public 'code'
    ASSUME es:numberseg, ds:commandsarr
    menu:
        mov ax, numberseg
        mov es, ax
        mov ax, commandsarr
        mov ds, ax

        mov si, offset commands ; ds:si - Область памяти с командами
        mov di, offset number ; es:di - Область памяти с числом

        actInput:
            call printmenu
            mov ah, 01h ; Чтение выбора в меню
            int 21h
            sub al, 30h ; Перевод  в число
            ; Проверки на корректный ввод команды
            cmp al, 6 
            jge incorrectInput
            cmp al, 0
            je incorrectInput

        correctInput: ; Корректная команда
            call callArrProgram
            cmp al, 0 ; al = 0 - Успешное завершение команды
            je actInput
            call printMenuInputErr
            jmp actInput

        incorrectInput:
            call printMenuInputErr
            jmp actInput


    printmenu: ; Вывод меню из сегмента textdata
        ASSUME ds:textdata
        push ds

        mov ax, textdata
        mov ds, ax

        mov dx, offset menutext
        mov ah, 09h
        int 21h

        pop ds
        ret
    
    printMenuInputErr: ; Ошибка некорректного ввода
        ASSUME ds:textdata
        push ds

        mov ax, textdata
        mov ds, ax

        mov dx, offset menuErrText
        mov ah, 09h
        int 21h

        pop ds
        ret

    callArrProgram: ; Вызов команды по номеру
        ; al - Номер команды
        ; ds:si - Начало команд
        push ds 
        push si
        
        xor ah, ah
        dec al ; Номер в индекс
        mov bl, 4 
        mul bl ; Умножаем индекс на размер команды(4 байта)
        add si, ax ; Добавляем смещение al-ой команды
        
        ; ptr - Перевод в 4-байтный указатель
        call far ptr [si] ; Вызываем команду
        
        pop si
        pop ds
        ret
    exit: ; Завершение программы
        mov ah, 4Ch
        int 21h
menuseg ENDS
END menu
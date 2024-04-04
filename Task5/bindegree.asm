.386 ; Для использования BT
public BinDegree

outputtext SEGMENT USE16 para public 'data'
    prompt db 10
           db 13
           db "Minimum degree of 2 greater then number: "
           db "$"
outputtext ENDS

numtext SEGMENT USE16 para public 'data'
    prompt2 db 10
           db 13
           db "2 in that degree: "
           db "$"
    bin16 db "65536$"
    number db 5 dup(0)
    lastdigit db 1 dup(0)
              db "$"
numtext ENDS

bindegreecode SEGMENT USE16 para public 'code'
    BinDegree: ; Ищет минимальную степень двойки, большую данного числа
        ; es:di - Число
        ; Result:dx - Найденная степень двойки
        ASSUME ds:outputtext

        mov ax, outputtext
        mov ds, ax

        mov ah, 09h
        mov dx, offset prompt ; Выводим сообщение для степени
        int 21h
        
        mov ax, es ; В ds помещаем сегмент с числом
        mov ds, ax
        
        mov ax, [di] ; Читаем число
        
        xor dx, dx
        cmp ax, 0
        je afterfind ; Если число ноль, то искомая степень - 0
        bsr dx, ax ; Ищем самый старший бит с 1
        inc dx ; искомая степень та, в которой бит на 1 позднее старщего в числе
        
        afterfind:
        push dx ; Запоминаем степень
        mov ax, dx
        mov bl, 10
        div bl ; Выделяем десятки и единицы степени
        ; ah - единицы, al - десятки

        mov dx, ax
        add dh, 30h ; Переводим цифры в ascii
        add dl, 30h
        

        mov ah, 02h
        higher: ; Выводим разряд десятков
        cmp dl, 30h
        je lower ; Если он равен '0', то его не выводим
        int 21h
        
        lower: ; Выводим разряд единиц
        xchg dh, dl
        int 21h
        pop dx

        ; Выводим 2 в найденной степени
        ASSUME ds:numtext
        mov ax, numtext
        mov ds, ax

        mov cx, dx ; Запоминаем в cx найденную степень
        mov dx, offset prompt2 ; Выводим сообщение для двойки
        mov ah, 09h
        int 21h

        cmp cx, 16
        je degree16 ; 2 ^ 16 не поместить в регистр, поэтому выводим заранее заготовленную строку
        jmp degreeother ; Остальные степени

        degree16:
            mov dx, offset bin16
            jmp printdegree
        degreeother: ; Остальные степени
            mov si, offset lastdigit ; Указатель на младший разряд
            xor ax, ax ; ax = 2 ^ dx
            bts ax, cx ; Устанавливаем нужный бит
            mov bx, 10 ; Делитель
            lo:
                xor dx, dx
                div bx 

                add dx, 30h
                mov [si], dl ; Саписываем текущий разряд
                dec si

                cmp ax, 0 ; Пока число не равно 0
                jne lo
            inc si

            mov dx, si ; Помещаем указатель на число в dx для вывода
            jmp printdegree
        printdegree:
            mov ah, 09h
            int 21h
        exit:
            mov dx, cx ; Возвращаем в dx степень
            xor ax, ax ; Успешный код возврата
            retf

bindegreecode ENDS
END
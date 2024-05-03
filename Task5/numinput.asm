public DecimalInput

decimalnum SEGMENT para public 'data'
    decimal db 1 dup(1 + 1 + 5 + 1 + 2) ; Макс длина вводимого числа
            db 1 + 1 + 5 + 1 + 2 dup(0) ; Длина ввёденой строки | Знак числа | 5 цифр(Макс 32767) | $ + 2 запасных символа
decimalnum ENDS

inputtext SEGMENT para public 'data'
    prompt db 10
           db 13
           db "Input decimal number([-32768, 32767]): "
           db "$"
inputtext ENDS

inputcode SEGMENT para public 'code'
    DecimalInput: ; Считывает 16-битное десятичное знаковое число и помещает по адресу es:di
        ASSUME ds:inputtext

        mov ax, inputtext
        mov ds, ax
        ; Выводи приглашение ко вводу
        mov dx, offset prompt
        mov ah, 09h
        int 21h
        
        ASSUME ds:decimalnum
        mov ax, decimalnum
        mov ds, ax
        
        ; Вводим десятичное число как строку 
        mov ah, 0Ah
        mov dx, offset decimal
        int 21h

        mov si, dx
        inc si ; Смещаем на количество считанных символов

        
        xor cx, cx
        xor dx, dx
        xor ax, ax
        xor bx, bx

        mov cl, [si] ; cl - кол-во символов
        inc si
        mov al, [si] ; al - Знак или старшая цифра числа
        inc si
        
        cmp al, '-' 
        je minus
        cmp al, '+'
        je sign
        jmp todec ; Если цифра то сразу её начинаем обрабатывать

        minus: ; Если первый символ минус, то в bx храним 1
            mov bx, 1
        sign: ; Если любой знак уменьшаем число цифр
            dec cx
        read: ; Чтение очередного символа
            mov al, [si] ; 
            inc si
        todec:
            sub al, 30h ; Получаем цифру из ascii-символа
            cmp al, 9 ; Если больше 9, то не цифра
            jg error

            ; Смещаем текущее значение числа на разряд(десятичный) влево
            push ax
            
            mov ax, 10
            imul dx
            mov dx, ax
            
            pop ax

            jo error ; Если переполнилось при умножении, то число не влезает в 16 бит
            add dx, 0 ; В CF - старший бит
            jc error ; Если старший бит 1, то число не влезло в диапазон

            add dx, ax
            jns loopread ; Если старший бит 0, то пока корректное число
            cmp dx, 8000h ; Если старший бит 1 и число не равно 32768, то не влезает в диапазон
            jne error
            cmp bx, 1 ; Если число равно 32768 и вводится не отрицательное число, то не влезает в диапазон
            jne error

            loopread:
            loop read
        
        success:
            cmp bx,1 ; Если bx == 1, то число отрицательное, значит переводим в доп. код
            jne writenum
            neg dx

        writenum: ; Записываем число в es:di
            mov ax, es
            mov ds, ax
            ; Записываем число в порядке little-endian
            mov [di], dl 
            mov [di + 1], dh
            xor ax, ax; Успешный код возврата
            jmp exit
        error:
            mov ax, 1 ; Код ошибки
        exit:
            retf
inputcode ENDS
END
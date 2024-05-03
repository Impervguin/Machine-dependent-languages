PUBLIC MatInput


inputStr SEGMENT para public 'DATA'
    winput db 13
           db 10
           db "Input width: "
           db "$"
    hinput db 13
           db 10
           db "Input height: "
           db "$"
    minput db 13
           db 10
           db "Input matrix(nums without spaces or enters): "
           db "$"
    einput db 13
           db 10
           db "Incorrect input."
           db "$"
    newline db 13
            db 10
            db "$"
    rowinput db 13
             db 10
             db "Row "
             db "$"
inputStr ENDS


codeInput SEGMENT para public 'CODE' ; сегмент ввода матрицы
    ASSUME es:inputStr
    MatInput: ; Считывает матрицу в адрес ds:di,
    ; где сначала байт кол-ва столбцов, байт кол-во строк, далее матрица построчно
    ; result: ah - кол-во строк, al - кол-во столбцов
        push di
        ; В es сегмент с текстом ввода
        mov ax, inputStr
        mov es, ax
        
        ; Приглашение ввода кол-во столбцов(ширины)
        mov dx, OFFSET winput
        call writeMsgES

        ; Ввод числа
        call digitInput
        jnz error
        and al, al
        jz error
        mov [di], al
        mov bl, al ; записываем в bl количество столбцов
        inc di

        ; Приглашение ко вводу кол-ва строк
        mov dx, OFFSET hinput
        call writeMsgES
        
        ; Ввод высота
        call digitInput
        jnz error
        and al, al
        jz error
        mov [di], al
        mov bh, al ; записываем в bh количество строк
        inc di

        mov ax, bx
        
        ; Приглашение к вводу матрицы
        mov dx, OFFSET minput
        call writeMsgES

        call inputMatrix ; Ввод матрицы
        jz return

        error: ; В случае ошибки зануляем размеры ввёденной матрицы
            xor ax, ax
            pop di
            push di
            mov [di], ax
            inc di
            mov [di], ax
            mov dx, OFFSET einput
            call writeMsgES
        
        return:
            pop di
            retf
    
    digitInput: ; Ввод цифры
        ; ah - Введённая цифра
        ; zf=1 - Успех, zf=0 - неудача
        mov ah, 01h
        int 21h

        sub al, '0'
        cmp al, 9
        jg digitInputError
        cmp al, 0
        jl digitInputError
        
        xor ah, ah ; zf=1
        ret
        digitInputError:
            inc al ; zf=0
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
    
    inputMatrix: ; Ввод матрицы в транспонированном виде, ah - Кол-во строк, al - столбцов, ds:di - матрица
        ; zf=1 - Успех, zf=0 - неудача
        push di
        xor cx, cx ; Записываем в стек 0, как текущий индекс итерации
        push cx
        Lmat:
            ; Приглашение ко вводу
            push ax 
            mov al, cl ; al - Номер вводимой строки
            inc al
            call RowString
            pop ax


            xor cl, cl ; Зануляем cl, в котором будем хранить текущую итерацию ввода строки
            mov ch, al ; В ch храним количество столбцов матрицы

            Lrow: ; Ввод строки
                call digitInput
                jnz errInput
                
                mov [di], al ; Записываем введённую цифру в соотв строку столбца
                inc di
                inc cl 
 
                cmp cl, ch ; Пока не ввели всю строку
                jl Lrow
            
            mov cl, 9
            sub cl, ch
            xor ch, ch
            add di, cx

            pop cx
            inc cx ; Увеличиваем номер текущей строки ввода
            push cx ; Возвращаем его в стек

            cmp cl, ah ; Пока не ввели все строки
            jl Lmat
        jmp returnMat
        errInput:
            pop ax
            pop cx
            pop di
            inc dx ; zf=0
            ret
        returnMat:
            pop cx
            pop di ; Возвращаем di к началу матрицы
            xor dx, dx ; zf=1
            ret
        
    RowString: ; Вывод приглащения ко вводу строки матрицы
    ; al - Номер вводимой строки
        push dx
        mov dx, OFFSET rowinput 
        call writeMsgES
        
        mov dl, al
        add dl, 30h ; Номер строки
        mov ah, 02h
        int 21h

        mov dl, 3Ah ; Двоеточие
        int 21h

        mov dl, 20h ; Пробел
        int 21h

        pop dx
        ret


codeInput ENDS
END 

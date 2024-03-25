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
inputStr ENDS


codeInput SEGMENT para public 'CODE' ; сегмент ввода матрицы
    ASSUME es:inputStr
    MatInput: ; Считывает матрицу в адрес es:dx,
    ; где сначала байт ширина, байт высота, далее матрица в транспонированном виде
        push di
        mov ax, inputStr
        mov es, ax
        

        mov dx, OFFSET winput
        call writeMsgES

        call digitInput
        jz return
        mov [di], al
        mov bl, al ; записываем в bl количество столбцов
        inc di

        mov dx, OFFSET hinput
        call writeMsgES

        call digitInput
        jz return
        mov [di], al
        mov bh, al ; записываем в bh количество строк
        inc di

        mov ax, bx
        mov dx, OFFSET minput
        call writeMsgES

        call inputMatrix

        return:
            pop di
            retf
    
    digitInput:
        mov ah, 01h
        int 21h

        sub al, 30h
        cmp al, 10
        
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
    
    inputMatrix: ; Ввод матрицы в транспонированном виде, ah - Кол-во строк, al - столбцов
        push di
        xor cx, cx ; Записываем в стек 0, как текущий индекс итерации
        push cx
        Lmat:
            xor cl, cl ; Зануляем cl, в котором будем хранить текущую итерацию ввода строки
            mov ch, al ; В ch храним количество столбцов матрицы
            push ax ; Запоминаем ax
            Lrow: ; Ввод строки
                call digitInput
                jz errInput
                
                mov [di], al ; Записываем введённую цифру в соотв строку столбца
                inc di
                inc cl 
 
                cmp cl, ch ; Пока не ввели всю строку
                jl Lrow
            
            pop ax

            pop cx
            inc cx ; Увеличиваем номер текущей строки ввода
            push cx ; Возвращаем его в стек

            cmp cl, ah ; Пока не ввели все строки
            jl Lmat
        
        returnMat:
            pop cx
            pop di ; Возвращаем di к началу матрицы
            ret
        errInput:
            pop ax
            pop cx
            pop di
            mov dx, 0
            mov [di], dl
            ret
        

codeInput ENDS
END 

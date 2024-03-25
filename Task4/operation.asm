PUBLIC DeleteMostEvenColumn


codemain SEGMENT para public 'CODE' ; главный сегмент
    DeleteMostEvenColumn:
        push di

        mov al, [di] ; Столбцы
        inc di
        mov ah, [di] ; Строки
        inc di

        call findEvenMat
        
        xor bl, bl
        mov bl, cl

        call deleteColumn

        pop di
        dec al
        mov [di], al


        ret


    findEvenMat: ; di - матрица, es:di - массив, куда записываются количетсво чётных в каждом столбце
    ; ah - кол-во строк матрицы, al - количество столбцова матрицы
    ; result: cx - номер столбца, с максимальным числом чётных
        push di

        xor bx, bx
        xor cx, cx ; ch - индекс максимального столбца, cl - его значение

        countEvenMat:

            call countEvenColumn
            cmp dl, cl
            jle smaller

            mov ch, bl
            mov cl, dl

            smaller:
            inc bl
            inc di
            cmp bl, al
            jl countEvenMat
        
        mov cl, ch
        xor ch, ch

        pop di
        ret
    
    countEvenColumn: ; ds:di - первое число нужного столбца, 
    ; ah - кол-во строк матрицы, al - количество столбцова матрицы
    ; result: dl - количество чётных в столбце числом чётных
        push di
        push cx
        xor cx, cx ; ch - итерация, cl - количество чётных
        xor dx, dx
        
        count:
            mov dx, [di]
            test dx, 1
            jnz no
            inc cl
            no:

            xor dx, dx
            mov dl, al
            add di, dx

            inc ch
            cmp ch, ah
            jl count
        
        xor dx, dx
        mov dl, cl

        pop cx
        pop di
        ret

    deleteColumn:; ds:di - матрица, bl - индекс удаляемого столбца
    ; ah - кол-во строк матрицы, al - количество столбцов матрицы
        push di

        xor cx, cx
        mov cl, ah

        mov dx, di
        add dl, bl
        mov di, dx

        deleteloop:
            xor dx, dx
            add dl, al

            push ax
            mov al, cl
            mul dl
            mov dx, ax
            pop ax

            sub dl, bl
            dec dl

            call shiftArray

            
            mov dx, di
            add dl, al
            dec dl
            mov di, dx

            loop deleteloop


        pop di
        ret

    shiftArray: ; dx - Количество смещаемых ячеек
        push si
        push di
        push cx


        mov cx, dx
        jz shiftReturn

        mov dx, di
        inc dx
        mov si, dx

        shiftLoop:
            mov dl, [si]
            mov [di], dl

            inc di
            inc si

            loop shiftLoop

        
        
        shiftReturn:
        pop cx
        pop di
        pop si
        ret

        
codemain ENDS
END 
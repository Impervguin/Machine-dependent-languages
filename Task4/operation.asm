PUBLIC DeleteMostEvenColumn


codemain SEGMENT para public 'CODE' ; сегмент задачи
    DeleteMostEvenColumn: ; Удаление столбца с наибольшим числом чётных чисел в матрице
    ; Если столбцов с максимальным количеством несколько, то удаляется первый
    ; ds:di - Матрица в формате, первые два байта - кол-во столбцов и строк матрицы, далее её элементы построчно
        push di ; Запоминаем в стеке исходный адрес матрицы

        mov al, [di] ; Столбцы
        inc di
        mov ah, [di] ; Строки
        inc di

        ; Ищем индекс столбца с максимальным числом чёётных чисел
        call findEvenMat
        ; cl - индекс искомого столбца
        ; Переносим его в bl
        xor bl, bl
        mov bl, cl


        ; Удаляем столбец матрицы с индексом bl
        call deleteColumn

        pop di ; Возвращаем адрес матрицы
        dec al ; Уменьшеаем количество столбцов на 1
        mov [di], al ; записываем кол-во столбцов


        ret


    findEvenMat: ; ds:di - матрица, 
    ; ah - кол-во строк матрицы, al - количество столбцо матрицы
    ; result: cx - номер столбца, с максимальным числом чётных
        push di
        push ax

        xor bx, bx
        xor cx, cx ; ch - индекс максимального столбца, cl - кол-во столбцов

        ; Ищем максимальное по все столбцам
        countEvenMat:

            call countEvenColumn ; Считаем столбец матрицы по адресу di
            ; в dl - кол-во чётных чисел
            cmp dl, cl ; Если больше текущего максимального, то нынешний становится новым максимальнымц
            jle smaller

            ; Новый максимальный столбец
            mov ch, bl
            mov cl, dl

            smaller:
            ; Переход к следующему столбцу
            inc bl
            inc di
            cmp bl, al
            jl countEvenMat ; Пока bl < al
        
        ; Индекс столбца в cl
        mov cl, ch
        xor ch, ch
        pop ax
        pop di
        ret
    
    countEvenColumn: ; Считает кол-во чётных элементов в столбце матрицы
    ; ds:di - первое число нужного столбца, 
    ; ah - кол-во строк матрицы, al - количество столбцов матрицы
    ; result: dl - количество чётных в столбце числом чётных
        push di
        push cx
        push ax
        xor cx, cx ; ch - итерация, cl - количество чётных
        xor dx, dx

        mov al, 9 ; Из-за хранения
        
        count:
            mov dx, [di] ; Текущее число
            test dx, 1 ; Проверяем последний бит числа(если zf=1, то число чётное)
            jnz no
            inc cl ; Увеличиваем счётчик чётных чисел
            no:

            xor dx, dx
            mov dl, al
            add di, dx ; Сдвигаем di на кол-во столбцов(на следующий элемент столбца)

            inc ch
            cmp ch, ah
            jl count ; Пока прошли не все строки
        
        xor dx, dx
        mov dl, cl ; В dl помещаем кол-во чётных в столбце

        pop ax
        pop cx
        pop di
        ret

    deleteColumn: ; Удаление столбца матрицы
    ; ds:di - матрица, bl - индекс удаляемого столбца
    ; ah - кол-во строк матрицы, al - количество столбцов матрицы
        push di
        push ax

        xor cx, cx ; Счётчик цикла
        mov cl, ah 

        mov dx, di
        add dl, bl
        mov di, dx ; Смещаем указатель на удаляемый столбец

        mov al, 9 ; Из-за хранения

        deleteloop:
            xor dx, dx
            ; Считаем кол-во элементов в матрице после текущего
            add dl, al ; Кол-во элементов в столбце
            
            ; ; Умножаем на оставшееся число строк
            ; push ax
            ; mov al, cl
            ; mul dl
            ; mov dx, ax
            ; pop ax

            sub dl, bl ; Вычитаем кол-во элементов левее текущего
            dec dl ; Вычитаем текущий
            
            call shiftArray ; Смещаем влево все элементы после текущего на 1
            ; Тем самым удаляя его

            mov dx, di 
            add dl, al ; Сдвигаем указатель матрицы на следующий элемент в стобце
            mov di, dx

            loop deleteloop ; Пока не прошли по всем строкам

        pop ax
        pop di
        ret

    shiftArray: ; Смещает dx байт влево на 1 в ds:di
    ; dx - Количество смещаемых ячеек
        push si
        push di
        push cx


        mov cx, dx
        jz shiftReturn ; Если кол-во смещаемых ячеек 0

        mov dx, di
        inc dx
        mov si, dx ; [si] - смещаемый элемент

        shiftLoop:
            ; Смещаем элемент [si] в [di](на одну влево)
            mov dl, [si]
            mov [di], dl
            
            ; Сдвигаем указатели
            inc di
            inc si

            loop shiftLoop ; Пока не прошли по всем смещаемым

        
        
        shiftReturn:
        pop cx
        pop di
        pop si
        ret

        
codemain ENDS
END 
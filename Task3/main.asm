EXTRN input : far ; Директива для меток из других модулей

stk SEGMENT para STACK 'STACK'
    db 100 dup(0) ; 64h
stk ENDS

codemain SEGMENT para public 'CODE' ; главный сегмент
    main:
        call input ; Дальний вызов ввода из другого сегмента
        ; При этом в стек записывается адрес текущего сегмента(CS) и значение IP
        
        mov dl, al ; Перемещение результата в dl
        mov ah, 02h ; Код вывода символа из dl
        int 21h 
        mov ah, 4Ch ; Код завершения
        int 21h
codemain ENDS
END main
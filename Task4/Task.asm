EXTRN MatInput : far
EXTRN PrintMat : far
EXTRN DeleteMostEvenColumn : near

stk SEGMENT para STACK 'STACK'
    db 200 dup(0)
stk ENDS

matdata SEGMENT para public 'DATA'
    w db 1 dup(1)
    h db 1 dup(2)
    mat db 9 * 9 dup(3)
matdata ENDS


codemain SEGMENT para public 'CODE' ; главный сегмент
    ASSUME ds:matdata
    main:
        mov ax, matdata
        mov ds, ax
        mov di, OFFSET w
        
        call matInput
        cmp ax, 0
        je terminate

        call DeleteMostEvenColumn
        call PrintMat

        terminate:
        mov ah, 4Ch ; Код завершения
        int 21h
codemain ENDS
END main



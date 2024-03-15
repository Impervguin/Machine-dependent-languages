PUBLIC input ; Делает доступной метку input в других модулях

codelib SEGMENT para public 'CODE'
    input:
        mov ah, 08h ; Код чтения символа без эха
        int 21h 
        retf ; Дальнее возвращение(Читает 4 байта из стека и помещает адрес нового сегмента кода в CS)
codelib ENDS
END
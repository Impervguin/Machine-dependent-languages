.model tiny
; 08h тоже подходит
INTCODE EQU 1Ch
INSTALLED EQU 1Ch
MINSPEED EQU 00011111b
MAXSPEED EQU 0
TICKSPERSECOND EQU 18

code SEGMENT para public 'code'
    ASSUME cs:code
    org 100h ; PSP
    
    start: ; Переменные резидентной части 
        jmp initialize
        prev dd 1 dup(0) ; Предыдущее прерывание по INTCODE
        ticks db 1 dup(0) ; Количество вызовов прерывания(тиков)
        error db 1 dup(0) ; Ошибка(так как реальная частота ~ 18.2гц, то накапливаем ошибку, и каждую 5-ю секунду ждем дополнительный тик)
        speed db 1 dup(MINSPEED) ; Скорость автопечати
        installation dw 1 dup(INSTALLED) ; Флаг установки резидента

    resident: ; Резидентная часть
        ; push ax
        ; push bx
        ; push cx
        ; push dx
        
        ; Предыдущее прерывание
        ; pushf
        ; push cs
        ; mov ax, offset afterprev
        ; push ax
        ; jmp cs:prev

        inc ticks
        cmp error, 4 ; Если 5-я секунда, то на один тик больше
        jge werror
        jmp withouterror

    werror: ; с ошибкой
        cmp ticks, TICKSPERSECOND + 1
        jl return ; Пока не прошли все тики за секунду, ничего не делаем
        mov error, 0 ; Сбрасываем ошибку
        jmp incspeed

    withouterror:
        cmp ticks, TICKSPERSECOND
        jl return ; Пока не прошли все тики за секунду, ничего не делаем
        inc error ; Увеличиваем ошибку
        jmp incspeed
    
    incspeed: ; Увеличение скорости
        mov ticks, 0 ; Сбрасываем тики
        dec speed ; Увеличиваем скорость(иронично)
        cmp speed, MAXSPEED
        jg changespeed ; Если скорость ниже(математически выше) максимальной, просто меняем её на порту
        mov speed, MINSPEED ; Сбрасываем скорость до минимальной
        jmp changespeed
    
    changespeed:
        mov al, 11110011b ; f3h Команда установки автоповтора
        out 60h, al
        mov al, speed ; Задаём скорость
        out 60h, al
        jmp return

    return: ; Завершение резидента
        ; pop ax
        ; pop bx
        ; pop cx
        ; pop dx
        ; Предыдущее прерывание
        ; pushf
        ; push cs
        ; mov ax, offset afterprev
        ; push ax
        ; Без этого выводит на каждый тик символы прерывание 08
        mov ax, 0
        jmp cs:prev
    ; afterprev:
    ;     iret
    
    initialize: ; Инициализация резидента
    mov ah, 35h
    mov al, INTCODE ; Получения прерывания
    int 21h
    
    cmp es:installation, INSTALLED 
    je remove ; Если уже установлено данное прерывание, то удаляем его
    
    ; Запоминаем исходное прерываение
    mov word ptr cs:prev, bx 
    mov word ptr cs:prev[2], es

    ; Записываем в таблицу данный резидент(ds:dx)
    mov al, INTCODE
    mov ah, 25h
    mov dx, offset resident
    mov bx, cs
    mov ds, bx
    int 21h

    mov al, 11110011b ; f3h Команда установки автоповтора
    out 60h, al
    mov al, MINSPEED ; Задаём минимальную скорость
    out 60h, al

    ; Выводим сообщение об установке
    mov dx, offset instMessage
    mov ah, 09h
    int 21h

    ; Удаляем из памяти все, что идёт после инициализации
    mov dx, offset initialize
    int 27h

    remove: ; Удаление установленного резидента
        
        ; Записываем предыдущее прерываение обратно
        mov dx, word ptr es:prev
        mov ds, word ptr es:prev[2]

        mov al, INTCODE
        mov ah, 25h
        int 21h

        ; Удаляем из памяти резидент(es:0000)
        mov ah, 49h
        int 21h

        mov al, 11110011b ; f3h Команда установки автоповтора
        out 60h, al
        mov al, MAXSPEED ; Задаём максимальную скорость
        out 60h, al

        ; Выводим сообщение об удалении резидента
        mov ax, cs
        mov ds, ax

        mov dx, offset removeMessage
        mov ah, 09h
        int 21h

        ; Завершение
        mov ah, 4Ch
        int 21h

    instMessage db "Enjoy changing autorepeat)))$"
    removeMessage db "No more changing autorepeat((($"
code ENDS
end start
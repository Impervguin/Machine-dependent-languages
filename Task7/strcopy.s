.global copystrasm

//; rdi - dest
//; rsi - source
//; rdx - size
copystrasm: 
    
    movq %rdi, %rbx
    movq %rdx, %rcx
    cmp %rsi, %rdi
    //; Dst перед Src
    jle copy 

    movq %rdi, %rax
    subq %rsi, %rax

    
    cmp %rcx, %rax
    //; Dst после Src, но разница больше длины копирования, поэтому src не дойдет до dst
    jg copy 

    //; Иначе идем с конца
    add %rcx, %rdi
    add %rcx, %rsi
    dec %rdi
    dec %rsi
    //; Меняем флаг направления df
    std 
    
    copy: 
    rep movsb
    //; Сбрасываем направление
    cld 

    movb $0, (%rbx, %rdx)
    quit:
    ret

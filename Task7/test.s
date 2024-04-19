.global testint

testint:
    pushq %rbp
    movl %esp, %ebp
    
    movl %edi, %eax

    popq %rbp
    ret

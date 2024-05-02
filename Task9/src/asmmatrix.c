#include <stddef.h>
#include <stdio.h>
#include "asmmatrix.h"


void AsmMatrixMul(size_t rows1, size_t cols1, int mat1[rows1][cols1], size_t rows2, size_t cols2, int mat2[rows2][cols2], size_t rows3, size_t cols3, int mat3[rows3][cols3])
{
    if (rows3 != rows1 || cols3 != cols2 || cols1 != rows2) {
        return;
    }
    int mat1ptr = 0;
    int mat2ptr = 0;
    int mat3ptr = 0;
    asm volatile (
        "movq %0, %%rcx                              \n\t"
        "rowcycle:                                  \n\t"
        "    pushq %%rcx                            \n\t"
        "    movq %3, %%rcx                         \n\t"
        "    movl $0, %8                             \n\t"
        "    colcycle:                              \n\t"
        "        xorq %%rax, %%rax                  \n\t"
        "        pushq %%rcx                        \n\t"
        "        movq %1, %%rcx                     \n\t"
        "        push %7                            \n\t"
        "        push %8                            \n\t"
        "        sumcycle:                          \n\t"
        "            pushq %%rax                    \n\t"
        "            movl %7, %%eax                  \n\t"
        "            movl (%%rbx, %%rax, 0x4), %%edx \n\t"
        "            movl %8, %%eax                  \n\t"
        "            movl (%%rsi, %%rax, 0x4), %%eax \n\t"
        "            imull %%eax, %%edx              \n\t"
        "            popq %%rax                     \n\t"
        "            addl %%edx, %%eax               \n\t"

        "            incl %7                         \n\t"
        "            pushq %%rax                    \n\t"
        "            movq %3, %%rax                  \n\t"
        "            addl %%eax, %8                  \n\t"
        "            popq %%rax                     \n\t"
        "            loop sumcycle                  \n\t"
        "        movl %9, %%ecx                      \n\t"
        "        movl %%eax, (%%rdi, %%rcx, 0x4)     \n\t"
        "        pop %8                             \n\t"
        "        pop %7                             \n\t"
        "        incl %9                             \n\t"
        "        incl %8                             \n\t"
        "        popq %%rcx                         \n\t"
        "        loop colcycle                      \n\t"
        "    movq %1, %%rax                          \n\t"
        "    addl %%eax, %7                          \n\t"
        "    popq %%rcx                             \n\t"
        "    loop rowcycle                          \n\t"
        :
        :"m" (rows1), "m" (cols1), "m" (rows2), "m" (cols2), "b" (mat1), "S" (mat2), "D" (mat3), "m" (mat1ptr), "m" (mat2ptr), "m" (mat3ptr)
    );
}

void SseMatrixMul(size_t rows1, size_t cols1, int mat1[rows1][cols1], size_t rows2, size_t cols2, int mat2[rows2][cols2], size_t rows3, size_t cols3, int mat3[rows3][cols3])
{
    if (rows3 != rows1 || cols3 != cols2 || cols1 != rows2) {
        return;
    }
    int transmat2[cols2][rows2];
    for (size_t i = 0; i < cols2; i++) {
        for (size_t j = 0; j < rows2; j++) {
            transmat2[i][j] = mat2[j][i];
        }
    }
    int mat1ptr = 0;
    int mat2ptr = 0;
    int mat3ptr = 0;
    asm volatile (
        "movq %0, %%rcx                                  \n\t"
        "rowcyclea:                                     \n\t"
        "    pushq %%rcx                                \n\t"
        "    movq %2, %%rcx                             \n\t"
        "    movl $0, %8                                 \n\t"
        "    colcyclea:                                 \n\t"
        "        xorq %%rax, %%rax                      \n\t"
        "        pushq %%rcx                            \n\t"
        "        movq %1, %%rcx                         \n\t"
        "        push %7                                \n\t"
        "        push %8                                \n\t"
        "        cmpq $0x4, %%rcx                       \n\t"
        "        jl leftover                            \n\t"
        "        sumcyclea:                             \n\t"
        "            pushq %%rax                        \n\t"
        "            movl %7, %%eax                      \n\t"
        "            movdqu (%%rbx, %%rax, 0x4), %%xmm0 \n\t"
        "            movl %8, %%eax                      \n\t"
        "            movdqu (%%rsi, %%rax, 0x4), %%xmm1 \n\t"
        "            popq %%rax                         \n\t"
        "            pmullw %%xmm1, %%xmm0              \n\t"
        "            phaddd %%xmm0, %%xmm0              \n\t"
        "            phaddd %%xmm0, %%xmm0              \n\t"
        "            movd %%xmm0, %%edx                 \n\t"
        "            addl %%edx, %%eax                   \n\t"
                     
        "            pushq %%rax                        \n\t"
        "            movl $0x4, %%eax                    \n\t"
        "            addl %%eax, %7                      \n\t"
        "            addl %%eax, %8                      \n\t"
        "            popq %%rax                         \n\t"
        "            subl $0x4, %%ecx                    \n\t"
        "            cmpq $0x4, %%rcx                   \n\t"
        "            jge sumcyclea                      \n\t"
        "            cmpq $0x0, %%rcx                   \n\t"
        "            je aftersum                        \n\t"
        "        leftover:                              \n\t"
        "            pushq %%rax                        \n\t"
        "            mov %7, %%eax                      \n\t"
        "            mov (%%rbx, %%rax, 0x4), %%edx     \n\t"
        "            mov %8, %%eax                      \n\t"
        "            mov (%%rsi, %%rax, 0x4), %%eax     \n\t"
        "            imull %%eax, %%edx                  \n\t"
        "            popq %%rax                         \n\t"
        "            addl %%edx, %%eax                   \n\t"

        "            incl %7                             \n\t"
        "            incl %8                             \n\t"
        "        loop leftover                          \n\t"
        "        aftersum:                              \n\t"
        "        movl %9, %%ecx                          \n\t"
        "        movl %%eax, (%%rdi, %%rcx, 0x4)         \n\t"
        "        pop %8                                 \n\t"
        "        pop %7                                 \n\t"
        "        incl %9                                 \n\t"
        "        movq %3, %%rax                          \n\t"
        "        addl %%eax, %8                          \n\t"
        "        popq %%rcx                             \n\t"
        // "        loop colcyclea                         \n\t"
        "        dec %%rcx                              \n\t"
        "        cmpq $0x0, %%rcx                       \n\t"
        "        jne colcyclea                          \n\t"
        "    movq %1, %%rax                              \n\t"
        "    addl %%eax, %7                              \n\t"
        "    popq %%rcx                                 \n\t"
        // "    loop rowcyclea                             \n\t"
        "        decq %%rcx                              \n\t"
        "        cmpq $0x0, %%rcx                       \n\t"
        "        jne rowcyclea                          \n\t"
        :
        :"m" (rows1), "m" (cols1), "m" (cols2), "m" (rows2), "b" (mat1), "S" (transmat2), "D" (mat3), "m" (mat1ptr), "m" (mat2ptr), "m" (mat3ptr)
        : "xmm0", "xmm1"
    );
}

void CMatrixMul(size_t rows1, size_t cols1, int mat1[rows1][cols1], size_t rows2, size_t cols2, int mat2[rows2][cols2], size_t rows3, size_t cols3, int mat3[rows3][cols3])
{
    if (rows3 != rows1 || cols3 != cols2 || cols1 != rows2) {
        printf("1\n");
        return;
    }
    for (size_t i = 0; i < rows3; i++) {
        for (size_t j = 0; j < cols3; j++) {
            int sum = 0;
            for (size_t k = 0; k < cols1; k++) {
                sum += mat1[i][k] * mat2[k][j];
            }
            mat3[i][j] = sum;
        }
    }
}


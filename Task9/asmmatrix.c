#include <stddef.h>
#include <stdio.h>

void AsmMatrixMul(size_t rows1, size_t cols1, int mat1[rows1][cols1], size_t rows2, size_t cols2, int mat2[rows2][cols2], size_t rows3, size_t cols3, int mat3[rows3][cols3])
{
    if (rows3 != rows1 || cols3 != cols2 || cols1 != rows2) {
        return;
    }
    int mat1ptr = 0;
    int mat2ptr = 0;
    int mat3ptr = 0;
    asm volatile (
        "mov %0, %%rcx                              \n\t"
        "rowcycle:                                  \n\t"
        "    pushq %%rcx                            \n\t"
        "    movq %3, %%rcx                         \n\t"
        "    mov $0, %8                             \n\t"
        "    colcycle:                              \n\t"
        "        xorq %%rax, %%rax                  \n\t"
        "        pushq %%rcx                        \n\t"
        "        movq %1, %%rcx                     \n\t"
        "        push %7                            \n\t"
        "        push %8                            \n\t"
        "        sumcycle:                          \n\t"
        "            pushq %%rax                    \n\t"
        "            mov %7, %%eax                  \n\t"
        "            mov (%%rbx, %%rax, 0x4), %%edx \n\t"
        "            mov %8, %%eax                  \n\t"
        "            mov (%%rsi, %%rax, 0x4), %%eax \n\t"
        "            imul %%eax, %%edx              \n\t"
        "            popq %%rax                     \n\t"
        "            add %%edx, %%eax               \n\t"

        "            inc %7                         \n\t"
        "            pushq %%rax                    \n\t"
        "            mov %3, %%eax                  \n\t"
        "            add %%eax, %8                  \n\t"
        "            popq %%rax                     \n\t"
        "            loop sumcycle                  \n\t"
        "        mov %9, %%ecx                      \n\t"
        "        mov %%eax, (%%rdi, %%rcx, 0x4)     \n\t"
        "        pop %8                             \n\t"
        "        pop %7                             \n\t"
        "        inc %9                             \n\t"
        "        inc %8                             \n\t"
        "        popq %%rcx                         \n\t"
        "        loop colcycle                      \n\t"
        "    mov %1, %%eax                          \n\t"
        "    add %%eax, %7                          \n\t"
        "    popq %%rcx                             \n\t"
        "    loop rowcycle                          \n\t"
        :
        :"m" (rows1), "m" (cols1), "m" (rows2), "m" (cols2), "b" (mat1), "S" (mat2), "D" (mat3), "m" (mat1ptr), "m" (mat2ptr), "m" (mat3ptr)
    );
    // printf("%p\n", mat1);
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
        "mov %0, %%rcx \n\t"
        "rowcyclea:\n\t"
        "    pushq %%rcx\n\t"
        "    movq %2, %%rcx\n\t"
        "    mov $0, %8\n\t"
        "    colcyclea:\n\t"
        "        xorq %%rax, %%rax\n\t"
        "        pushq %%rcx\n\t"
        "        movq %1, %%rcx\n\t"
        "        push %7\n\t"
        "        push %8\n\t"
        "        cmpq $0x4, %%rcx\n\t"
        "        jl leftover\n\t"
        "        sumcyclea:\n\t"
        "            pushq %%rax                    \n\t"
        "            mov %7, %%eax\n\t"
        "            movdqu (%%rbx, %%rax, 0x4), %%xmm0\n\t"
        "            mov %8, %%eax\n\t"
        "            movdqu (%%rsi, %%rax, 0x4), %%xmm1\n\t"
        "            popq %%rax\n\t"
        "            pmullw %%xmm1, %%xmm0 \n\t"
        "            phaddd %%xmm0, %%xmm0 \n\t"
        "            phaddd %%xmm0, %%xmm0 \n\t"
        "            movd %%xmm0, %%edx \n\t"
        "            add %%edx, %%eax\n\t"
                     
        "            pushq %%rax                    \n\t"
        "            mov $0x4, %%eax \n\t"
        "            add %%eax, %7\n\t"
        "            add %%eax, %8\n\t"
        "            popq %%rax \n\t"
        "            sub $0x4, %%ecx \n\t"
        // "            cmpq $0x4, %%rcx                 \n\t"
        // "            jg sumcyclea\n\t"
        // "            cmpq $0x0, %%rcx \n\t"
        // "            je aftersum \n\t"
        "        leftover: \n\t"
        "            pushq %%rax                    \n\t"
        "            mov %7, %%eax                  \n\t"
        "            mov (%%rbx, %%rax, 0x4), %%edx \n\t"
        "            mov %8, %%eax                  \n\t"
        "            mov (%%rsi, %%rax, 0x4), %%eax \n\t"
        "            imul %%eax, %%edx              \n\t"
        "            popq %%rax                     \n\t"
        "            add %%edx, %%eax               \n\t"

        "            inc %7                         \n\t"
        "            inc %8                         \n\t"
        // "            inc %%eax \n\t"
        "        loop leftover \n\t"
        "        aftersum: \n\t"
        "        mov %9, %%ecx\n\t"
        "        mov %%eax, (%%rdi, %%rcx, 0x4)\n\t"
        "        pop %8\n\t"
        "        pop %7\n\t"
        "        inc %9\n\t"
        "        mov %3, %%eax  \n\t"
        "        add %%eax, %8\n\t"
        "        popq %%rcx\n\t"
        // "        loop colcyclea\n\t"
        "        dec %%rcx\n\t"
        "        cmpq $0x0, %%rcx \n\t"
        "        jne colcyclea\n\t"
        "    mov %1, %%eax\n\t"
        "    add %%eax, %7\n\t"
        "    popq %%rcx\n\t"
        // "    loop rowcyclea\n\t"
        "        dec %%rcx\n\t"
        "        cmpq $0x0, %%rcx \n\t"
        "        jne rowcyclea\n\t"
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

int main() {
    int mat1[3][2] = {{1, 52}, {43, 4}, {5, 6}};
    int mat2[2][5] = {{42, 15, -2, 52, 6}, {-3, -4, 2, 6, 1}};

    int rcmat[3][5];
    CMatrixMul(3, 2, mat1, 2, 5, mat2, 3, 5, rcmat);
    for (size_t i = 0; i < 3; i++) {
        for (size_t j = 0; j < 5; j++) {
            printf("%d ", rcmat[i][j]);
        }
        printf("\n");
    }
    printf("\n");
    int rasmmat[3][5];
    SseMatrixMul(3, 2, mat1, 2, 5, mat2, 3, 5, rasmmat);
    for (size_t i = 0; i < 3; i++) {
        for (size_t j = 0; j < 5; j++) {
            printf("%d ", rasmmat[i][j]);
        }
        printf("\n");
    }

    // int mat[5][5] = {{1, 2, 3, 4, 5}, {6, 7, 8, 9 ,10}, {11, 12 ,13, 14, 15}, {16, 17, 18, 19, 20}, {21, 22, 23, 24, 25}};
    // int mat1[5][5] = {{0, 0, 0, 0, 0}, {0, 0, 0, 0, 0}, {0, 0, 0, 0, 0}, {0, 0, 0, 0, 0}, {0, 0, 0, 0, 0}};
    // SseMatrixMul(5, 5, mat, 5, 5, mat, 5, 5, mat1);
    // for (size_t i = 0; i < 5; i++) {
    //     for (size_t j = 0; j < 5; j++) {
    //         printf("%d ", mat1[i][j]);
    //     }
    //     printf("\n");
    // }
    // return 0;
}


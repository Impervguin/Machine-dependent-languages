#include "asmmatrix.h"
#include "testutility.h"
#include <stdio.h>


int main(void) {
    size_t rows1, cols1, rows2, cols2;
    printf("Введите размеры первой матрицы через пробел: ");
    scanf("%zu%zu", &rows1, &cols1);
    if (rows1 == 0 || cols1 == 0) {
        printf("Нужны не нулевые размеры матриц.\n");
        return 1;
    }
    printf("Введите размеры второй матрицы через пробел: ");
    scanf("%zu%zu", &rows2, &cols2);
    if (rows2 == 0 || cols2 == 0) {
        printf("Нужны не нулевые размеры матриц.\n");
        return 1;
    }
    if (cols1 != rows2) {
        printf("Количество столбцов 1-ой матрицы должны быть равны числу строк 2-ой.\n");
        return 2;
    }
    int mat1[rows1][cols1];
    int mat2[rows2][cols2];
    int matC[rows1][cols2];
    int matAsm[rows1][cols2];
    int matSse[rows1][cols2];
    for (size_t i = 0; i < rows1; i++) {
        printf("Введите %zu-ю строку матрицы 1(элементы через пробел): ", i);
        for (size_t j = 0; j < cols1; j++) {
            scanf("%d", &mat1[i][j]);
        }
    }
    for (size_t i = 0; i < rows2; i++) {
        printf("Введите %zu-ю строку матрицы 2(элементы через пробел): ", i);
        for (size_t j = 0; j < cols2; j++) {
            scanf("%d", &mat2[i][j]);
        }
    }

    CMatrixMul(rows1, cols1, mat1, rows2, cols2, mat2, rows1, cols2, matC);
    AsmMatrixMul(rows1, cols1, mat1, rows2, cols2, mat2, rows1, cols2, matAsm);
    SseMatrixMul(rows1, cols1, mat1, rows2, cols2, mat2, rows1, cols2, matSse);

    printf("\n");
    printf("Результат умножения на Си:\n");
    for (size_t i = 0; i < rows1; i++) {
        for (size_t j = 0; j < cols2; j++) {
            printf("%d ", matC[i][j]);
        }
        printf("\n");
    }
    printf("\n");

    printf("Результат умножения на asm:\n");
    for (size_t i = 0; i < rows1; i++) {
        for (size_t j = 0; j < cols2; j++) {
            printf("%d ", matAsm[i][j]);
        }
        printf("\n");
    }
    printf("\n");

    printf("Результат умножения на sse:\n");
    for (size_t i = 0; i < rows1; i++) {
        for (size_t j = 0; j < cols2; j++) {
            printf("%d ", matSse[i][j]);
        }
        printf("\n");
    }
    printf("\n");

    return 0;
}
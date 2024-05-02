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

    size_t repeats;
    printf("Введите количество повторений: ");
    scanf("%zu", &repeats);
    if (repeats == 0) {
        printf("Неккоректное число повторений.");
    }

    double tC = TestMatMult(CMatrixMul, rows1, cols1, rows2, cols2, 10, rows1 + rows2 + cols1 + cols2);
    printf("Среднее время вычисления умножения на C: %lf\n", tC);
    double tAsm = TestMatMult(AsmMatrixMul, rows1, cols1, rows2, cols2, 10, rows1 + rows2 + cols1 + cols2);
    printf("Среднее время вычисления умножения на Asm: %lf\n", tAsm);
    double tSse = TestMatMult(SseMatrixMul, rows1, cols1, rows2, cols2, 10, rows1 + rows2 + cols1 + cols2);
    printf("Среднее время вычисления умножения на Asm с Sse: %lf\n", tSse);
    return 0;
}
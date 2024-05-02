#include "testutility.h"

void FillRandomMatrix(size_t rows, size_t cols, int mat[rows][cols], int seed)
{
    srand(seed);
    for (size_t i = 0; i < rows; i++) {
        for (size_t j = 0; j < cols; j++) {
            mat[i][j] = rand() / 10000;
        }
    }
}

double TestMatMult(matmult_t func, size_t rows1, size_t cols1, size_t rows2, size_t cols2, size_t repeats, int seed) {
    double result = 0;
    
    int mat1[rows1][cols1];
    int mat2[rows2][cols2];
    int mat3[rows1][cols2];

    
    
    for (size_t i = 0; i < repeats; ++i)
    {
        FillRandomMatrix(rows1, cols1, mat1, seed);
        FillRandomMatrix(rows2, cols2, mat2, seed);
        clock_t start = clock();
        func(rows1, cols1, mat1, rows2, cols2, mat2, rows1, cols2, mat3);
        clock_t end = clock();
        result += (double) (end - start) / CLOCKS_PER_SEC;
    }

    return result / repeats;
}
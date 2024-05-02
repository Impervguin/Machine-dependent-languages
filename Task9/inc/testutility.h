#ifndef TESTUTILITY_H__
#define TESTUTILITY_H__

#include <stddef.h>
#include <time.h>
#include <stdlib.h>

typedef void (*matmult_t)(size_t rows1, size_t cols1, int[rows1][cols1], size_t  rows2, size_t cols2, int[rows2][cols2], size_t  rows3, size_t cols3, int[rows3][cols3]) ;

void FillRandomMatrix(size_t rows, size_t cols, int mat[rows][cols], int seed);
double TestMatMult(matmult_t func, size_t rows1, size_t cols1, size_t rows2, size_t cols2, size_t repeats, int seed);





#endif // TESTUTILITY_H__

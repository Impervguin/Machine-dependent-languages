#ifndef ASMMATRIX_H__
#define ASMMATRIX_H__

#include <stddef.h>

void AsmMatrixMul(size_t rows1, size_t cols1, int mat1[rows1][cols1], size_t rows2, size_t cols2, int mat2[rows2][cols2], size_t rows3, size_t cols3, int mat3[rows3][cols3]);
void SseMatrixMul(size_t rows1, size_t cols1, int mat1[rows1][cols1], size_t rows2, size_t cols2, int mat2[rows2][cols2], size_t rows3, size_t cols3, int mat3[rows3][cols3]);
void CMatrixMul(size_t rows1, size_t cols1, int mat1[rows1][cols1], size_t rows2, size_t cols2, int mat2[rows2][cols2], size_t rows3, size_t cols3, int mat3[rows3][cols3]);


#endif // ASMMATRIX_H__

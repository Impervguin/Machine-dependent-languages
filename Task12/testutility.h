#ifndef TESTUTILITY_H__
#define TESTUTILITY_H__

#include <stddef.h>
#include <time.h>
#include <stdlib.h>

typedef void (*arradd_t)(int *arr1, int *arr2, int size) ;

void FillRandomArray(int size, int arr[size], int seed);
double TestArrAdd(arradd_t func, int size, int repeats, int seed);


#endif // TESTUTILITY_H__

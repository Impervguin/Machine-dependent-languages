#include "testutility.h"

void FillRandomArray(int size, int arr[size], int seed)
{
    srand(seed);
    for (int i = 0; i < size; i++) {
            arr[i] = rand() / 10000;
    }
}

double TestArrAdd(arradd_t func, int size, int repeats, int seed) {
    double result = 0;
    int arr1[size];
    int arr2[size];
    
    for (int i = 0; i < repeats; ++i)
    {
        FillRandomArray(size, arr1, seed);
        FillRandomArray(size, arr2, seed);
        clock_t start = clock();
        func(arr1, arr2, size);
        clock_t end = clock();
        result += (double) (end - start) / CLOCKS_PER_SEC;
    }

    return result / repeats;
}
#include <time.h>
#include "functime.h"

double GetFloatFuncTime(float a, float b, float (*func)(float, float), size_t repeats)
{
    clock_t start = clock();
    
    for (size_t i = 0; i < repeats; ++i)
        func(a, b);

    clock_t end = clock();

    return (double) (end - start) / CLOCKS_PER_SEC / repeats;
}

double GetDoubleFuncTime(double a, double b, double (*func)(double, double), size_t repeats)
{
    clock_t start = clock();
    
    for (size_t i = 0; i < repeats; ++i)
        func(a, b);

    clock_t end = clock();

    return (double) (end - start) / CLOCKS_PER_SEC / repeats;
}
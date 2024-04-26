#ifndef TIME_H__
#define TIME_H__

#include <cstdlib>

double GetFloatFuncTime(float a, float b, float (*func)(float, float), size_t repeats);
double GetDoubleFuncTime(double a, double b, double (*func)(double, double), size_t repeats);

#endif // TIME_H__

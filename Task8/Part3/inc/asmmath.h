#ifndef ASMMATH_H__
#define ASMMATH_H__

#include <cstdlib>

double sinfunc(double x);
double hord(double (*func)(double), double a, double b, size_t iters, double y);

#endif // ASMMATH_H__

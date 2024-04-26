#include "asmmath.h"


double sin(double x) {
    double result;
    asm volatile ("fldl %1\n\t"
                  "fsin\n\t"
                  "fstpl %0"
                  : "=m" (result)
                  : "g" (x)
    );
    return result;
}

double pi() {
    double result;
    asm volatile ("fldpi\n\t"
                  "fstpl %0"
                  : "=m" (result)
    );
    return result;
}
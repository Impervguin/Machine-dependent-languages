#include <iostream>
double DoubleAsmMult(double x, double y) {
    double result;
    asm volatile ("fldl %1\n\t"
                  "fmull %2\n\t"
                  "fstpl %0\n\t"
                  : "=m" (result)
                  : "g" (x), "g" (y)
    );
    return result;
}

float FloatAsmMult(float x, float y) {
    float result;
    asm volatile ("flds %1\n\t"
                  "fmuls %2\n\t"
                  "fstps %0\n\t"
                  : "=m" (result)
                  : "g" (x), "g" (y)
    );
    return result;
}

double DoubleAsmAdd(double x, double y) {
    double result;
    asm volatile ("fldl %1\n\t"
                  "faddl %2\n\t"
                  "fstpl %0\n\t"
                  : "=m" (result)
                  : "g" (x), "g" (y)
    );
    return result;
}

float FloatAsmAdd(float x, float y) {
    float result;
    asm volatile ("flds %1\n\t"
                  "fadds %2\n\t"
                  "fstps %0\n\t"
                  : "=m" (result)
                  : "g" (x), "g" (y)
    );
    return result;
}

// int main(void) {
//     double x = 1.0;
//     double y = 2.0;
//     std::cout << DoubleAsmMult(x, y) << std::endl;
//     x=  1.5325;
//     y = -7.214;
//     std::cout << DoubleAsmMult(x, y) << std::endl;
//     x = 0;
//     y = 1241532;
//     std::cout << DoubleAsmMult(x, y) << std::endl;

//     x = 1.0;
//     y = 2.0;
//     std::cout << DoubleAsmAdd(x, y) << std::endl;
//     x=  1.5325;
//     y = -7.214;
//     std::cout << DoubleAsmAdd(x, y) << std::endl;
//     x = 0;
//     y = 1241532;
//     std::cout << DoubleAsmAdd(x, y) << std::endl;

//     float xf = 1.0;
//     float yf = 2.0;
//     std::cout << FloatAsmMult(xf, yf) << std::endl;
//     xf =  1.5325;
//     yf = -7.214;
//     std::cout << FloatAsmMult(xf, yf) << std::endl;
//     xf = 0;
//     yf = 1241532;
//     std::cout << FloatAsmMult(xf, yf) << std::endl;

//     xf = 1.0;
//     yf = 2.0;
//     std::cout << FloatAsmAdd(xf, yf) << std::endl;
//     xf =  1.5325;
//     yf = -7.214;
//     std::cout << FloatAsmAdd(xf, yf) << std::endl;
//     xf = 0;
//     yf = 1241532;
//     std::cout << FloatAsmAdd(xf, yf) << std::endl;
// }

#include <iostream>

double DoubleCMult(double x, double y) {
    double result = x * y;
    return result;
}

float FloatCMult(float x, float y) {
    float result = x * y;
    return result;
}

double DoubleCAdd(double x, double y) {
    double result = x + y;
    return result;
}

float FloatCAdd(float x, float y) {
    float result = x + y;
    return result;
}


// int main(void) {
//     double x = 1.0;
//     double y = 2.0;
//     std::cout << DoubleCMult(x, y) << std::endl;
//     x=  1.5325;
//     y = -7.214;
//     std::cout << DoubleCMult(x, y) << std::endl;
//     x = 0;
//     y = 1241532;
//     std::cout << DoubleCMult(x, y) << std::endl;

//     x = 1.0;
//     y = 2.0;
//     std::cout << DoubleCAdd(x, y) << std::endl;
//     x=  1.5325;
//     y = -7.214;
//     std::cout << DoubleCAdd(x, y) << std::endl;
//     x = 0;
//     y = 1241532;
//     std::cout << DoubleCAdd(x, y) << std::endl;

//     float xf = 1.0;
//     float yf = 2.0;
//     std::cout << FloatCMult(xf, yf) << std::endl;
//     xf =  1.5325;
//     yf = -7.214;
//     std::cout << FloatCMult(xf, yf) << std::endl;
//     xf = 0;
//     yf = 1241532;
//     std::cout << FloatCMult(xf, yf) << std::endl;

//     xf = 1.0;
//     yf = 2.0;
//     std::cout << FloatCAdd(xf, yf) << std::endl;
//     xf =  1.5325;
//     yf = -7.214;
//     std::cout << FloatCAdd(xf, yf) << std::endl;
//     xf = 0;
//     yf = 1241532;
//     std::cout << FloatCAdd(xf, yf) << std::endl;
// }
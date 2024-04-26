#include <iostream>
#include "asmfunc.h"
#include "cfunc.h"
#include "functime.h"

#ifndef REPEATS
#error "Repeats must be defined"alignas
#endif

#define GREEN "\033[32m"
#define CYAN "\033[36m"
#define RESET "\033[0m"
#define DELIMITER "------------------------------------------------------"


int main(void) {
    double a = 1905072.18;
    double b = -11602.64;
    std::cout << CYAN << "Double multiply test: " << a << " * " << b << RESET << std::endl;
    std::cout << CYAN << "Repeat count: " << RESET << REPEATS << std::endl;
    std::cout << GREEN << "C multiply: " << RESET << GetDoubleFuncTime(a, b, DoubleCMult, REPEATS) << std::endl;
    std::cout << GREEN << "Asm multiply: " << RESET << GetDoubleFuncTime(a, b, DoubleAsmMult, REPEATS) << std::endl;

    std::cout << DELIMITER << std::endl;

    std::cout << CYAN << "Double add test: " << a << " + " << b << RESET << std::endl;
    std::cout << CYAN << "Repeat count: " << RESET << REPEATS << std::endl;
    std::cout << GREEN << "C add: " << RESET << GetDoubleFuncTime(a, b, DoubleCAdd, REPEATS) << std::endl;
    std::cout << GREEN << "Asm add: " << RESET << GetDoubleFuncTime(a, b, DoubleCAdd, REPEATS) << std::endl;

    std::cout << DELIMITER << std::endl;

    double af = 1905072.18;
    double bf = -11602.64;
    std::cout << CYAN << "Float multiply test: " << af << " * " << bf << RESET << std::endl;
    std::cout << CYAN << "Repeat count: " << RESET << REPEATS << std::endl;
    std::cout << GREEN << "C multiply: " << RESET << GetFloatFuncTime(af, bf, FloatCMult, REPEATS) << std::endl;
    std::cout << GREEN << "Asm multiply: " << RESET << GetFloatFuncTime(af, bf, FloatAsmMult, REPEATS) << std::endl;

    std::cout << DELIMITER << std::endl;

    std::cout << CYAN << "Float add test: " << af << " + " << bf << RESET << std::endl;
    std::cout << CYAN << "Repeat count: " << RESET << REPEATS << std::endl;
    std::cout << GREEN << "C add: " << RESET << GetFloatFuncTime(af, bf, FloatCAdd, REPEATS) << std::endl;
    std::cout << GREEN << "Asm add: " << RESET << GetFloatFuncTime(af, bf, FloatAsmAdd, REPEATS) << std::endl;

    std::cout <<std::endl;

    return 0;
}




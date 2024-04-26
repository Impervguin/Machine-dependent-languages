#include <iostream>
#include <iomanip>
#include <cstdio>
#include "asmmath.h"


#define PI2 3.14
#define PI6 3.141596
#define PRINT_PRECISION 20

#define GREEN "\033[32m"
#define CYAN "\033[36m"
#define RESET "\033[0m"
#define DELIMITER "------------------------------------------------------"

int main() {
    std::cout << CYAN << "PI VALUES" << RESET << std::endl;
    std::cout << GREEN << "Pi 2 decimals precision: " << RESET << std::setprecision(PRINT_PRECISION) << PI2 << std::endl;
    std::cout << GREEN << "Pi 6 decimals precision: " << RESET << std::setprecision(PRINT_PRECISION) << PI6 << std::endl;
    std::cout << GREEN << "Assembly FPU pi: " << RESET << std::setprecision(PRINT_PRECISION) << pi() << std::endl;

    std::cout << DELIMITER << std::endl;

    std::cout << CYAN << "ASSEMBLY SIN WITH (PI / 2)" << RESET << std::endl;
    std::cout << GREEN << "sin(PI2 / 2): " << RESET << std::setprecision(PRINT_PRECISION) << sin(PI2 / 2) << std::endl;
    std::cout << GREEN << "sin(PI6 / 2): " << RESET << std::setprecision(PRINT_PRECISION) << sin(PI6 / 2) << std::endl;
    std::cout << GREEN << "sin(pi() / 2): " << RESET << std::setprecision(PRINT_PRECISION) << sin(pi() / 2) << std::endl;
    
    std::cout << DELIMITER << std::endl;

    std::cout << CYAN << "ASSEMBLY SIN WITH (PI)" << RESET << std::endl;
    std::cout << GREEN << "sin(PI2): " << RESET << std::setprecision(PRINT_PRECISION) << sin(PI2) << std::endl;
    std::cout << GREEN << "sin(PI6): " << RESET << std::setprecision(PRINT_PRECISION) << sin(PI6) << std::endl;
    std::cout << GREEN << "sin(pi()): " << RESET << std::setprecision(PRINT_PRECISION) << sin(pi()) << std::endl;
    return 0;
}


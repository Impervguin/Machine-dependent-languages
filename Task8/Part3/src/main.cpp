#include <iostream>
#include <iomanip>
#include <cstdio>
#include "asmmath.h"

#define GREEN "\033[32m"
#define CYAN "\033[36m"
#define RESET "\033[0m"
#define DELIMITER "------------------------------------------------------"

int main() {
    std::cout << CYAN << "Метод хорд для функции f(x) = 2sin(x^2 - 5)" << RESET << std::endl;
    std::cout << DELIMITER << std::endl;
    
    std::cout << CYAN << "Тест 1" << RESET << std::endl;
    double a = 0.5, b = 1.5;
    double y = 1;
    size_t iters = 10;
    std::cout << GREEN << "Начальные границы: [" << a << "," << b << "]. " << "Число итераций: " << iters << "." << " Искомый y = " << y << "." << RESET << std::endl;
    double resx = hord(sinfunc, a, b, iters, y);
    std::cout << GREEN << "Найденный x: " << RESET << resx << ". " << GREEN << "f(" << RESET << resx << GREEN << ") = " << RESET << sinfunc(resx) << GREEN << "." << RESET << std::endl;

    std::cout << DELIMITER << std::endl;

    std::cout << CYAN << "Тест 2" << RESET << std::endl;
    a = 0.2, b = 0.8;
    y = 2;
    iters = 20;
    std::cout << GREEN << "Начальные границы: [" << a << "," << b << "]. " << "Число итераций: " << iters << "." << " Искомый y = " << y << "." << RESET << std::endl;
    resx = hord(sinfunc, a, b, iters, y);
    std::cout << GREEN << "Найденный x: " << RESET << resx << ". " << GREEN << "f(" << RESET << resx << GREEN << ") = " << RESET << sinfunc(resx) << GREEN << "." << RESET << std::endl;

    std::cout << CYAN << "Тест 3" << RESET << std::endl;
    a = -0.3, b = 0.2;
    y = 1.918;
    iters = 20;
    std::cout << GREEN << "Начальные границы: [" << a << "," << b << "]. " << "Число итераций: " << iters << "." << " Искомый y = " << y << "." << RESET << std::endl;
    resx = hord(sinfunc, a, b, iters, y);
    std::cout << GREEN << "Найденный x: " << RESET << resx << ". " << GREEN << "f(" << RESET << resx << GREEN << ") = " << RESET << sinfunc(resx) << GREEN << "." << RESET << std::endl;

    std::cout << CYAN << "Тест 4" << RESET << std::endl;
    a = -1.8, b = -0.8;
    y = 0;
    iters = 20;
    std::cout << GREEN << "Начальные границы: [" << a << "," << b << "]. " << "Число итераций: " << iters << "." << " Искомый y = " << y << "." << RESET << std::endl;
    resx = hord(sinfunc, a, b, iters, y);
    std::cout << GREEN << "Найденный x: " << RESET << resx << ". " << GREEN << "f(" << RESET << resx << GREEN << ") = " << RESET << sinfunc(resx) << GREEN << "." << RESET << std::endl;
}


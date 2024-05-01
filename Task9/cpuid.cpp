#include <iostream>


int main() {
    int tmp;
    asm volatile (
        "mov $1, %%eax \n\t"
        "cpuid          \n\t"
        "mov %%ecx, %0 \n\t"
        : "=r" (tmp)
    );
    std::cout << "SSE3: ";
    if (tmp & 1) {
        std::cout << "Yes!" << std::endl;
    } else {
        std::cout << "No(" << std::endl;
    }

    std::cout << "PCLMULQDQ: ";
    if (tmp & 2) {
        std::cout << "Yes!" << std::endl;
    } else {
        std::cout << "No(" << std::endl;
    }

    std::cout << "SSSE3: ";
    if (tmp & 0b1000000000) {
        std::cout << "Yes!" << std::endl;
    } else {
        std::cout << "No(" << std::endl;
    }

    std::cout << "SSE4.1: ";
    if (tmp & 0b10000000000000000000) {
        std::cout << "Yes!" << std::endl;
    } else {
        std::cout << "No(" << std::endl;
    }

    std::cout << "SSE4.2: ";
    if (tmp & 0b100000000000000000000) {
        std::cout << "Yes!" << std::endl;
    } else {
        std::cout << "No(" << std::endl;
    }

    std::cout << "AVX: ";
    if (tmp & 0b10000000000000000000000000000) {
        std::cout << "Yes!" << std::endl;
    } else {
        std::cout << "No(" << std::endl;
    }

    return 0;
}
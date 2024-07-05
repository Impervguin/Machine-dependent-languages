#include "asmmath.h"
#include <iostream>

/// Не понимаю почему, но теперь при вызове функций параметры передаютс по регистрам sse - xmm1, xmm2...
double hord(double (*func)(double), double a, double b, size_t iters, double y) {
    double result;
    double tmp;
    // auto f = func;
    // nextx: Реализует формулу: xi+1 = xi - (b - xi) * (f(xi) - y) / (f(b) - f(xi))
    asm volatile (
                  "cmpq $0x00, %%rcx   \n\t"
                  "je end              \n\t"
                  "cycle:              \n\t" // Цикл по числу итераций
                  "    jmp nextx      \n\t" // Считаем следующее приближение x
                  "loopcycle:           \n\t"
                  "    loop cycle      \n\t"
                  "jmp end             \n\t" // После цикла в конец
                  "nextx:              \n\t"
                  "    movsd %1, %%xmm0 \n\t" // Передаем xi как аргумент
                  "    call *%6        \n\t" // В rax - f(xi)
                  "    movsd %%xmm0, %5  \n\t" // Перекидываем f(xi) в стек FPU через временную переменную
                  "    fldl %5         \n\t" // В текущем стеке (f(xi))
                  
                  "    movq %2, %%xmm0 \n\t" // Передаем b как аргумент
                  "    call *%6        \n\t" // В rax - f(b)
                  "    movq %%xmm0, %5  \n\t"
                  "    fldl %5         \n\t" // В текущем стеке (f(xi), f(b))
                  
                  "    fsubp           \n\t" // В текущем стеке (f(b) - f(xi))
                  
                  "    fldl %2         \n\t" // Кладем в стек b
                  "    fsubl %1        \n\t" // В текущем стеке (f(b) - f(xi), b - xi)
                  
                  "    movq %1, %%xmm0 \n\t" // Передаем xi как аргумент
                  "    call *%6        \n\t" // В rax - f(xi)
                  "    movq %%xmm0, %5  \n\t"
                  "    fldl %5         \n\t" // Помещаем f(xi) в стек
                  
                  "    fsubl %4        \n\t" // В текущем стеке (f(b) - f(xi), b - xi, f(xi) - y)
                  "    fmulp           \n\t" // В текущем стеке (f(b) - f(xi), (b - xi) * (f(xi) - y))
                  "    fdivp           \n\t" // В текущем стеке ((b - xi) * (f(xi) - y) / (f(b) - f(xi)))
                  "    fldl %1         \n\t" // Кладем в стек xi
                  "    fsubp           \n\t" // В текущем стеке (xi - (b - xi) * (f(xi) - y) / (f(b) - f(xi)))
                  "    fstpl %1        \n\t" // Записываем просчитанный xi+1 в xi
                  "    jmp loopcycle   \n\t"
                  "end:                \n\t"
                  "    fldl %1         \n\t" // Переносим через стек xi в result
                  "    fstpl %0        \n\t"
                  : "=m" (result)
                  : "m" (a), "m" (b), "c" (iters), "m" (y), "m" (tmp), "m" (func)
    );
    // std::cout << tmp_iters << std::endl;
    return result;
}

double chord(double (*f)(double), double x0, double x1, size_t iters, double y) {
    double x = x0;
    for (size_t i = 0; i < iters; i++) {
        x = x - ((f(x) - y) * (x1 - x) / (f(x1) - f(x)));
    }
    return x;
}

double sinfunc(double x) {
    // std::cout << x << std::endl;
    double result;
    asm volatile (
                  "movq $0x2, %0 \n\t"
                  "fildl %0 \n\t"
                  "movq $0x5, %0 \n\t"
                  "fildl %0 \n\t"
                //   "movsd %%xmm0, %1\n\t"
                  "fldl %1\n\t"
                  "fldl %1 \n\t"
                  "fmulp \n\t"
                  "fsubp \n\t"
                  "fsin \n\t"
                  "fmulp \n\t"
                  "fstpl %0 \n\t"
                  : "=m" (result)
                  : "m" (x)
    );
    // std::cout << result << std::endl;
    return result;
}


// int main() {
//     double a = 0.5, b = 1.5;
//     double y = 1;
//     size_t iters = 10;

//     double cx = chord(sinfunc, a, b, iters, y);
//     double ax = hord(sinfunc, a, b, iters, y);
//     std::cout << cx << std::endl;
//     std::cout << ax << std::endl;
//     return 0;
// }
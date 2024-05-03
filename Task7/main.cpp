#include <iostream>
#include <cstring>



#define GREEN "\033[32m"
#define Cyan "\033[36m"
#define RESET "\033[0m"


/**
 * Похоже, что gcc использует не cdecl, а fastcall, так как он передает параметры сначала по регистрам в таком порядке:
 * edi, esi, edx, ecx, r8d, r9d
 * А затем уже начинает класть в стек, при этом сначала более поздние аргументы
 */
extern "C" {
    void copystrasm(const char *dst, const char *src, size_t len);
    // int testint(int a, int b, int c, int d, int f, int g, int h, int k);
}

int strlenasm(const char *str) {
    int count;
    // asm volatile ("xorl %%ecx, %%ecx\n\t"
    //               "count:\n\t"
    //               "lodsb\n\t"
    //               "cmpb $0, %%al\n\t"
    //               "je end\n\t"
    //               "incl %%ecx\n\t"
    //               "jmp count\n\t"
    //               "end:"
    //               : "=c" (count)
    //               : "S" (str)
    //               : "%al"); // Не даёт писать ecx(rcx) edi, esi, видимо из-за того же fastcall

    asm volatile (
                  "movq $0xffffffffffffffff, %%rcx\t\n"
                  "movb $0, %%al\n\t"
                  "repne scasb\n\t"
                  "neg %%rcx\n\t"
                  "dec %%rcx\n\t"
                  : "=c" (count)
                  : "D" (str)
                  : "%al" // Не даёт писать ecx(rcx) edi, esi, видимо из-за того же fastcall
    );
    return count;
}

int main() {
    std::cout  << Cyan << "Length testing" << RESET << std::endl << std::endl;
    char lenstr1[] = "Hello, world!";
    std::cout << GREEN << "Test Length 1:" << RESET << std::endl;
    std::cout << "String: " << lenstr1 << std::endl;
    std::cout << "Expected length: " << strlen(lenstr1) << std::endl;
    std::cout << std::endl;

    char lenstr2[] = "a";
    std::cout << GREEN << "Test Length 2:" << RESET << std::endl;
    std::cout << "String: " << lenstr2 << std::endl;
    std::cout << "Expected length: " << strlen(lenstr2) << std::endl;
    std::cout << std::endl;

    char lenstr3[] = "";
    std::cout << GREEN << "Test Length 3:" << RESET << std::endl;
    std::cout << "String: " << lenstr3 << std::endl;
    std::cout << "Expected length: " << strlen(lenstr3) << std::endl;
    std::cout << std::endl;
    std::cout << Cyan << "-----------------------------------------------------------------" << RESET << std::endl;

    std::cout  << Cyan << "Copy testing" << RESET << std::endl << std::endl;
    std::cout << GREEN << "Test Copy 1:" << RESET << std::endl;
    
    char copystrsrc1[] = "Hello world!";
    char copystrdst1[strlen(copystrsrc1) + 1];
    size_t copylen1 = strlen(copystrsrc1);

    std::cout << "String: " << copystrsrc1 << std::endl;
    std::cout << "Copy length: " << copylen1 << std::endl;
    std::cout << "No intersection" << std::endl;
    
    copystrasm(copystrdst1, copystrsrc1, copylen1);
    std::cout << "Result: " << copystrdst1 << std::endl;
    std::cout << std::endl;

    std::cout << GREEN << "Test Copy 2:" << RESET << std::endl;
    
    char copystrsrc2[] = "Hello world!";
    size_t copylen2 = 5;
    char copystrdst2[copylen2 + 1];
    

    std::cout << "String: " << copystrsrc2 << std::endl;
    std::cout << "Copy length: " << copylen2 << std::endl;
    std::cout << "No intersection" << std::endl;

    copystrasm(copystrdst2, copystrsrc2, copylen2);
    std::cout << "Result: " << copystrdst2 << std::endl;
    std::cout << std::endl;


    std::cout << GREEN << "Test Copy 3:" << RESET << std::endl;
    
    char copystrdst3[30];
    char *copystrsrc3 = copystrdst3 + 5;
    strcpy(copystrsrc3, "Everybody lies!");
    size_t copylen3 = 13;
    
    std::cout << "String: " << copystrsrc3 << std::endl;
    std::cout << "Copy length: " << copylen3 << std::endl;
    std::cout << "Dest before src(src 5 bytes ahead)" << std::endl;

    copystrasm(copystrdst3, copystrsrc3, copylen3);
    std::cout << "Result: " << copystrdst3 << std::endl;
    std::cout << "Source(must be intersected by dst): " << copystrsrc3 << std::endl;
    std::cout << std::endl;

    std::cout << GREEN << "Test Copy 4:" << RESET << std::endl;
    
    char copystrsrc4[30] = "We need more tests!";
    char *copystrdst4 = copystrsrc4 + 10;
    // strcpy(copystrsrc3, "Everybody lies!");
    size_t copylen4 = 8;
    
    std::cout << "String: " << copystrsrc4 << std::endl;
    std::cout << "Copy length: " << copylen4 << std::endl;
    std::cout << "Src before dest(dest 10 bytes ahead)" << std::endl;

    copystrasm(copystrdst4, copystrsrc4, copylen4);
    std::cout << "Result: " << copystrdst4 << std::endl;
    std::cout << "Source(must be cutted by dst): " << copystrsrc4 << std::endl;
    std::cout << std::endl;

    std::cout << GREEN << "Test Copy 5:" << RESET << std::endl;
    
    char copystrsrc5[30] = "We need more tests!";
    char *copystrdst5 = copystrsrc5 + 10;
    // strcpy(copystrsrc3, "Everybody lies!");
    size_t copylen5 = 10;
    
    std::cout << "String: " << copystrsrc5 << std::endl;
    std::cout << "Copy length: " << copylen5 << std::endl;
    std::cout << "Src before dest(dest 10 bytes ahead)" << std::endl;

    copystrasm(copystrdst5, copystrsrc5, copylen5);
    std::cout << "Result: " << copystrdst5 << std::endl;
    std::cout << "Source(must be cutted by dst): " << copystrsrc5 << std::endl;
    std::cout << std::endl;

    std::cout << GREEN << "Test Copy 6:" << RESET << std::endl;
    
    char copystrsrc6[30] = "We need more tests!";
    char *copystrdst6 = copystrsrc6 + 10;
    // strcpy(copystrsrc3, "Everybody lies!");
    size_t copylen6 = strlen(copystrsrc6);
    
    std::cout << "String: " << copystrsrc6 << std::endl;
    std::cout << "Copy length: " << copylen6 << std::endl;
    std::cout << "Src before dest(dest 10 bytes ahead)" << std::endl;

    copystrasm(copystrdst6, copystrsrc6, copylen6);
    std::cout << "Result: " << copystrdst6 << std::endl;
    std::cout << "Source(must be cutted by dst): " << copystrsrc6 << std::endl;
    std::cout << std::endl;


    return 0;
}
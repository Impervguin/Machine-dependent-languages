#include <stdio.h>
#include <string.h>
#include "testutility.h"

int AsmStrlen(const char *str) {
    int count = 0;
    asm volatile (
        "mov x1, %1 \n\t"
        "mov w0, 0 \n\t"
        "cycle: \n\t"
        "    ldrb w2, [x1] \n\t"
        "    cmp w2, 0 \n\t"
        "    beq end \n\t"
        "    add x1, x1, 1 \n\t"
        "    add w0, w0, 1 \n\t"
        "    b cycle \n\t"
        "end: \n\t"
        "mov %0, x0 \n"
    : "=r" (count)
    : "r" (str)
    );
    return count;
}

void NeonArrSum(int *dest, int *src, int size) {
    asm volatile (
        "mov x0, %0   \n\t"
        "mov x1, %1   \n\t"
        "mov x2, %2   \n\t"
        "cmp x2, 0    \n\t"
        "beq endsum      \n\t"
        "cmp x2, 4    \n\t"
        "blt cycle1   \n\t"
        "cycle4:      \n\t"
        "    ldr q0, [x0] \n\t"
        "    ldr q1, [x1] \n\t"
        "    add v0.4s, v0.4s, v1.4s \n\t"
        "    str q0, [x0] \n\t"
        "    add x0, x0, 16\n\t"
        "    add x1, x1, 16\n\t"
        "    subs x2, x2, 4 \n\t"
        "    cmp x2, 0 \n\t"
        "    beq endsum \n\t"
        "    cmp x2, 4      \n\t"
        "    bge cycle4     \n\t"
        "cycle1: \n\t"
        "    ldr w3, [x0] \n\t"
        "    ldr w4, [x1] \n\t"
        "    add w3, w3, w4 \n\t"
        "    str w3, [x0] \n\t"
        "    add x0, x0, 4 \n\t"
        "    add x1, x1, 4 \n\t"
        "    subs x2, x2, 1 \n\t"
        "    cmp x2, 1      \n\t"
        "    bge cycle1     \n\t"
        "endsum: \n\t"
        : 
        : "r" (dest), "r" (src), "r" (size)
    );
}

void CArrSum(int *dest, int *src, int size) {
    for (int i = 0; i < size; i++) {
        dest[i] += src[i];
    }
}

#define GREEN "\033[32m"
#define CYAN "\033[36m"
#define RESET "\033[0m"

int main() {
    printf("%sLength testing %s\n", CYAN, RESET);
    char lenstr1[] = "Hello, world!";
    printf("%sTest Length 1: %s\n", GREEN, RESET);
    printf("String: %s\n", lenstr1);
    printf("Expected length: %d\n", strlen(lenstr1));
    printf("Got length: %d\n", AsmStrlen(lenstr1));
    printf("\n");

    char lenstr2[] = "a";
    printf("%sTest Length 2: %s\n", GREEN, RESET);
    printf("String: %s\n", lenstr2);
    printf("Expected length: %d\n", strlen(lenstr2));
    printf("Got length: %d\n", AsmStrlen(lenstr2));
    printf("\n");

    char lenstr3[] = "";
    printf("%sTest Length 3: %s\n", GREEN, RESET);
    printf("String: %s\n", lenstr3);
    printf("Expected length: %d\n", strlen(lenstr3));
    printf("Got length: %d\n", AsmStrlen(lenstr3));
    printf("\n");

    printf("%sArray adding testing %s\n", CYAN, RESET);

    int arrSize1 = 10;
    int arr1t1[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    int arr2t1[10] = {40, 39, 38, 37, 36, 35, 34, 33, 32, 31};
    printf("%sTest adding 1: %s\n", GREEN, RESET);
    printf("Array 1: ");
    for (int i = 0; i < arrSize1; i++) {
        printf("%d ", arr1t1[i]);
    }
    printf("\n");
    printf("Array 2: ");
    for (int i = 0; i < arrSize1; i++) {
        printf("%d ", arr2t1[i]);
    }
    printf("\n");
    int tmparrt1[10];
    for (int i = 0; i < arrSize1; i++) {
        tmparrt1[i] = arr1t1[i];
    }
    printf("\n");
    NeonArrSum(arr1t1, arr2t1, arrSize1);
    CArrSum(tmparrt1, arr2t1, arrSize1);
    printf("C add array: ");
    for (int i = 0; i < arrSize1; i++) {
        printf("%d ", tmparrt1[i]);
    }
    printf("\n");
    printf("Neon add array: ");
    for (int i = 0; i < arrSize1; i++) {
        printf("%d ", arr1t1[i]);
    }
    printf("\n");
    printf("\n");


    int arrSize2 = 3;
    int arr1t2[3] = {1004, 2310, 4123};
    int arr2t2[3] = {241, 1242, 31};
    printf("%sTest adding 2: %s\n", GREEN, RESET);
    printf("Array 1: ");
    for (int i = 0; i < arrSize2; i++) {
        printf("%d ", arr1t2[i]);
    }
    printf("\n");
    printf("Array 2: ");
    for (int i = 0; i < arrSize2; i++) {
        printf("%d ", arr2t2[i]);
    }
    printf("\n");
    int tmparrt2[3];
    for (int i = 0; i < arrSize2; i++) {
        tmparrt2[i] = arr1t2[i];
    }
    printf("\n");
    NeonArrSum(arr1t2, arr2t2, arrSize2);
    CArrSum(tmparrt2, arr2t2, arrSize2);
    printf("C add array: ");
    for (int i = 0; i < arrSize2; i++) {
        printf("%d ", tmparrt2[i]);
    }
    printf("\n");
    printf("Neon add array: ");
    for (int i = 0; i < arrSize2; i++) {
        printf("%d ", arr1t2[i]);
    }
    printf("\n");
    printf("\n");


    int arrSize3 = 0;
    int arr1t3[0];
    int arr2t3[0];
    printf("%sTest adding 3: %s\n", GREEN, RESET);
    printf("Array 1: ");
    for (int i = 0; i < arrSize3; i++) {
        printf("%d ", arr1t3[i]);
    }
    printf("\n");
    printf("Array 2: ");
    for (int i = 0; i < arrSize3; i++) {
        printf("%d ", arr2t3[i]);
    }
    printf("\n");
    int tmparrt3[3];
    for (int i = 0; i < arrSize3; i++) {
        tmparrt3[i] = arr1t3[i];
    }
    printf("\n");
    NeonArrSum(arr1t3, arr2t3, arrSize3);
    CArrSum(tmparrt3, arr2t3, arrSize3);
    printf("C add array: ");
    for (int i = 0; i < arrSize3; i++) {
        printf("%d ", tmparrt3[i]);
    }
    printf("\n");
    printf("Neon add array: ");
    for (int i = 0; i < arrSize3; i++) {
        printf("%d ", arr1t3[i]);
    }
    printf("\n");
    printf("\n");


    printf("%sAdding efficiency test: %s\n", CYAN, RESET);
    printf("%sC realization: %s %lf\n", GREEN, RESET, TestArrAdd(CArrSum, 1000, 10000, 312));
    printf("%sNeon realization: %s %lf\n", GREEN, RESET, TestArrAdd(NeonArrSum, 1000, 10000, 312));

    return 0;
}
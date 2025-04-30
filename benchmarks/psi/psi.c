#include <stdio.h>
#ifndef SIZE
#define SIZE 64
#endif

int sfe_main(int arr1[], int arr2[], int m, int n) {
  int i = 0, j = 0, total = 0;

  // #pragma clang loop unroll_count(4)
  while (i < m && j < n) {
    if (arr1[i] < arr2[j]) {
      i++;
    } else if (arr2[j] < arr1[i]) {
      j++;
    } else /* if arr1[i] == arr2[j] */
    {
      i++;
      total++;
    }
  }
  return total;
}
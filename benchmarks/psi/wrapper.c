// wrapper.c
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

extern int sfe_main(int32_t *arr1, int32_t *arr2, int m, int n);

int main() {
  int m = 128, n = 128;

  int32_t arr1[m];
  int32_t arr2[n];

  for (int i = 0; i < m; i++) {
    arr1[i] = i;
    arr2[i] = i;
  }
  printf("Hello World\n");
  int same = sfe_main(arr1, arr2, m, n);
  printf("same: %d\n", same);
  return 0;
}

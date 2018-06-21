#include "utilities.h"

char* subString (const char* input, int offset, int len, char* dest) {
  int input_len = strlen (input);
  
  if (offset + len > input_len) {
    return NULL;
  }
  
  strncpy (dest, input + offset, len);
  return dest;
}

// Print number of any type in binary
void printBits(size_t const size, void const * const ptr)
{
    unsigned char *b = (unsigned char*) ptr;
    unsigned char byte;
    int i, j;

    for (i=size-1;i>=0;i--)
    {
        for (j=7;j>=0;j--)
        {
            byte = (b[i] >> j) & 1;
            printf("%u", byte);
        }
    }
}

#include "utilities.h"

#ifndef UTILITIES_H
#define UTILITIES_H

char* subString (const char* input, int offset, int len, char* dest) {
  int input_len = strlen (input);
  
  if (offset + len > input_len) {
    return NULL;
  }
  
  strncpy (dest, input + offset, len);
  return dest;
}

#endif

#ifndef __UTILITIES_H__
#define __UTILITIES_H__

#include "string.h"
#include "stdio.h"

// Extracts a sub string from a string
char* subString (const char* input, int offset, int len, char* dest);
void printBits(size_t const size, void const * const ptr);

#endif

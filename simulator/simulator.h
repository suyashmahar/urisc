#ifndef _SIMULATOR_H
#define _SIMULATOR_H

#include "assert.h"
#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#include "utilities.h"

typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned long long uint64_t;
typedef enum {
	      A = 0,
	      B = 20,
	      C = 40
}  arg_t;

// Declare constants for the machine specification
const int ARG_SIZE = 20;    // bits
const int MEM_SIZE = 32; // words

// Other simulator related constants
const char* VERSION_STRING = "0.1b";
  
void print_help();

// Function to get argument from mem word, makes life easier and
// simulator a tad bit faster
/*inline */uint64_t getArg(arg_t arg, uint64_t word) {
  return (uint64_t)(word >> arg & 0b11111111111111111111);
}

// Function to set the value of argument to an existing memory word
/*inline */uint64_t setArg(arg_t arg, uint64_t argVal, uint64_t word) {
  return (uint64_t)((word & ~((uint64_t)0b11111111111111111111 << arg)) | (argVal << arg));
}

#endif

#ifndef _SIMULATOR_H
#define _SIMULATOR_H

#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#include "utilities.h"

typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef enum {
	      A = 0,
	      B = 5,
	      C = 10
}  arg_t;

// Declare constants for the machine specification
const int ARG_SIZE = 5;    // bits
const int MEM_SIZE = 32; // words

// Other simulator related constants
const char* VERSION_STRING = "0.1b";
  
void print_help();

// Function to get argument from mem word, makes life easier and
// simulator a tad bit faster
/*inline */uint8_t getArg(arg_t arg, uint16_t word) {
  return (uint8_t)(word >> arg & 0b11111);
}

// Function to set the value of argument to an existing memory word
/*inline */short setArg(arg_t arg, uint8_t argVal, uint16_t word) {
  return (uint16_t)((word & ~((uint16_t)0b11111 << arg)) | (argVal << arg));
}

#endif

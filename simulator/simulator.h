#ifndef _SIMULATOR_H
#define _SIMULATOR_H

typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef enum {
	      A = 10,
	      B = 5,
	      C = 0
}  arg_t;

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

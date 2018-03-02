#define _GNU_SOURCE
// NOTE: This simulator is non-posix compliant

#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#inlcude "utilities.h"

// Declare constants for the machine specification
const int ARG_SIZE = 5    // bits
  const int MEM_SIZE = 1024 // words
  
  // Represents the single memory location of the machine
  typedef struct {
    uin8_t a;
    uin8_t b;
    uin8_t c;
  } memCell;

// Represents the memory of the machine
memCell *mem;

// Initialize memory with a file containing binary representation of
// memory contents
void initializeMem(memCell *memRef, char **memContents, int memContentsLen) {
  mem = (memCell*) malloc(MEM_SIZE * sizeof(memCell));
  for (int i = 0; i < memContentsLen; i++) {
    char *crap;
    char *strArgA = malloc((ARG_SIZE+1) * sizeof(char));
    char *strArgB = malloc((ARG_SIZE+1) * sizeof(char));
    char *strArgC = malloc((ARG_SIZE+1) * sizeof(char));

    strnCpy(memContents[i], 1, 5, strArgA);
    strnCpy(memContents[i], 6, 5, strArgB);
    strnCpy(memContents[i], 11, 5, strArgC);

    mem[i].a = (int)strtol(strArgA, crap, 2);
    mem[i].b = (int)strtol(strArgB, crap, 2);
    mem[i].c = (int)strtol(strArgC, crap, 2);
  }
}

runSimulator(memCell *memRef, uin8_t pc) {
  printf("Simulator running...");
  while (pc < MEM_SIZE) {
    
  }
}

int main(int argc, char *argv[]) {
  if (argc < 2) {
    printf("Not enough arguments passed, exiting...");
    return 0;
  } else {
    FILE *fp;
    long lSize;
    char *buffer;
    
    // Read the file from the path in the first argument of simulator
    fp = fopen(argv[1], "rb");
    if (fp == NULL) {
      fputs("Error on reading file, exiting...", stderr);
      exit(EXIT_FAILURE);
    }

    // Get size of the file
    fseek(fp , 0L , SEEK_END);
    lSize = ftell(fp);
    rewind(fp);

    // Allocate memory for entire content
    buffer = calloc(1, lSize+1);
    if (!buffer) {
      fclose(fp);
      fputs("Memory alloc failed, exiting...", stderr);
      exit(1);
    }

    // Copy the file into the buffer
    if( 1!=fread( buffer , lSize, 1 , fp) ) {
      fclose(fp);
      free(buffer);
      fputs("Entire read failed, exiting...",stderr);
      exit(1);
    }

    // Copy the buffer to instruction[]
    char *instruction[lSize/17];
    long instCount = 0;
    while (instCount < lSize) {
      subStr(buffer, instCount*17, 17, instruction[instCount++]);
    }

    // Initialize memory with the content
    initializeMem(mem, lSize/17);

    // Ask user for program counter value
    uint8_t pc;
    printf("Enter starting value of PC > ");
    scanf("%d", pc);

    // Give the control to the runSimulator method
    runSimulator(mem, lSize/17, pc);
    
    // Close file buffer
    fclose(fp);

    // Free all the memory
    free(buffer);
  }
}

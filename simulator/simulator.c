//#define _GNU_SOURCE
// NOTE: This simulator is non-posix compliant

#include "simulator.h"
#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#include "utilities.h"
 
// Declare constants for the machine specification
const int ARG_SIZE = 5;    // bits
const int MEM_SIZE = 32; // words

// Represents the memory of the machine
uint16_t *mem; 

// Initialize memory with a file containing binary representation of
// memory contents
void initializeMem(uint16_t *memRef, char **memContents, int memContentsLen) {
  for (int i = 0; i < memContentsLen; i++) {
    char *crap;
    
    char *strArgA = (char*)malloc((ARG_SIZE+1) * sizeof(char*));
    char *strArgB = (char*)malloc((ARG_SIZE+1) * sizeof(char*));
    char *strArgC = (char*)malloc((ARG_SIZE+1) * sizeof(char*));

    strncpy(strArgA, memContents[i] + 1,  5);
    strncpy(strArgB, memContents[i] + 6,  5);
    strncpy(strArgC, memContents[i] + 11, 5);
    
    memRef[i] = setArg(A, (uint16_t)strtol(strArgA, &crap, 2), memRef[i]);
    memRef[i] = setArg(B, (uint16_t)strtol(strArgB, &crap, 2), memRef[i]);
    memRef[i] = setArg(C, (uint16_t)strtol(strArgC, &crap, 2), memRef[i]);

    free(strArgA);
    free(strArgB);
    free(strArgC);
  }
}

// Executes the instruction at pc and returns the new pc value
uint8_t executeInstruction(uint16_t *memRef, uint8_t pc) {
  uint16_t a = getArg(A, memRef[pc]);
  uint16_t b = getArg(B, memRef[pc]);
  uint16_t c = getArg(C, memRef[pc]);

  uint16_t acc = memRef[b] - memRef[a];
  uint16_t newPc = 0;

  memRef[b] = acc;
  if (acc <= 0) {
    newPc = c;
  } else {
    newPc = pc + 1;
  }
	   
  return newPc;
}

void runSimulator(uint16_t *memRef, uint8_t pcInit) {
  printf("Simulator running...");
  uint8_t pc = pcInit;

  // Compensate for the first backspace on printing PC value
  printf("\n");

  int count = 0;
  while (pc < MEM_SIZE) {
    if (count == 8) {
      return;
    } else {
      count++;
    }
    pc = executeInstruction(memRef, pc);
    printf("Current PC: %x", (int)pc);
  }

  printf("Simulation completed\n");
}

void printm(uint16_t *memRef) {
  for (int i = 0; i < MEM_SIZE; i++) {
    printf("0x%x : %d\n", i, (int)memRef[i]);
  }
  return;
}

int main(int argc, char *argv[]) {
  if (argc < 2) {
    printf("Not enough arguments passed, exiting...\n");
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
    buffer = (char*)calloc(1, lSize+1);
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

    // Intialize a 2D array for storing instructions as a list of
    // char*
    char **instructions;
    instructions = (char**)malloc((lSize/17)*sizeof(char*));
    for (int i = 0; i < lSize/17; i++) {
      // malloc free space enough to store single instruction as
      // string
      instructions[i] = (char*)malloc(17*sizeof(char*));
    }
        
    long instCount = 0;
    while (instCount < lSize/17) {
      subString(buffer, instCount*17, 17, instructions[instCount]);
      instCount++;
    }

    // Allocate and clear memory
    mem = (uint16_t*) malloc(MEM_SIZE * sizeof(short));
    for (int i = 0; i < MEM_SIZE; i++) {
      mem[i] = 0;
    }
    
    // Initialize memory with the content
    initializeMem(mem, instructions, (int)lSize/17);

    printm(mem);
    
    // Ask user for program counter value
    int pc;
    printf("Enter starting value of PC > ");
    scanf("%d", &pc);

    // Give the control to the runSimulator method
    runSimulator(mem, (uint8_t)pc);

    printm(mem);
    // Close file buffer
    fclose(fp);

    // Free all the memory
    free(buffer);
  }
}

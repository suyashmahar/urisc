//#define _GNU_SOURCE
// NOTE: This simulator is non-posix compliant

#include "simulator.h"

/*
  TODO
  ----
  * Correct the logic for creating memory array from the program
  file where the first bit is being missed.
  * Consider endianess of the processor
 */

// Represents the memory of the machine
uint64_t *mem; 

// Initialize memory with a file containing binary representation of
// memory contents
void initializeMem(uint64_t *memRef, char **memContents, int memContentsLen) {
  for (int i = 0; i < memContentsLen; i++) {
    char *crap;
    
    char *strArgA = (char*)malloc((ARG_SIZE+1) * sizeof(char));
    char *strArgB = (char*)malloc((ARG_SIZE+1) * sizeof(char));
    char *strArgC = (char*)malloc((ARG_SIZE+1) * sizeof(char));

    strncpy(strArgC, memContents[i] + 4,  20);
    strncpy(strArgB, memContents[i] + 24, 20);
    strncpy(strArgA, memContents[i] + 44, 20);
    
    memRef[i] = setArg(A, (uint64_t)strtol(strArgA, &crap, 2), memRef[i]);
    memRef[i] = setArg(B, (uint64_t)strtol(strArgB, &crap, 2), memRef[i]);
    memRef[i] = setArg(C, (uint64_t)strtol(strArgC, &crap, 2), memRef[i]);

    /*free(strArgA);
    free(strArgB);
    free(strArgC);*/
  }
}

// Executes the instruction at pc and returns the new pc value
uint8_t executeInstruction(uint64_t *memRef, uint8_t pc) {
  uint64_t a = getArg(A, memRef[pc]);
  uint64_t b = getArg(B, memRef[pc]);
  uint64_t c = getArg(C, memRef[pc]);

  printf("Executing instruction with at %llu args: a: %llu b: %llu c: %llu\n", (uint64_t)pc, (uint64_t)a,  (uint64_t)b, (uint64_t)c);
  memRef[b] = memRef[b] - memRef[a];
  uint64_t newPc = 0;

  if (memRef[b] <= 0) {
    newPc = c;
  } else {
    newPc = pc + 1;
  }
  printf("Result: mem[b] = %ul, pc = %i\n", memRef[b], newPc);
  return newPc;
}

void runSimulator(uint64_t *memRef, uint8_t pcInit) {
  printf("Simulator running...\n");
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
  }

  printf("Simulation completed\n");
}

void printm(uint64_t *memRef) {
  printf("\nMemory contents:\n");
  printf("%7s  %s\n", "Address", "Content");
  for (int i = 0; i < MEM_SIZE; i++) {
    printf("%07d: ", i);
    printBits(sizeof(uint64_t), (const void*)&memRef[i]);
    printf("\n");
  }
  return;
}

void print_help() {
  printf("URISC simulator v%s", VERSION_STRING);
  printf("(c) 2018 Suyash Mahar.\n");
  printf("\nUsage: usim [flags] [file]\n");
}

int main(int argc, char *argv[]) {
  if (argc < 2) {
    printf("Not enough arguments passed\n");
    print_help();
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
    instructions = (char**)malloc((lSize/65)*sizeof(char*));
    for (int i = 0; i < lSize/65; i++) {
      // malloc free space enough to store single instruction as
      // string
      instructions[i] = (char*)malloc(65*sizeof(char*));
    }
        
    long instCount = 0;
    while (instCount < lSize/65) {
      subString(buffer, instCount*65, 65, instructions[instCount]);
      instCount++;
    }

    // Allocate and clear memory
    mem = (uint64_t*) malloc(MEM_SIZE * sizeof(uint64_t));
    for (int i = 0; i < MEM_SIZE; i++) {
      mem[i] = 0;
    }
    
    // Initialize memory with the content
    initializeMem(mem, instructions, (int)lSize/65);

    printm(mem);
    
    // Ask user for program counter value
    int pc;
    printf("\nEnter starting value of PC > ");
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

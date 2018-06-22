/*
 * Contains globals package for project wide variables 
 */

package gc; // Global Constants
   parameter WORD_SIZE = 64;
   parameter MEM_SIZE = 32;
   
   parameter ARG_A_SIZE = 20;
   parameter ARG_B_SIZE = 20;
   parameter ARG_C_SIZE = 20;

   typedef enum {
       A, B, C
   } ARGS;
   
endpackage : gc// globals
   

/*
 * Contains globals package for project wide variables 
 */

package gc; // Global Constants
   parameter WORD_SIZE = 64;
   parameter MEM_SIZE = 36;
   
   parameter ARG_A_SIZE = 20;
   parameter ARG_B_SIZE = 20;
   parameter ARG_C_SIZE = 20;

   
   // Argument size (bits)
   parameter A_s = 20;
   parameter B_s = 20;
   parameter C_s = 20;

   // Upper bound   
   parameter A_UB = A_s - 1;
   parameter B_UB = A_s + B_s - 1;
   parameter C_UB = A_s + B_s + C_s - 1;

   // Lower bound
   parameter A_LB = 0;
   parameter B_LB = A_s;
   parameter C_LB = A_s + B_s;
   
   typedef enum {
       A, B, C
   } ARGS;
   
endpackage : gc// globals
   

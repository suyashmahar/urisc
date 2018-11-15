/*
 * Contains globals package for project wide variables 
 */

package gc; // Global Constants
   parameter WORD_SIZE = 64;
   parameter IO_COUNT = 2;
   parameter MEM_SIZE = 2400;
   parameter ASCII_SIZE = 8;
      
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

   // ioBus direction, always wrt memory
   parameter IO_IN = 1'b1, IO_OUT = 1'b0;

   // Index for IO arbiter
   parameter VGA_I = 1'b0, PS2_I = 1'b1;
   
   // Offsets for virtual to physical memory conversions
   parameter VGA_MEM_OFFSET = 64'h00;//64'h81;
   parameter KEYBOARD_ADD = 64'h20; // TODO: Fix this
      
endpackage : gc// globals
   

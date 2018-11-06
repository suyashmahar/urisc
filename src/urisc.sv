`timescale 1ns/1ps

`include "urisc.svh"
import gc::*;

module urisc(clk, rst, ioClk, ioBus, ioBusDirection, ioAddress, led);
   input clk, rst;
   inout [gc::WORD_SIZE - 1:0] ioBus; // For transferring data in and out of the processor memory, uses cycle stealing
   input [gc::WORD_SIZE - 1:0] ioAddress;
   input 		       ioBusDirection;

   output wire 		       ioClk;
   output wire [15-1:0]     led;
   
   assign led[15-1:0] = pc[15-1:0];
   //assign led[16-1] = pc == 0;
   localparam FIRST = 2'b00, SECOND = 2'b01, THIRD = 2'b10;

   // Gets 3 120deg phase shifted f/6 freq clocks from input clock
   // Allowing the processor to use dual port memory for the instruction
   // subleq a, b, c
   wire [2:0] 		       clkDivided;
   clockDivider #(.DIVIDE_BY(3)) clkdiv1(.clkIn(clk), .clkOut(clkDivided));

   // ir = instruction register
   // pc = program counter
   reg [gc::WORD_SIZE - 1:0]   ir, last_ir;
   reg [gc::WORD_SIZE - 1:0]   pc;

   // Instantiate and connect a dual port memory ports
   reg [gc::WORD_SIZE - 1:0]   memAdd1, memAdd2;
   reg 			       memWrite1, memWrite2;
   reg [gc::WORD_SIZE - 1:0]   memDataIn1, memDataIn2;
   wire [gc::WORD_SIZE - 1:0]  memResult1, memResult2;
   
   int 			       counter;
   assign ioBus = (ioBusDirection == gc::IO_OUT) ? pc : {gc::WORD_SIZE{1'bz}};
   
   (* dont_touch = "true" *) (* keep_hierarchy = "yes" *) memory pMem (
		.clk(~clk),
       
		.add1(memAdd1),
		.dataIn1(memDataIn1),
		.write1(memWrite1),
		.dataOut1(memResult1),
       
		.add2(memAdd2),
		.dataIn2(memDataIn2),
		.write2(memWrite2),
		.dataOut2(memResult2)
		);
   
   initial begin
       memWrite1 = 1'b0;
       memWrite2 = 1'b0;
       
       memAdd1 = 0;
       memAdd2 = 0;
       
       pc = 11;
       counter = 0;

       $display("Using WORD_SIZE = %d", gc::WORD_SIZE);
   end

   // Extract a, b and c from the ir
   wire [gc::WORD_SIZE - 1:0] a, b, c;

   assign a = memResult1[gc::A_UB : gc::A_LB];
   assign b = memResult1[gc::B_UB : gc::B_LB];
   assign c = memResult1[gc::C_UB : gc::C_LB]; 
   
   /* Performs the operation: 
    ir <- mem[pc]
    acc <- mem[b] - mem[a]
    mem[b] <- acc
    if (acc <= 0) pc <- c */
   reg [gc::WORD_SIZE - 1:0]  acc;
   // Set the ioBus for second and third cycle
   assign ioBus = (ioBusDirection == gc::IO_OUT) ? memResult2 : {gc::WORD_SIZE{1'bz}};
   
   assign ioClk = ((counter == FIRST) & (counter == SECOND) & clk);
   
   always @(posedge clk) begin
	   case (counter) 
	     FIRST: begin
		 memAdd1 = pc;
		 memWrite1 = gc::IO_OUT;
		 
		 // IO stuff
		 //ioClk = 1'b1;
		 
		 memAdd2 = ioAddress;
		 memWrite2 = ioBusDirection;
		 memDataIn2 = (ioBusDirection == gc::IO_IN) ? ioBus : {gc::WORD_SIZE{1'bz}};
	     end SECOND: begin
	     last_ir = ir;
		 ir = memResult1;
		 //ioClk = 1'b1;
		 
		 memAdd1 = b;
		 memAdd2 = a;
		 
		 memWrite1 = gc::IO_OUT;
		 memWrite2 = gc::IO_OUT;
		 
		 // IO stuff
	     end THIRD: begin
		 acc = memResult1 - memResult2;
		 
		 memAdd1 = b;
		 memWrite1 = gc::IO_IN;
		 memDataIn1 = acc;

		 if (acc <= 0) begin
		     pc = ir[gc::C_UB : gc::C_LB];//last_ir[gc::C_UB : gc::C_LB];
		 end else begin
		     pc += 1;
		 end
		 
		 // IO Stuff
		 memAdd2 = ioAddress;
		 memWrite2 = ioBusDirection;
		 memDataIn2 = (ioBusDirection == gc::IO_IN) ? ioBus : {gc::WORD_SIZE{1'bz}};
	     end
	   endcase // case THIRD
	   
	   if (rst) begin
               
               memWrite1 = gc::IO_OUT;
               memWrite2 = ioBusDirection;
            
               pc = 11;
               
               memAdd1 = pc;
               memAdd2 = ioAddress;
               
               counter = SECOND;
               
               $display("Processor reset");
	   end else begin
           counter = #1 (counter+1)%3;
	   end
   end // always @ (posedge clk1)
endmodule // top

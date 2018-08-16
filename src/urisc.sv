`timescale 1ns/1ps

`include "urisc.svh"

module top(clk, led);
   input clk;
   output [gc::WORD_SIZE - 1:0] led;

   // Gets 3 120deg phase shifted f/6 freq clocks from input clock
   // Allowing the processor to use dual port memory for the instruction
   // subleq a, b, c
   wire [2:0] 			clkDivided;
   clockDivider #(.DIVIDE_BY(3)) clkdiv1(.clkIn(clk), .clkOut(clkDivided));

   // ir = instruction register
   // pc = program counter
   reg [gc::WORD_SIZE - 1:0] 	ir;
   reg [gc::WORD_SIZE - 1:0] 	pc;

   // Instantiate and connect a dual port memory ports
   reg [gc::WORD_SIZE - 1:0] 	memAdd1, memAdd2;
   reg 				memWrite1, memWrite2;
   reg [gc::WORD_SIZE - 1:0] 	memDataIn1, memDataIn2;
   wire [gc::WORD_SIZE - 1:0] 	memResult1, memResult2;
   
   memory pMem (
	       .clk(clk),
	       
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
       pc = 0;
       $display("Using WORD_SIZE = %d", gc::WORD_SIZE);
   end

   // Extract a, b and c from the ir
   wire [gc::WORD_SIZE - 1:0] a, b, c;

   assign a = ir[gc::A_UB : gc::A_LB];
   assign b = ir[gc::B_UB : gc::B_LB];
   assign c = ir[gc::C_UB : gc::C_LB]; 
  
   /* Performs the operation: 
          ir <- mem[pc]
          acc <- mem[b] - mem[a]
          mem[b] <- acc
          if (acc <= 0) pc <- c */
   reg [gc::WORD_SIZE - 1:0]  acc;

   always @(posedge clk) begin
       case (clkDivided) 
	 3'b001: begin
	     ir = memResult1;
	     
	     memWrite1 = 1'b0;
	     memWrite2 = 1'b0;
	     
	     memAdd1 = b;
	     memAdd2 = a;
	 end
	 3'b010: begin
	     acc = memResult1 - memResult2;
	     
	     memWrite1 = 1'b1;
	     memWrite2 = 1'b0;
	     
	     memAdd1 = b;
	     memDataIn1 = acc;
	 end
	 3'b100: begin
	     if (acc <= 0) begin
		 pc = acc;
	     end else begin
		 pc += 1;
	     end

	     memWrite1 = 1'b0;
	     memWrite2 = 1'b0;
	     
	     memAdd1 = pc;
	 end
       endcase // case (clkDivided)
   end // always @ (posedge clk1)
endmodule // top

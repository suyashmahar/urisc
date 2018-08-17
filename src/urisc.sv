`timescale 1ns/1ps

`include "urisc.svh"

module top(clk, led);
   input clk;
   output [gc::WORD_SIZE - 1:0] led;
   
   localparam FIRST = 2'b00, SECOND = 2'b01, THIRD = 2'b10;

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
   
   int 				counter;
   assign led = pc;
   
   memory pMem (
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

   always @(posedge clk) begin
       case (counter) 
	 FIRST: begin
	     memAdd1 = pc;

	     memWrite1 = 1'b0;
	     memWrite2 = 1'b0;
	 end SECOND: begin
	     ir = memResult1;
	     
	     memAdd1 = b;
	     memAdd2 = a;
	     
	     memWrite1 = 1'b0;
	     memWrite2 = 1'b0;
	 end THIRD: begin
	     acc = memResult1 - memResult2;
	     
	     memAdd1 = b;
	     
	     memWrite1 = 1'b1;
	     memWrite2 = 1'b0;
	     
	     memDataIn1 = acc;

	     if (memResult1 <= 0) begin
		 pc = ir[gc::C_UB : gc::C_LB];
	     end else begin
		 pc += 1;
	     end
	 end
       endcase // case THIRD
       counter = #1 (counter+1)%3;
   end // always @ (posedge clk1)
endmodule // top

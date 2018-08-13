`timescale 1ns/1ps

`include "cFunctions.svh"

/*
 * Tests clockDivider module
 */
module clockDivider_tb;
   parameter DIVIDE_BY = 3;
   
   reg clkIn;
   wire [DIVIDE_BY - 1 : 0] clkOut;
      
   int 	counter;
   
   clockDivider 
     #(.DIVIDE_BY(DIVIDE_BY)) 
   uut (
	.clkIn(clkIn),
	.clkOut(clkOut)
	);
   
   initial begin
       clkIn = 1'b0;
       counter = 0;
   end
   
   always begin
       clkIn = #15 ~clkIn;
   end
   
   always @(*) begin
       counter++;
       //_assert_(clk1 == ~clk2, "Error");
       if (counter == 100) begin
	   $finish;
       end
   end
endmodule // clockDivider_tb


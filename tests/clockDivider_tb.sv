`timescale 1ns/1ps

import utilities::*;

/*
 * Tests clockDivider module
 */
module clockDivider_tb;
   reg clkIn;
   wire clk1, clk2;

   int counter;
   
   clockDivider uut (
		     .clkIn(clkIn),
		     .clk1(clk1),
		     .clk2(clk2)
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
       utilities::_assert(clk1 == ~clk2);
       if (counter == 100) begin
	   $finish;
       end
   end
endmodule // clockDivider_tb


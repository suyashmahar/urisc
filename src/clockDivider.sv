`timescale 1ns/1ps

/* 
 * Divides input clock of frequency of F in to two clocks of
 * frequency F/2, phase shifted by 180 degrees.
 */
module clockDivider
  (
   input      clkIn,
   output reg clk1,
   output reg clk2
   );
   
   reg 	      clkState;
   
   initial begin
       clkState = 1'b0;
       clk1 = 1'b0;
       clk2 = 1'b1;
   end
   
   always @(posedge clkIn) begin
       clk1 <= ~clk1;
       clk2 <= ~clk2;
   end
endmodule // clockDivider


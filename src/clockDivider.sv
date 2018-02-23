`timescale 1ns/1ps

/* 
 * Divides input clock of frequency of F in to N clocks of
 * frequency F/N, phase shifted by 2*pi/N rads.
 */
module clockDivider
  #(
    parameter DIVIDE_BY = 2
    )(
      input 			   clkIn,
      output reg [DIVIDE_BY - 1:0] clkOut
      );
   
   reg 		 clkState;
   int 		 counter;
   
   initial begin
       clkState = 1'b0;
       clkOut = {DIVIDE_BY{1'b0}} | 1'b1;
   end

   // Shifts the content of 
   always @(posedge clkIn) begin
       clkOut <= {{clkOut[DIVIDE_BY - 2:0]},{clkOut[DIVIDE_BY-1]}};
   end
endmodule // clockDivider


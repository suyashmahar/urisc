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
   
   reg 				   shiftReg [DIVIDE_BY-1:0];

   assign clkOut = shiftReg;
   
   initial begin
       shiftReg = {DIVIDE_BY{1'b0},1'b1};
   end

   // Shift a register containing a single 1 to generate n clocks,
   // where n is the width of the shift registers
   always @(posedge clk) begin
       shiftReg <= {shiftReg[0], shiftReg[DIVIDE_BY-1:1]};
   end
   
endmodule // clockDivider


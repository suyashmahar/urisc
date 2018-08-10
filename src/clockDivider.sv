`timescale 1ns/1ps

/* 
 * Divides input clock of frequency of F in to N clocks of
 * frequency F/N, phase shifted by 2*pi/N rads.
 */
module clockDivider
  #(
    parameter DIVIDE_BY = 2
    )(
      input 	 clkIn,
      output reg [DIVIDE_BY - 1:0] clkOut
      );
   
   reg [DIVIDE_BY-1:0] 		   shiftReg;

   assign clkOut = shiftReg;

   integer 			   count;
   
   initial begin
       for (count = 0; count < DIVIDE_BY; count++) begin
	   shiftReg[count] = 0;
       end
   end

   // Shift a register containing a single 1 to generate n clocks,
   // where n is the width of the shift registers
   always @(posedge clkIn) begin
       shiftReg <= {shiftReg[0], shiftReg[DIVIDE_BY-1:1]};
   end
   
endmodule // clockDivider

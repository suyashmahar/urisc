`timescale 1ns/1ps

module memory
  #(
    parameter WORD_SIZE = 16,
    parameter MEM_SIZE = 32
    )(
      input 			   clk,
      
      input [WORD_SIZE - 1:0] 	   add1,
      input [WORD_SIZE - 1:0] 	   dataIn1,
      input 			   write1,
      output reg [WORD_SIZE - 1:0] dataOut1,
      
      input [WORD_SIZE - 1:0] 	   add2,
      input [WORD_SIZE - 1:0] 	   dataIn2,
      input 			   write2,
      output reg [WORD_SIZE - 1:0] dataOut2
      );
   
   reg [MEM_SIZE - 1:0] 	   mem[WORD_SIZE-1:0];
   
   always @(posedge clk) begin
       if (write1) begin
	   mem[add1] <= dataIn1;
       end else begin
	   dataOut1 <= mem[add1];
       end
   end
   
   always @(posedge clk) begin
       if (write2) begin
	   mem[add2] <= dataIn2;
       end else begin
	   dataOut2 <= mem[add2];
       end
   end
endmodule // memory

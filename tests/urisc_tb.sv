`timescale 1ns/1ps

module urisc_tb;
   reg clk;
   wire [gc::WORD_SIZE-1:0] led;

   top top_inst(.clk(clk), .led(led));

   initial begin
       clk = 0;
   end

   always begin
       clk = #15 ~clk;
   end
endmodule

`timescale 1ns/1ps

import gc::*;
module top(clk, led);
   input clk;
   output [gc::WORD_SIZE - 1:0] led;
   
   initial begin
       $display("Using WORD_SIZE = %d", gc::WORD_SIZE);
   end

   always @(posedge clk) begin
       $display("Clock running");
   end
endmodule // top


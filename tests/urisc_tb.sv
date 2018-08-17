`timescale 1ns/1ps

module urisc_tb;
   reg clk;
   wire [gc::WORD_SIZE-1:0] led;

   integer 		    cycCount = 0;
   reg 			    rst = 0;

   top top_inst(.clk(clk), .rst(rst), .led(led));
   
   initial begin
       clk = 0;

       for (cycCount = 0; cycCount < 10; cycCount++) begin
	   clk = #15 ~clk;
       end

       rst = 1;

       clk = #15  ~clk;
       clk = #15  ~clk;
       clk = #15  ~clk;

       rst = 0;
       
       for (cycCount = 0; cycCount < 10; cycCount++) begin
	   clk = #15 ~clk;
       end
   end
endmodule

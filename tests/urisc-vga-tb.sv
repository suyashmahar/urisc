`timescale 1ns/1ps

module urisc_vga_tb;
   reg clk;
   reg rst;
   reg kbdClk, kbdDatain;
   wire hSync, vSync;
   wire [3-1:0] red, green, blue;
   wire [16-1:0] led;
   
      
   integer 	out_f;
   
   top dut 
     (
        .clk_in(clk), .rst(rst), .led(led), .red(red), .green(green), .blue(blue), .hSync(hSync), .vSync(vSync)
      );

   initial begin
       rst = 0;
       clk = 0;

       out_f = $fopen("/home/suyash/output.txt", "w");
       #1000 rst = 1;
       #100 rst = 0;       
   end

   always begin
       clk = #10 ~clk;
       $fwrite(out_f, "%d ns: %b %b %b %b %b\n", $time, hSync, vSync, red, green, blue);
   end
      
endmodule

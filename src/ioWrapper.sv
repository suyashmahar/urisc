`include "dispConsts.svh"

module vgaWrapper(clk, ioClk, memDataRead, memReadAdd, hSync, vSync, red, green, blue);
   input clk;
   input ioClk;			// Clock who's +ve edge arrives with fresh IO data, much slower than the system clock
   input memDataRead [gc::WORD_SIZE-1:0]; // Data read from the memory

   output wire hSync, vSync;
   output wire [3-1:0] red, green, blue;
   output reg [gc::WORD_SIZE-1:0] memReadAdd;
      
   localparam clkDivideBy = 10;
   localparam charsPerWord = gc::WORD_SIZE/ASCII_SIZE;
   localparam totalWordsInScreen = (CHARS_HORZ*CHARS_VERT)/(gc::WORD_SIZE/ASCII_SIZE);
   
   reg clk_25M = 0;

   integer clkDividerCounter = 0;

   always @(posedge clk) begin
       clkDividerCounter++;
       if (clkDividerCounter == clkDivideBy) begin
	   clk_25M = ~clk_25M;
	   clkDividerCounter = 0;
       end
   end
   
   reg [ASCII_SIZE-1:0] charBuffer [CHARS_VERT-1:0][CHARS_HORZ-1:0];
   
   output wire hSync, vSync;
   output wire [3-1:0] red, green, blue;

   integer 	       charBufferCounter = 0;
   always @(posedge ioClk) begin
       charBufferCounter += charsPerWord;
       if (charBufferCounter == CHARS_VERT*CHARS_HORZ-1) begin
	   charBufferCounter = 0;
       end
       // Todo: Move this to generate statement
       charBuffer[charBufferCounter] = memDataRead[charsPerWord*4-1:charsPerWord*3-1];
       charBuffer[charBufferCounter+1] = memDataRead[charsPerWord*3-1:charsPerWord*2-1];
       charBuffer[charBufferCounter+2] = memDataRead[charsPerWord*2-1:charsPerWord-1];
       charBuffer[charBufferCounter+3] = memDataRead[charsPerWord-1:0];
   end

   // charBufferCounter points to the virtual memory address used by the VGA module, this address
   // will then be converted to the actual address where the char buffer in the memory is
   assign memReadAdd = charBufferCounter; // TODO: signed to unsigned conversion
   
   draw draw_inst 
     (
      .clk_25M(clk_25M), 
      .charBuffer(charBuffer), 
      .hSync(hSync), 
      .vSync(vSync), 
      .red(red), 
      .green(green), 
      .blue(blue)
      );
endmodule

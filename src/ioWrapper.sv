`include "dispConsts.svh"

module vgaWrapper(clk, vgaClk, ioClk, memDataRead, memReadAdd, hSync, vSync, red, green, blue);
   input clk;
   input vgaClk;
   input ioClk;			// Clock who's +ve edge arrives with fresh IO data, much slower than the system clock
   input memDataRead [gc::WORD_SIZE-1:0]; // Data read from the memory

   output wire hSync, vSync;
   output wire [3-1:0] red, green, blue;
   output reg [gc::WORD_SIZE-1:0] memReadAdd;
      
   localparam clkDivideBy = 10;
   localparam charsPerWord = gc::WORD_SIZE/ASCII_SIZE;
   localparam totalWordsInScreen = (CHARS_HORZ*CHARS_VERT)/(gc::WORD_SIZE/ASCII_SIZE);
   
   reg [ASCII_SIZE-1:0] charBuffer [CHARS_VERT-1:0][CHARS_HORZ-1:0];
   
   integer a, b;
   
   initial begin
        for (a = 0; a < CHARS_VERT; a++) begin
              for (b = 0; b < CHARS_HORZ; b++) begin
                 charBuffer[a][b] = 7'b0000000;
              end
          end
   end
   integer 		charBufferCounterX = 0, charBufferCounterY = 0;
   always @(posedge ioClk) begin
       charBufferCounterX += charsPerWord;
       // Move the io window accross the whole screen
       if (charBufferCounterX == CHARS_HORZ-1) begin
	   charBufferCounterX = 0;
	   charBufferCounterY++;
	   if (charBufferCounterY == CHARS_VERT-1) begin
	       charBufferCounterY = 0;
	   end
       end
       
       // Todo: uncomment these lines and find correct value of charsPerWord
       //charBuffer[charBufferCounterY][charBufferCounterX]   = { << {memDataRead[charsPerWord*4-1:charsPerWord*3-1]}};
       //charBuffer[charBufferCounterY][charBufferCounterX+1] = { << {memDataRead[charsPerWord*3-1:charsPerWord*2-1]}};
       //charBuffer[charBufferCounterY][charBufferCounterX+2] = { << {memDataRead[charsPerWord*2-1:charsPerWord-1]}};
       charBuffer[charBufferCounterY][charBufferCounterX+3] = { << {memDataRead[8-1:0]}};
   end

   // charBufferCounter points to the virtual memory address used by the VGA module, this address
   // will then be converted to the actual address where the char buffer in the memory is
   assign memReadAdd = charBufferCounterX + charBufferCounterY*CHARS_HORZ + gc::VGA_MEM_OFFSET; // TODO: signed to unsigned conversion
   
   /*draw draw_inst 
     (
      .clk_25M(clk), 
      .charBuffer(charBuffer), 
      .hSync(hSync), 
      .vSync(vSync), 
      .red(red), 
      .green(green), 
      .blue(blue)
      );
  */
   mojo_top mt_inst (
          .clk(clk),
         .charBuffer(charBuffer), 
          .hsync_out(hSync),
          .vsync_out(vSync),
          .red(red),
          .green(green),
          .blue(blue)
         );
endmodule

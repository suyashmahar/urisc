module ps2Wrapper(clk, kbdClk, kbdDataIn, dataOut, addOut);
   localparam ps2ClkDivideBy = 100;
   localparam charsInWord = gc::WORD_SIZE/gc::ASCII_SIZE;
   
   input clk, kbdClk;
   input kbdDataIn;
   
   output [gc::WORD_SIZE-1:0] dataOut;
   output reg [gc::WORD_SIZE-1:0] addOut;
   
   wire 			  kbdClk;
   wire [gc::WORD_SIZE-1:0] 	  dataOut;
   wire 			  keyValid;
   
   reg [gc::ASCII_SIZE-1:0] 	  keyBuffer [charsInWord-1:0];
   reg [3-1:0] 			  keyBufferPointer = 0;

   initial begin
       addOut = gc::KEYBOARD_ADD;
   end
   
   always @(posedge keyValid) begin
       keyBuffer[keyBufferPointer] = dataOut;
       keyBufferPointer++;
   end

   // TODO: Handle the error signal
   ps2Interface ps2Interface_inst(.kbdClk(kbdClk), .kbdDataIn(kbdDataIn), .led(dataOut), .error(), .keyValid(keyValid));       
endmodule

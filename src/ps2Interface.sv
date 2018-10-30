import gc::*;

module ps2Interface (kbdClk, kbdDataIn, led[gc::WORD_SIZE-1:0], error, keyValid);
   parameter FIFO_SIZE = 32;
   
   input kbdClk;
   input kbdDataIn;
   output [gc::WORD_SIZE-1:0] led;
   output reg 	  error;
   output wire 	  keyValid;
      
   reg [8-1:0] 	  data [FIFO_SIZE-1:0];
   reg [4-1:0] 	  dataCounter;
   reg 		  parityAcc;
   reg [8-1:0] 	  dataOut;


   function [8-1:0] scanToAscii;
      input [8-1:0] scanCode;

       case (scanCode)
	 8'h1C: scanToAscii = "A";
	 8'h32: scanToAscii = "B";
	 8'h21: scanToAscii = "C";
	 8'h23: scanToAscii = "D";
	 8'h24: scanToAscii = "E";
	 8'h2B: scanToAscii = "F";
	 8'h34: scanToAscii = "G";
	 8'h33: scanToAscii = "H";
	 8'h43: scanToAscii = "I";
	 8'h3B: scanToAscii = "J";
	 8'h42: scanToAscii = "K";
	 8'h4B: scanToAscii = "L";
	 8'h3A: scanToAscii = "M";
	 8'h31: scanToAscii = "N";
	 8'h44: scanToAscii = "O";
	 8'h4D: scanToAscii = "P";
	 8'h15: scanToAscii = "Q";
	 8'h2D: scanToAscii = "R";
	 8'h1B: scanToAscii = "S";
	 8'h2C: scanToAscii = "T";
	 8'h3C: scanToAscii = "U";
	 8'h2A: scanToAscii = "V";
	 8'h1D: scanToAscii = "W";
	 8'h22: scanToAscii = "X";
	 8'h35: scanToAscii = "Y";
	 8'h1A: scanToAscii = "Z";
	 8'h45: scanToAscii = "0";
	 8'h16: scanToAscii = "1";
	 8'h1E: scanToAscii = "2";
	 8'h26: scanToAscii = "3";
	 8'h25: scanToAscii = "4";
	 8'h2E: scanToAscii = "5";
	 8'h36: scanToAscii = "6";
	 8'h3D: scanToAscii = "7";
	 8'h3E: scanToAscii = "8";
	 8'h46: scanToAscii = "9";
	 default: scanToAscii = 8'h00;
       endcase // case (scanCode)
   endfunction

   assign led = scanToAscii(data[1]);
   
   initial begin
       parityAcc = 0;
       dataCounter = 0;
       error = 0;
   end

   wire stateSwitch = (dataCounter == 10);
   assign keyValid = stateSwitch; // led value sampled at posedge of keyValid is last read key ASCII value
   
   genvar i;
   generate
       for (i = 0; i < FIFO_SIZE - 1; i = i + 1) begin
	   always @(posedge stateSwitch) begin
	       data[i+1] <= data[i];
	   end
       end
   endgenerate
   
   always @(negedge kbdClk) begin
       if (dataCounter == 4'b0000) begin
	   parityAcc = 1'b0;
       end else if (dataCounter > 4'b0000 && dataCounter < 4'b1001) begin
	   data[0][dataCounter - 1] = kbdDataIn;
	   parityAcc = parityAcc ^ kbdDataIn;
       end else if (dataCounter == 4'b1001) begin
	   error = (parityAcc != kbdDataIn);
       end 
       dataCounter = (dataCounter == 10) ? 0 : dataCounter + 1;
   end // always @ (negedge kbdClk)

   
endmodule // ps2Interface


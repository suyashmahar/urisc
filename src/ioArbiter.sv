/*
 * File: ioArbiter.sv
 * 
 * Description: Arbitrates limited IO resources of the URISC processor among VGA, Keyboard,
 * etc in round robin manner.
 */

module ioArbiter 
  #(
    parameter IO_COUNT = gc::IO_COUNT,
    parameter WORD_SIZE = 1
    )(
      clk, addressInArr, dataInArr, dataOutArr, dataValidArr, memData, memAdd, memDir
      );

   inout [WORD_SIZE-1:0] memData; // Data supplied to or read from the memory

   input 		 clk;
   input [WORD_SIZE-1:0] addressInArr [IO_COUNT-1:0]; // Array of addresses requested by each IO device
   input [WORD_SIZE-1:0] dataInArr [IO_COUNT-1:0];    // Array containing data supplied by each IO device
   input 		 memDir [gc::IO_COUNT-1:0];	      // Represents the direction of the memory bus to the memory
   
   output reg [WORD_SIZE-1:0] dataOutArr [IO_COUNT-1:0]; // Array containing data read from the memory 
   output reg [WORD_SIZE-1:0] memAdd;		     // Address supplied to memory
   output reg 		      dataValidArr [IO_COUNT-1:0];
   
   integer 		      arbitrationCounter = 0; // Tracks which IO device has to be serviced
   reg [IO_COUNT-1:0] 	      dataValidArr_packed;
   
   always @(posedge clk) begin
       arbitrationCounter++;
       if (arbitrationCounter == IO_COUNT) begin
	   arbitrationCounter = 0;
       end
   end

   integer validCheckCounter = 0;
   always @(*) begin
       dataValidArr_packed = 1'b1 << arbitrationCounter;
       memAdd                           = addressInArr[arbitrationCounter];
       dataOutArr[arbitrationCounter]   = (memDir[arbitrationCounter] == gc::IO_OUT) ? memData : {WORD_SIZE-1{1'bz}};
   end
   assign memData = (memDir[arbitrationCounter] == gc::IO_IN) ? dataInArr[arbitrationCounter] : {WORD_SIZE-1{1'bz}};

   genvar ioCountGenVar;
   generate
       for (ioCountGenVar = 0; ioCountGenVar < IO_COUNT; ioCountGenVar++) begin
	   assign dataValidArr[ioCountGenVar] = dataValidArr_packed[ioCountGenVar];
       end
   endgenerate
   
endmodule // ioArbiter

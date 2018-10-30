/*
 * File: ioArbiter.sv
 * 
 * Description: Arbitrates limited IO resources of the URISC processor among VGA, Keyboard,
 * etc in round robin manner.
 */

module ioArbiter 
  #(
    parameter IO_COUNT = gc::IO_COUNT
    )(
      clk, 
      addressInArr, 
      dataInArr, 
      dataOutArr, 
      dataValidArr, 
      dataDirArr,  
      memData, 
      memAdd, 
      memDir, 
      );

   inout [gc::WORD_SIZE-1:0] memData; // Data supplied to or read from the memory

   input 		     clk;
   input [gc::WORD_SIZE-1:0] addressInArr [IO_COUNT-1:0]; // Array of addresses requested by each IO device
   input [gc::WORD_SIZE-1:0] dataInArr [IO_COUNT-1:0];    // Array containing data supplied by each IO device
   input 		     dataDirArr [gc::IO_COUNT-1:0];	      // Represents the direction of the memory bus to the memory
   
   output reg [gc::WORD_SIZE-1:0] dataOutArr [IO_COUNT-1:0]; // Array containing data read from the memory 
   output reg [gc::WORD_SIZE-1:0] memAdd;		     // Address supplied to memory
   output reg 			  dataValidArr [IO_COUNT-1:0];
   output 			  memDir;

   integer 			  arbitrationCounter = 0; // Tracks which IO device has to be serviced
   reg [IO_COUNT-1:0] 		  dataValidArr_packed;

   assign memDir = dataDirArr[arbitrationCounter];
   
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
       dataOutArr[arbitrationCounter]   = (dataDirArr[arbitrationCounter] == gc::IO_OUT) ? memData : {gc::WORD_SIZE-1{1'bz}};
   end
   assign memData = (dataDirArr[arbitrationCounter] == gc::IO_IN) ? dataInArr[arbitrationCounter] : {gc::WORD_SIZE-1{1'bz}};

   genvar ioCountGenVar;
   generate
       for (ioCountGenVar = 0; ioCountGenVar < IO_COUNT; ioCountGenVar++) begin
	   assign dataValidArr[ioCountGenVar] = dataValidArr_packed[ioCountGenVar];
       end
   endgenerate
   
endmodule // ioArbiter

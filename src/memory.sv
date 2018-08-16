`timescale 1ns/1ps

module memory
  #(
    parameter MEM_FILE = "/home/suyash/git/urisc/example/sample.out"
    )(
      input 			   clk,
      
      input [gc::WORD_SIZE - 1:0] 	   add1,
      input [gc::WORD_SIZE - 1:0] 	   dataIn1,
      input 			   write1,
      output reg [gc::WORD_SIZE - 1:0] dataOut1,
      
      input [gc::WORD_SIZE - 1:0] 	   add2,
      input [gc::WORD_SIZE - 1:0] 	   dataIn2,
      input 			   write2,
      output reg [gc::WORD_SIZE - 1:0] dataOut2
      );
   
   reg [gc::WORD_SIZE-1:0] mem [gc::MEM_SIZE - 1:0];

   integer 			   fileID;
   reg [gc::WORD_SIZE-1:0] word;
   integer r;
    
   initial begin
       fileID = $fopen(MEM_FILE,"rb");
              
       for (r = 0; r < gc::MEM_SIZE; r = r+1) begin
         $fread(word,fileID);
         mem[r] = word;
         $display("%h", mem[r]);
       end
   end
   
   always @(posedge clk) begin
       if (write1) begin
	   mem[add1] <= dataIn1;
       end else begin
	   dataOut1 <= mem[add1];
       end
   end
   
   always @(posedge clk) begin
       if (write2) begin
	   mem[add2] <= dataIn2;
       end else begin
	   dataOut2 <= mem[add2];
       end
   end
endmodule // memory

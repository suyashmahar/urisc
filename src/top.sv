module top(clk, rst, hSync, vSync, red, green, blue);
   localparam VGA_I = 0;	// Position of VGA among I/O devices
   
   input clk;			// FPGA on-board clock
   input rst;			// FPGA on-board reset
   
   output hSync, vSync;
   output reg [3-1:0] red, green, blue; // TODO: move '3' to gc

   reg 		      ioClk = 0;

   // IO bus and stuff
   wire [gc::WORD_SIZE-1:0] ioBus;
   wire 		    ioBusDirection;
   wire [WORD_SIZE-1:0]     ioAddress;

   wire [gc::WORD_SIZE-1:0] dataOutArr [IO_COUNT-1:0];
   wire [gc::WORD_SIZE-1:0] memAdd;

   wire [gc::WORD_SIZE-1:0] addressInArr [gc::IO_COUNT-1:0];
   wire [gc::WORD_SIZE-1:0] dataInArr [gc::IO_COUNT-1:0];
   wire [gc::WORD_SIZE-1:0] dataOutArr [gc::IO_COUNT-1:0];
   wire 		    dataValidArr [gc::IO_COUNT-1:0];
   
   vgaWrapper vgaWrapper_inst
     (
      .clk(clk),

      .ioClk(dataValidArr[VGA_I]),
      .memDataRead(dataOutArr[VGA_I]),
      .memReadAdd(addressInArr[VGA_I]),
       
      .hSync(hSync),
      .vSync(vSync),
      .red(red),
      .green(green),
      .blue(blue)
      );
   
   ioArbiter ioArbiter_inst
     (
      .clk(clk), 
      
      .addressInArr(addressInArr),
      .dataInArr(dataInArr),
      .dataOutArr(dataOutArr),
      .dataValidArr(dataValidArr),

      .memData(ioBus),
      .memAdd(ioAddress),
      .memDir(ioBusDirection)
      );
   
   urisc urisc_inst 
     (
      .clk(clk), 
      .rst(rst), 
      
      .ioBus(ioBus), 
      .ioBusDirection(ioBusDirection), 
      .ioAddress(ioAddress)
      );
   
endmodule

import gc::*;

module top(clk_in, rst, hSync, vSync, red, green, blue, kbdClk, kbdDataIn, led);
   localparam VGA_I = 0, PS2_I = 1'b1;	// Position of VGA among I/O devices
   
   input clk_in;			// FPGA on-board clock
   input rst;			// FPGA on-board reset
   input kbdClk, kbdDataIn;
   output hSync, vSync;
   output [16-1:0] led;
   assign led[16-1] = ioClk;
   
   output wire [3-1:0] red, green, blue; // TODO: move '3' to gc

   
   wire clk;
   top_clk top_clk_inst (
        .clk_in(clk_in),
        .clk_out(clk)
   );
   
   // IO bus and stuff
   wire [gc::WORD_SIZE-1:0] ioBus;
   wire 		    ioBusDirection [gc::IO_COUNT-1:0];
   wire [WORD_SIZE-1:0]     ioAddress;

   wire [gc::WORD_SIZE-1:0] dataOutArr [gc::IO_COUNT-1:0];
   wire [gc::WORD_SIZE-1:0] memAdd;

   wire [gc::WORD_SIZE-1:0] addressInArr [gc::IO_COUNT-1:0];
   wire [gc::WORD_SIZE-1:0] dataInArr [gc::IO_COUNT-1:0];
   wire 		    dataValidArr [gc::IO_COUNT-1:0];
   
   wire dataOutArr_unpacked[gc::WORD_SIZE-1:0];
   assign dataOutArr_unpacked = '{dataOutArr[VGA_I][0],  dataOutArr[VGA_I][1],  dataOutArr[VGA_I][2],  dataOutArr[VGA_I][3],  dataOutArr[VGA_I][4],  dataOutArr[VGA_I][5],  dataOutArr[VGA_I][6],  dataOutArr[VGA_I][7],  dataOutArr[VGA_I][8],  dataOutArr[VGA_I][9],  dataOutArr[VGA_I][10],  dataOutArr[VGA_I][11],  dataOutArr[VGA_I][12],  dataOutArr[VGA_I][13],  dataOutArr[VGA_I][14],  dataOutArr[VGA_I][15],  dataOutArr[VGA_I][16], dataOutArr[VGA_I][17],  dataOutArr[VGA_I][18],  dataOutArr[VGA_I][19],  dataOutArr[VGA_I][20],  dataOutArr[VGA_I][21],  dataOutArr[VGA_I][22],  dataOutArr[VGA_I][23],  dataOutArr[VGA_I][24],  dataOutArr[VGA_I][25],  dataOutArr[VGA_I][26],  dataOutArr[VGA_I][27],  dataOutArr[VGA_I][28],  dataOutArr[VGA_I][29],  dataOutArr[VGA_I][30],  dataOutArr[VGA_I][31],  dataOutArr[VGA_I][32],  dataOutArr[VGA_I][33],  dataOutArr[VGA_I][34],  dataOutArr[VGA_I][35],  dataOutArr[VGA_I][36],  dataOutArr[VGA_I][37],  dataOutArr[VGA_I][38],  dataOutArr[VGA_I][39],  dataOutArr[VGA_I][40],  dataOutArr[VGA_I][41],  dataOutArr[VGA_I][42],  dataOutArr[VGA_I][43],  dataOutArr[VGA_I][44],  dataOutArr[VGA_I][45],  dataOutArr[VGA_I][46],  dataOutArr[VGA_I][47],  dataOutArr[VGA_I][48],  dataOutArr[VGA_I][49],  dataOutArr[VGA_I][50],  dataOutArr[VGA_I][51],  dataOutArr[VGA_I][52],  dataOutArr[VGA_I][53],  dataOutArr[VGA_I][54],  dataOutArr[VGA_I][55],  dataOutArr[VGA_I][56],  dataOutArr[VGA_I][57],  dataOutArr[VGA_I][58],  dataOutArr[VGA_I][59],  dataOutArr[VGA_I][60],  dataOutArr[VGA_I][61],  dataOutArr[VGA_I][62],  dataOutArr[VGA_I][63]};
   
   assign ioBusDirection[gc::PS2_I] = gc::IO_IN;
   assign ioBusDirection[gc::VGA_I] = gc::IO_OUT;
      
   vgaWrapper vgaWrapper_inst
     (
      .clk(clk),
      .vgaClk(clk),
      .ioClk(dataValidArr[VGA_I]),
      .memDataRead(dataOutArr_unpacked),
      .memReadAdd(addressInArr[VGA_I]),
       
      .hSync(hSync),
      .vSync(vSync),
      .red(red),
      .green(green),
      .blue(blue)
      );
   /*mojo_top mt_inst (
    .clk(clk),
    .hsync_out(hSync),
    .vsync_out(vSync),
    .red(red),
    .green(green),
    .blue(blue)
   );*/


   ps2Wrapper ps2Wrapper_inst
     (
      .clk(clk),
      .kbdClk(kbdClk),
      .kbdDataIn(kbdDataIn),
      .dataOut(dataInArr[PS2_I]),
      .addOut(addressInArr[PS2_I])
      );

   // Vars for memory bus
   wire 		    memDir;
   wire ioClk;
   ioArbiter ioArbiter_inst
     (
      .clk(ioClk), 
       
      .addressInArr(addressInArr),
      .dataInArr(dataInArr),
      .dataOutArr(dataOutArr),
      .dataValidArr(dataValidArr),
      .dataDirArr(ioBusDirection),
      
      .memData(ioBus),
      .memAdd(ioAddress),
      .memDir(memDir)
      );
   
   urisc urisc_inst 
     (
      .clk(clk), 
      .rst(rst), 
       
      .ioClk(ioClk),
      
      .ioBus(ioBus), 
      .ioBusDirection(memDir), 
      .ioAddress(ioAddress),
      
      .led(led[15-1:0])
      );
   
endmodule

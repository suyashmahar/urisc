module clkFreqDivider #(parameter COUNTER_VAL = 1)(clkIn, clkOut);
   input clkIn;
   output clkOut;

   integer clkCounter = 0;
   reg 	   clkOut = 0;
   
   always @(posedge clkIn) begin
       clkCounter++;
       if (clkCounter == COUNTER_VAL) begin
	   clkOut = ~clkOut;
	   clkCounter = 0;
       end
   end
endmodule

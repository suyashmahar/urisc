module top_clk(clk_in, clk_out);
    input clk_in;
    output reg clk_out;
    
    reg temp = 0;
   
    initial begin
        clk_out = 0;
    end
    
    always @(posedge clk_in) begin
        temp = ~temp;
    end
    
    always @(posedge temp) begin
        clk_out = ~clk_out;
    end
endmodule
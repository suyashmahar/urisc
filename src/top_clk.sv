module top_clk(clk_in, clk_out);
    input clk_in;
    output reg clk_out;
    
    integer counter = 0;
   
    initial begin
        clk_out = 0;
        counter = 0;
    end
    
    always @(posedge clk_in) begin
        counter++;
        if (counter == 2) begin
            counter = 0;
            clk_out = ~clk_out;
        end
    end
endmodule
module clock_divisor(clk, clk_dv);
    parameter n = 22;
    input clk;
    output clk_dv;
    reg [n-1:0] num;
    
    always @(posedge clk) begin
      num = num + 1;
    end
    
    assign clk_dv = num[n-1];
endmodule

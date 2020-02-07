`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/23 23:23:59
// Design Name: 
// Module Name: OP and DB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module onepulse(pb_debounced, clk, pb_1pulse);
    input pb_debounced;
    input clk;
    output pb_1pulse;
    
    reg pb_1pulse;
    reg pb_debounced_delay;
    
    always@(posedge clk) begin
        if(pb_debounced== 1'b1 & pb_debounced_delay==1'b0)
            pb_1pulse <= 1'b1;
        else 
            pb_1pulse <= 1'b0;
        pb_debounced_delay<= pb_debounced;
    end
endmodule

module debounce (pb_debounced, pb, clk);
    output pb_debounced;
    input pb;
    input clk;
    
    reg [3:0] DFF;
    
    always @(posedge clk)
    begin
        DFF[3:1] <= DFF[2:0];
        DFF[0] <= pb;
    end
    assign pb_debounced = ((DFF == 4'b1111) ? 1'b1 : 1'b0);
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/04 01:28:47
// Design Name: 
// Module Name: LED_Controler
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


module LED_Controler(
        input [4:0] state,
        input rst,
        input clk,
        input [8:0]ibeat,
        output reg [15:0]led
    );
    
    reg [15:0]left, right;
    reg left_back, right_back;
    reg [25:0]counter;
    
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            led = 0;
            left = {3'b111, 13'b0};
            right = {13'b0, 3'b111};
            left_back = 0;
            right_back = 0;
            counter = 0;
        end else begin
            case(state)
                7:begin
                    counter = counter + 1;
                    led[0] = left[0] || right[0];
                    led[1] = left[1] || right[1];
                    led[2] = left[2] || right[2];
                    led[3] = left[3] || right[3];
                    led[4] = left[4] || right[4];
                    led[5] = left[5] || right[5];
                    led[6] = left[6] || right[6];
                    led[7] = left[7] || right[7];
                    led[8] = left[8] || right[8];
                    led[9] = left[9] || right[9];
                    led[10] = left[10] || right[10];
                    led[11] = left[11] || right[11];
                    led[12] = left[12] || right[12];
                    led[13] = left[13] || right[13];
                    led[14] = left[14] || right[14];
                    led[15] = left[15] || right[15];
                    
                    
                    if(left == {13'b0, 3'b111}) left_back = 1;
                    if(left == {3'b111, 13'b0}) left_back = 0;
                    if(right == {3'b111, 13'b0}) right_back = 1;
                    if(right == {13'b0, 3'b111}) right_back = 0;
                    
                    if(counter[22] == 1)begin
                        counter = 0;
                        if(left_back == 1) left  = left << 1;
                        else left  = left >> 1;
                        
                        if(right_back == 1) right = right >> 1;
                        else right = right << 1;
                    end
                    
                  end
          default:begin
                    left = {3'b111, 13'b0};
                    right = {13'b0, 3'b111};
                    left_back = 0;
                    right_back = 0;
                    
                    counter = 0;
                    
                    if(ibeat % 4 == 0)begin
                        led = 16'b1111111111111111;
                    end
                    else led = 0;
                  end
            endcase
        end
    end
    
endmodule

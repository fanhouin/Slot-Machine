`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/20 00:27:01
// Design Name: 
// Module Name: main
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

// red = F
// green = 6
// blue = A
module main(
    input sw1,
    input btn,
    input clk,
    input rst,
    input btnu, btnd, btn_exter,
    input coin_5, coin_10,
    output reg [3:0] vgaRed,
    output reg [3:0] vgaGreen,
    output reg [3:0] vgaBlue,
    output hsync,
    output vsync,
    output [15:0]led,
    output audio_mclk, 
    output audio_lrck, 
    output audio_sck, 
    output audio_sdin,
    output [3:0] MotorOutput,
    output [6:0] DISPLAY,
    output [3:0] DIGIT
    );
    parameter v_show_edge = 480/5;
    parameter h_show_edge = 640/7;
    parameter edge_thick = 10;
    parameter h_edge = ((640/7 *6 - edge_thick) - (640/7 + edge_thick))/3;
    parameter h_edge_thick = 5;
    
    reg [4:0]state,bar1_state,bar2_state,bar3_state;
    reg [9:0]position1,position2,position3;
    reg [28:0]counter,counter1,counter2,counter3,counter_1,counter_2,counter_3;
    reg [5:0] v_cnter1,v_cnter2,v_cnter3;
    reg [16:0] pixel_addr,pixel_addr1,pixel_addr2;
    reg [2:0]gamemode;
    reg open, finish;

    
    wire [11:0] data, data1, data2;
    wire clk_25MHz;
    wire clk_22, clk_13;
    wire [11:0] pixel, pixel_1, pixel_2;
    wire valid;
    wire btn_exter_db, btn_exter_op;
    wire [9:0] h_cnt; //640
    wire [9:0] v_cnt;  //480
    wire [11:0] coin;
    
    always@(posedge clk or posedge rst)begin      //video controller
        if(rst)begin
            state = 0;
            bar1_state = 0;
            bar2_state = 0;
            bar3_state = 0;
            gamemode = 0;
            open = 0;
            finish = 0;
        end else begin
            {vgaRed,vgaGreen,vgaBlue} = (valid)? {v_cnt/32,8'h6A} : 12'h0;
            if(v_cnt >= v_show_edge - edge_thick && v_cnt <= v_show_edge*4 + edge_thick)
                if(h_cnt >= h_show_edge - edge_thick && h_cnt <= h_show_edge*6 + edge_thick)
                    {vgaRed,vgaGreen,vgaBlue} = (valid)? 12'h111 : 12'h0;

                if(v_cnt >= v_show_edge + edge_thick && v_cnt <= v_show_edge*4 - edge_thick)
                    if(h_cnt >= h_show_edge + edge_thick && h_cnt <= h_show_edge*6 - edge_thick)begin
                        if(h_cnt >= h_show_edge + edge_thick && h_cnt <= h_show_edge + edge_thick + 140)begin
                            if(gamemode < 3) pixel_addr = {h_cnt - h_show_edge - 10 + 140 * (v_cnt - v_show_edge - 10) + position1*140} % 88200;
                            else pixel_addr = ({h_cnt - h_show_edge - 10 + 140 * (v_cnt - v_show_edge - 10) + position1*140} % 12600) + 88200;
                            {vgaRed,vgaGreen,vgaBlue} = (valid)? pixel : 12'h0;
                        end                    
                        if(h_cnt >= h_show_edge + edge_thick + 145 && h_cnt <= h_show_edge + edge_thick + 285)begin
                            if(gamemode < 2) pixel_addr = {h_cnt - h_show_edge - 10 - 145 + 140 * (v_cnt - v_show_edge - 10) + position2*140} % 88200;
                            else pixel_addr = ({h_cnt - h_show_edge - 10 - 145 + 140 * (v_cnt - v_show_edge - 10) + position2*140} % 12600) + 88200;
                            {vgaRed,vgaGreen,vgaBlue} = (valid)? pixel : 12'h0;
                        end
                        if(h_cnt >= h_show_edge + edge_thick + 290 && h_cnt <= h_show_edge*6 - edge_thick)begin
                            if(gamemode < 1) pixel_addr = {h_cnt - h_show_edge - 10 - 290 + 140 * (v_cnt - v_show_edge - 10) + position3*140} % 88200;
                            else pixel_addr = ({h_cnt - h_show_edge - 10 - 290 + 140 * (v_cnt - v_show_edge - 10) + position3*140} % 12600) + 88200;
                            {vgaRed,vgaGreen,vgaBlue} = (valid)? pixel : 12'h0;
                        end
                    end

            
                if(counter_1[25]==1)begin
                    if(position1 % 90 == 0) bar1_state=0;
                end
            
                if(counter_2[25]==1)begin
                    if(position2 % 90 == 0) bar2_state=0;
                end
                
                if(counter_3[25]==1)begin
                    if(position3 % 90 == 0) bar3_state=0;
                end
                
            case(state)
                0:begin
                    if(btn_exter_op == 1 && coin >= {4'b0000, 4'd1, 4'd5})begin
                        state = 1;
                    end
                    if(sw1)gamemode = 3;
                    else gamemode = 0;
                    counter = 0;
                    open = 0;
                    finish = 0;
                  end
                  
                1:begin
                    counter = counter + 1;
                    bar1_state = 1;
                    if(counter[25] == 1)begin
                        state = 2;
                        counter = 0;
                    end
                  end
                  
                2:begin
                    counter = counter + 1;
                    bar2_state = 1;
                    if(counter[25] == 1)begin
                        state = 3;
                        counter = 0;
                    end
                  end
                  
                3:begin
                    bar3_state = 1;
                    if(btn_exter_op)begin
                        state = 4;
                        bar1_state = 2;
                        if(gamemode != 0)gamemode = gamemode - 1;
                    end
                  end
                
                4:begin
                    if(btn_exter_op)begin
                        state = 5;
                        bar2_state = 2;
                        if(gamemode != 0)gamemode = gamemode - 1;
                    end
                  end
                
                5:begin
                    if(btn_exter_op)begin
                        state = 6;
                        bar3_state = 2;
                        gamemode = 0;
                    end
                  end
                  
                6:begin
                    
                    if(bar1_state == 0 && bar2_state == 0  && bar3_state == 0 )begin
                        if(position1 == position2 && position1 == position3)
                            state = 7;
                        else begin
                            state = 0;
                            finish = 1;
                        end
                    end
                    else state = 6;
                  end
                7:begin
                    counter = counter + 1;
                    if(counter[25]){vgaRed,vgaGreen,vgaBlue} = (valid)? {vgaGreen,vgaBlue,vgaRed} : 12'h0;
                    if(counter[28])begin
                        counter = 0;
                        state = 0;
                        open = 1;
                        finish = 1;
                    end else open = 0;
                  end
            endcase
        end
    end
    
    always@(posedge clk or posedge rst)begin // Bar 1 conterller
        if(rst)begin
            position1 = 0;
        end else begin
            if(bar1_state == 0)begin
                counter1 = 0;
                counter_1 = 0;
            end else if(bar1_state == 1)begin
                counter1 = counter1 + 1;
                if(counter1[17]==1)begin
                    counter1 = 0;
                    if(position1 < 629)
                        position1 = position1 + 1;
                    else position1 = 0;
                end
            end else if(bar1_state == 2)begin
                counter1 = counter1 + 1;
                if(counter_1[25]==0)counter_1 = counter_1 + 1;

                if(counter1[22]==1)begin
                    counter1 = 0;
                    if(position1 < 629)
                        position1 = position1 + 1;
                    else position1 = 0;
                end
             end
        end
    end
    
    always@(posedge clk or posedge rst)begin // Bar 2 conterller
        if(rst)begin
            position2 = 0;
        end else begin
            if(bar2_state == 0)begin
                counter2 = 0;
                counter_2 = 0;
            end else if(bar2_state == 1)begin
                counter2 = counter2 + 1;
                if(counter2[17]==1)begin
                    counter2 = 0;
                    if(position2 < 629)
                        position2 = position2 + 1;
                    else position2 = 0;
                end
            end else if(bar2_state == 2)begin
                counter2 = counter2 + 1;
                if(counter_2[25]==0)counter_2 = counter_2 + 1;
                
                if(counter2[22]==1)begin
                    counter2 = 0;
                    if(position2 < 629)
                        position2 = position2 + 1;
                    else position2 = 0;
                end
            end
        end
    end
    
    always@(posedge clk or posedge rst)begin // Bar 3 conterller
        if(rst)begin
            position3 = 0;
        end else begin
            if(bar3_state == 0)begin
                counter3 = 0;
                counter_3 = 0;
            end else if(bar3_state == 1)begin
                counter3 = counter3 + 1;
                if(counter3[17]==1)begin
                    counter3 = 0;
                    if(position3 < 629)
                        position3 = position3 + 1;
                    else position3 = 0;
                end
            end else if(bar3_state == 2)begin
                counter3 = counter3 + 1;
                if(counter_3[25]==0)counter_3 = counter_3 + 1;
                
                if(counter3[22]==1)begin
                    counter3 = 0;
                    if(position3 < 629)
                        position3 = position3 + 1;
                    else position3 = 0;
                end
            end
        
        end
    end
    
    clock_divisor #(22)clk_dv_1(clk,clk_22);
    clock_divisor #(2)clk_dv_2(clk,clk_25MHz);
    clock_divisor #(17)clk_dv_3(clk,clk_13);
    
    debounce db1(btn_exter_db, btn_exter, clk_13);
    onepulse op1(btn_exter_db, clk, btn_exter_op);
    
    vga_controller   vga_inst(
      .pclk(clk_25MHz),
      .reset(rst),
      .hsync(hsync),
      .vsync(vsync),
      .valid(valid),
      .h_cnt(h_cnt),
      .v_cnt(v_cnt)
    );
    
    blk_mem_gen_0 blk_mem_gen_0_inst(
      .clka(clk_25MHz),
      .wea(0),
      .addra(pixel_addr),
      .dina(data[11:0]),
      .douta(pixel)
    ); 

    speaker sp1(
      .clk(clk), 
      .rst(rst), 
      .audio_mclk(audio_mclk), 
      .audio_lrck(audio_lrck), 
      .audio_sck(audio_sck),
      .audio_sdin(audio_sdin),
      .state(state),
      .led(led) 
    );
    
    motorcon mt1(
        .clk(clk),
        .rst(rst),
        .btn1(btnu),
        .btn2(btnd),
        .open(open),
        .StepDrive(MotorOutput)
        
    );
    
    IRsensor IR1(
        .clk(clk),
        .rst(rst),
        .o_btn(btn_exter_op),
        .exist5(coin_5),
        .exist10(coin_10),
        .DISPLAY(DISPLAY),
        .DIGIT(DIGIT),
        .coin(coin),
        .finish(finish)
    );
endmodule

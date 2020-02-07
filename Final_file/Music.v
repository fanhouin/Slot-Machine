`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:
// Design Name: 
// Module Name:    speaker 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module speaker(
  
  input [4:0]state,
  input clk,  
  input rst, 
  output audio_mclk, 
  output audio_lrck, 
  output audio_sck, 
  output audio_sdin,
  output [15:0]led
);
    
    
    wire [15:0] audio_in_left, audio_in_right;
    wire [8:0] ibeatNum;
    wire [31:0] freq,freq2;
    wire [21:0] freq_out,freq_out2;
    wire clkDiv23;
    wire real_mute;
    
    clock_divisor #(24) clock_23(
        .clk(clk),
        .clk_dv(clkDiv23)
    );
    
    PlayerCtrl playerCtrl_00 ( 
        .clk(clk),
        .reset(rst),
        .ibeat(ibeatNum)
    );
    
    Music music00 ( 
        .ibeatNum(ibeatNum),
        .en(1'b0),
        .tone(freq),
        .tone2(freq2)
    );
    
    assign freq_out = 50000000/freq;
    assign freq_out2 = 50000000/freq2;
    
    
    note_gen Ung(
      .clk(clk),
      .rst(rst),
      .note_div(freq_out),
      .note_div2(freq_out2),
      .audio_left(audio_in_left),
      .audio_right(audio_in_right)
    );
    
    
    speaker_control Usc(
      .clk(clk),
      .rst(rst),
      .audio_in_left(audio_in_left),
      .audio_in_right(audio_in_right),
      .audio_mclk(audio_mclk),
      .audio_lrck(audio_lrck),
      .audio_sck(audio_sck),
      .audio_sdin(audio_sdin)
    );
    
    LED_Controler led1(
        .led(led),
        .state(state),
        .rst(rst),
        .clk(clk),
        .ibeat(ibeatNum)
    );

endmodule

module PlayerCtrl (
	input clk,
	input reset,
	output reg [8:0] ibeat
);
    parameter BEATLEAGTH = 319;
    reg [24:0]counter;
    always @(posedge clk, posedge reset) begin
        if (reset)begin
            ibeat <= 0;
            counter <= 0;
        end else begin
            counter = counter + 1;
            if(counter[23] == 1 && counter[22] == 1)begin
                counter = 0;
                if(ibeat < BEATLEAGTH) begin
                       ibeat <= ibeat + 1;
                end
                else if (ibeat == BEATLEAGTH)begin
                    ibeat <= 0;
                end
                else ibeat <= 0;
            end
        end
    end

endmodule

`define NMCss  32'd1047 // C sharp sharp
`define NMDss  32'd1175 // D sharp sharp
`define NMEss  32'd1319 // E sharp sharp
`define NMCs  32'd524 // C sharp
`define NMDs  32'd588 // D sharp
`define NMEs  32'd660 // E sharp
`define NMFs  32'd698 // F sharp
`define NMGs  32'd784 // G sharp
`define NMAs  32'd880 // A sharp
`define NMBs  32'd988 // B sharp
`define NMC   32'd262 // C
`define NMD   32'd294 // E
`define NME   32'd330 // D
`define NMF   32'd349 // F
`define NMG   32'd392 // G
`define NMA   32'd440 // A
`define NMB   32'd494 // B
`define NMCd   32'd131 // C
`define NMDd   32'd147 // E
`define NMEd   32'd165 // D
`define NMFd   32'd175 // F
`define NMGd   32'd196 // G
`define NMAd   32'd220 // A
`define NMBd   32'd247 // B
`define NM0   32'd50000 //slience (over freq.)



module Music (
	input [8:0] ibeatNum,
	input en,
	output reg [31:0] tone,
	output reg [31:0] tone2
);

    always @(*) begin
        if(en==0)begin
        case(ibeatNum)
        8'd0 :begin tone = `NM0 ; tone2 = `NMAd;	end
        8'd1 :begin tone = `NM0; tone2 = `NMAd;	end
        8'd2 :begin tone = `NM0; tone2 = `NMAd;	end
        8'd3 :begin tone = `NM0; tone2 = `NMAd;	end
        8'd4 :begin tone = `NM0; tone2 = `NMAd;	end
        8'd5 :begin tone = `NM0; tone2 = `NMAd;	end
        8'd6 :begin tone = `NMCs; tone2 = `NMAd;	end
        8'd7 :begin tone = `NMB; tone2 = `NMAd;	end

        8'd8 :begin tone = `NMCs; tone2 = `NMAd;	end
        8'd9 :begin tone = `NMCs; tone2 = `NMAd;	end
        8'd10 :begin tone = `NMCs; tone2 = `NMAd;	end
        8'd11 :begin tone = `NMCs; tone2 = `NMAd;	end
        8'd12 :begin tone = `NME; tone2 = `NM0;	end
        8'd13 :begin tone = `NME; tone2 = `NM0;	end
        8'd14 :begin tone = `NME; tone2 = `NMEd;	end
        8'd15 :begin tone = `NME; tone2 = `NMEd;	end
    ////////////////////////////////////////
               
        8'd16 :begin tone = `NM0; tone2 = `NMFd;	end
        8'd17 :begin tone = `NM0; tone2 = `NMFd;	end
        8'd18 :begin tone = `NM0; tone2 = `NMFd;	end
        8'd19 :begin tone = `NM0; tone2 = `NMFd;	end
        8'd20 :begin tone = `NM0; tone2 = `NMFd;	end
        8'd21 :begin tone = `NM0; tone2 = `NMFd;	end
        8'd22 :begin tone = `NMDs; tone2 = `NMFd;	end
        8'd23 :begin tone = `NMCs; tone2 = `NMFd;	end
               
        8'd24 :begin tone = `NMDs; tone2 = `NMFd;	end
        8'd25 :begin tone = `NMDs; tone2 = `NMFd;	end
        8'd26 :begin tone = `NMCs; tone2 = `NMFd;	end
        8'd27 :begin tone = `NMCs; tone2 = `NMFd;	end
        8'd28 :begin tone = `NMB; tone2 = `NMFd;	end
        8'd29 :begin tone = `NMB; tone2 = `NMFd;	end
        8'd30 :begin tone = `NMB; tone2 = `NMFd;	end
        8'd31 :begin tone = `NMB; tone2 = `NMFd;	end
    /////////////////////////////////// 

        8'd32 :begin tone = `NMB; tone2 = `NMFd;	end
        8'd33 :begin tone = `NMB; tone2 = `NMFd;	end
        8'd34 :begin tone = `NM0; tone2 = `NMDd;	end
        8'd35 :begin tone = `NM0; tone2 = `NMDd;	end
        8'd36 :begin tone = `NM0; tone2 = `NMDd;	end
        8'd37 :begin tone = `NM0; tone2 = `NMDd;	end
        8'd38 :begin tone = `NMDs; tone2 = `NMDd;	end
        8'd39 :begin tone = `NMCs; tone2 = `NMDd;	end

        8'd40 :begin tone = `NMDs; tone2 = `NMDd;	end
        8'd41 :begin tone = `NMDs; tone2 = `NMDd;	end
        8'd42 :begin tone = `NMDs; tone2 = `NMDd;	end
        8'd43 :begin tone = `NMDs; tone2 = `NMDd;	end
        8'd44 :begin tone = `NME; tone2 = `NMDd;	end
        8'd45 :begin tone = `NME; tone2 = `NMDd;	end
        8'd46 :begin tone = `NME; tone2 = `NMDd;	end
        8'd47 :begin tone = `NME; tone2 = `NMDd;	end
    /////////////////////////////
                      
        8'd48 :begin tone = `NM0; tone2 = `NMGd;	end
        8'd49 :begin tone = `NM0; tone2 = `NMGd;	end
        8'd50 :begin tone = `NM0; tone2 = `NMGd;	end
        8'd51 :begin tone = `NM0; tone2 = `NMGd;	end
        8'd52 :begin tone = `NM0; tone2 = `NMGd;	end
        8'd53 :begin tone = `NM0; tone2 = `NMGd;	end
        8'd54 :begin tone = `NMB; tone2 = `NMGd;	end
        8'd55 :begin tone = `NMA; tone2 = `NMGd;	end
                      
        8'd56 :begin tone = `NMB; tone2 = `NMFd;	end
        8'd57 :begin tone = `NMB; tone2 = `NMFd;	end
        8'd58 :begin tone = `NMA; tone2 = `NMFd;	end
        8'd59 :begin tone = `NMA; tone2 = `NMFd;	end
        8'd60 :begin tone = `NMG; tone2 = `NMFd;	end
        8'd61 :begin tone = `NMG; tone2 = `NMFd;	end
        8'd62 :begin tone = `NMB; tone2 = `NMFd;	end
        8'd63 :begin tone = `NMB; tone2 = `NMFd;	end
    ///////////////////////////////
                      
        8'd64 :begin tone = `NMA; tone2 = `NMAd;	end
        8'd65 :begin tone = `NMA; tone2 = `NMAd;	end
        8'd66 :begin tone = `NMA; tone2 = `NMAd;	end
        8'd67 :begin tone = `NMA; tone2 = `NMAd;	end
        8'd68 :begin tone = `NMA; tone2 = `NMAd;	end
        8'd69 :begin tone = `NMA; tone2 = `NMAd;	end
        8'd70 :begin tone = `NMCs; tone2 = `NMAd;	end
        8'd71 :begin tone = `NMB; tone2 = `NMAd;	end
                      
        8'd72 :begin tone = `NMCs; tone2 = `NMAd;	end
        8'd73 :begin tone = `NMCs; tone2 = `NMAd;	end
        8'd74 :begin tone = `NMCs; tone2 = `NMAd;	end
        8'd75 :begin tone = `NMCs; tone2 = `NMAd;	end
        8'd76 :begin tone = `NMF; tone2 = `NMGd;	end
        8'd77 :begin tone = `NMF; tone2 = `NMGd;	end
        8'd78 :begin tone = `NMF; tone2 = `NMGd;	end
        8'd79 :begin tone = `NMF; tone2 = `NMGd;	end
    /////////////////////////////
                      
        8'd80 :begin tone = `NMF; tone2 = `NMFd;	end
        8'd81 :begin tone = `NMF; tone2 = `NMFd;	end
        8'd82 :begin tone = `NM0; tone2 = `NMFd;	end
        8'd83 :begin tone = `NM0; tone2 = `NMFd;	end
        8'd84 :begin tone = `NM0; tone2 = `NMFd;	end
        8'd85 :begin tone = `NM0; tone2 = `NMFd;	end
        8'd86 :begin tone = `NMDs; tone2 = `NMFd;	end
        8'd87 :begin tone = `NMCs; tone2 = `NMFd;	end
                      
        8'd88 :begin tone = `NMDs; tone2 = `NMFd;	end
        8'd89 :begin tone = `NMDs; tone2 = `NMFd;	end
        8'd90 :begin tone = `NMCs; tone2 = `NMFd;	end
        8'd91 :begin tone = `NMCs; tone2 = `NMFd;	end
        8'd92 :begin tone = `NMB; tone2 = `NMFd;	end
        8'd93 :begin tone = `NMB; tone2 = `NMFd;	end
        8'd94 :begin tone = `NMB; tone2 = `NMFd;	end
        8'd95 :begin tone = `NMB; tone2 = `NMFd;	end
    ///////////////////////////////
                      
        8'd96 :begin tone =  `NMB; tone2 = `NMFd;	end
        8'd97 :begin tone =  `NMB; tone2 = `NMFd;	end
        8'd98 :begin tone =  `NM0; tone2 = `NMDd;	end
        8'd99 :begin tone =  `NM0; tone2 = `NMDd;	end
        8'd100 :begin tone = `NM0; tone2 = `NMDd;	end
        8'd101 :begin tone = `NM0; tone2 = `NMDd;	end
        8'd102 :begin tone = `NMDs; tone2 = `NMDd;	end
        8'd103 :begin tone = `NMCs;  tone2 = `NMDd;	end
                       
        8'd104 :begin tone = `NMDs; tone2 = `NMDd;	end
        8'd105 :begin tone = `NMDs; tone2 = `NMDd;	end
        8'd106 :begin tone = `NMDs; tone2 = `NMDd;	end
        8'd107 :begin tone = `NMDs; tone2 = `NMDd;	end
        8'd108 :begin tone = `NMF; tone2 = `NMDd;	end
        8'd109 :begin tone = `NMF; tone2 = `NMDd;	end
        8'd110 :begin tone = `NMF; tone2 = `NMDd;	end
        8'd111 :begin tone = `NMF; tone2 = `NMDd;	end
    ///////////////:// ////////////
                       
        8'd112 :begin tone = `NM0; tone2 = `NMGd;	end
        8'd113 :begin tone = `NM0; tone2 = `NMGd;	end
        8'd114 :begin tone = `NM0; tone2 = `NMGd;	end
        8'd115 :begin tone = `NM0; tone2 = `NMGd;	end
        8'd116 :begin tone = `NM0; tone2 = `NMGd;	end
        8'd117 :begin tone = `NM0; tone2 = `NMGd;	end
        8'd118 :begin tone = `NMB; tone2 = `NMGd;	end
        8'd119 :begin tone = `NMA;  tone2 = `NMGd;	end
                       
        8'd120 :begin tone = `NMB; tone2 = `NMFd;	end
        8'd121 :begin tone = `NMB; tone2 = `NMFd;	end
        8'd122 :begin tone = `NMA; tone2 = `NMFd;	end
        8'd123 :begin tone = `NMA; tone2 = `NMFd;	end
        8'd124 :begin tone = `NMG; tone2 = `NMFd;	end
        8'd125 :begin tone = `NMG; tone2 = `NMFd;	end
        8'd126 :begin tone = `NMB; tone2 = `NMFd;	end
        8'd127 :begin tone = `NMB; tone2 = `NMFd;	end
    ///////////////////////////////---------------
    
        8'd128 :begin tone = `NMA; tone2 = `NMFd;	end
        8'd129 :begin tone = `NMA; tone2 = `NMFd;	end
        8'd130 :begin tone = `NMA; tone2 = `NMFd;	end
        8'd131 :begin tone = `NMA; tone2 = `NMFd;	end
        8'd132 :begin tone = `NMA; tone2 = `NMFd;	end
        8'd133 :begin tone = `NMA; tone2 = `NMFd;	end
        8'd134 :begin tone = `NMCs; tone2 = `NMAd;	end
        8'd135 :begin tone = `NMB;  tone2 = `NMAd;	end
                       
        8'd136 :begin tone = `NMCs; tone2 = `NMAd;	end
        8'd137 :begin tone = `NMCs; tone2 = `NMAd;	end
        8'd138 :begin tone = `NMCs; tone2 = `NMAd;	end
        8'd139 :begin tone = `NMCs; tone2 = `NMAd;	end
        8'd140 :begin tone = `NMF; tone2 = `NMDd;	end
        8'd141 :begin tone = `NMF; tone2 = `NMDd;	end
        8'd142 :begin tone = `NMF; tone2 = `NMDd;	end
        8'd143 :begin tone = `NMF; tone2 = `NMDd;	end
    ///////////////////////////////////////////////////
    
        8'd144 :begin tone = `NMF; tone2 = `NMDd;	end
        8'd145 :begin tone = `NMF; tone2 = `NMDd;	end
        8'd146 :begin tone = `NM0; tone2 = `NMFd;	end
        8'd147 :begin tone = `NM0; tone2 = `NMFd;	end
        8'd148 :begin tone = `NM0; tone2 = `NMFd;	end
        8'd149 :begin tone = `NM0; tone2 = `NMFd;	end
        8'd150 :begin tone = `NMDs; tone2 = `NMFd;	end
        8'd151 :begin tone = `NMCs;  tone2 = `NMFd;	end
                       
        8'd152 :begin tone = `NMDs; tone2 = `NMFd;	end
        8'd153 :begin tone = `NMDs; tone2 = `NMFd;	end
        8'd154 :begin tone = `NMCs; tone2 = `NMFd;	end
        8'd155 :begin tone = `NMCs; tone2 = `NMFd;	end
        8'd156 :begin tone = `NMB; tone2 = `NMFd;	end
        8'd157 :begin tone = `NMB; tone2 = `NMFd;	end
        8'd158 :begin tone = `NMB; tone2 = `NMFd;	end
        8'd159 :begin tone = `NMB; tone2 = `NMFd;	end
    ///////////////////////////////////////////////////
        
        8'd160 :begin tone = `NMB; tone2 = `NMFd;	end
        8'd161 :begin tone = `NMB; tone2 = `NMFd;	end
        8'd162 :begin tone = `NM0; tone2 = `NMDd;	end
        8'd163 :begin tone = `NM0; tone2 = `NMDd;	end
        8'd164 :begin tone = `NM0; tone2 = `NMDd;	end
        8'd165 :begin tone = `NM0; tone2 = `NMDd;	end
        8'd166 :begin tone = `NMDs; tone2 = `NMDd;	end
        8'd167 :begin tone = `NMCs;  tone2 = `NMDd;	end
                       
        8'd168 :begin tone = `NMDs; tone2 = `NMDd;	end
        8'd169 :begin tone = `NMDs; tone2 = `NMDd;	end
        8'd170 :begin tone = `NMDs; tone2 = `NMDd;	end
        8'd171 :begin tone = `NMDs; tone2 = `NMDd;	end
        8'd172 :begin tone = `NMF; tone2 = `NMDd;	end
        8'd173 :begin tone = `NMF; tone2 = `NMDd;	end
        8'd174 :begin tone = `NMF; tone2 = `NMDd;	end
        8'd175 :begin tone = `NMF; tone2 = `NMDd;	end
    ///////////////////////////////////////////////////

        8'd176 :begin tone = `NM0; tone2 = `NMGd;	end
        8'd177 :begin tone = `NM0; tone2 = `NMGd;	end
        8'd178 :begin tone = `NM0; tone2 = `NMGd;	end
        8'd179 :begin tone = `NM0; tone2 = `NMGd;	end
        8'd180 :begin tone = `NM0; tone2 = `NMGd;	end
        8'd181 :begin tone = `NM0; tone2 = `NMGd;	end
        8'd182 :begin tone = `NMB; tone2 = `NMGd;	end
        8'd183 :begin tone = `NMA;  tone2 = `NMGd;	end
                       
        8'd184 :begin tone = `NMB; tone2 = `NMFd;	end
        8'd185 :begin tone = `NMB; tone2 = `NMFd;	end
        8'd186 :begin tone = `NMA; tone2 = `NMFd;	end
        8'd187 :begin tone = `NMA; tone2 = `NMFd;	end
        8'd188 :begin tone = `NMG; tone2 = `NMFd;	end
        8'd189 :begin tone = `NMG; tone2 = `NMFd;	end
        8'd190 :begin tone = `NMB; tone2 = `NMFd;	end
        8'd191 :begin tone = `NMB; tone2 = `NMFd;	end
    ///////////////////////////////////////////////////
    
        8'd192 :begin tone = `NMA; tone2 = `NMAd;	end
        8'd193 :begin tone = `NMA; tone2 = `NMAd;	end
        8'd194 :begin tone = `NMA; tone2 = `NMAd;	end
        8'd195 :begin tone = `NMA; tone2 = `NMAd;	end
        8'd196 :begin tone = `NMA; tone2 = `NMAd;	end
        8'd197 :begin tone = `NMA; tone2 = `NMAd;	end
        8'd198 :begin tone = `NMCs; tone2 = `NMAd;	end
        8'd199 :begin tone = `NMB;  tone2 = `NMAd;	end
                       
        8'd200 :begin tone = `NMCs; tone2 = `NMAd;	end
        8'd201 :begin tone = `NMCs; tone2 = `NMAd;	end
        8'd202 :begin tone = `NMCs; tone2 = `NMAd;	end
        8'd203 :begin tone = `NMCs; tone2 = `NMAd;	end
        8'd204 :begin tone = `NMF; tone2 = `NM0;	end
        8'd205 :begin tone = `NMF; tone2 = `NM0;	end
        8'd206 :begin tone = `NMF; tone2 = `NM0;	end
        8'd207 :begin tone = `NMF; tone2 = `NM0;	end
    ///////////////////////////////////////////////////
    
        208 :begin tone = `NMF; tone2 = `NMEd;	end
        209 :begin tone = `NMF; tone2 = `NMEd;	end
        210 :begin tone = `NM0; tone2 = `NMFd;	end
        211 :begin tone = `NM0; tone2 = `NMFd;	end
        212 :begin tone = `NM0; tone2 = `NMFd;	end
        213 :begin tone = `NM0; tone2 = `NMFd;	end
        214 :begin tone = `NMDs; tone2 = `NMFd;	end
        215 :begin tone = `NMCs;  tone2 = `NMFd;	end
                       
        216 :begin tone = `NMDs; tone2 = `NMFd;	end
        217 :begin tone = `NMDs; tone2 = `NMFd;	end
        218 :begin tone = `NMDs; tone2 = `NMFd;	end
        219 :begin tone = `NMDs; tone2 = `NMFd;	end
        220 :begin tone = `NMB; tone2 = `NMFd;	end
        221 :begin tone = `NMB; tone2 = `NMFd;	end
        222 :begin tone = `NMB; tone2 = `NMFd;	end
        223 :begin tone = `NMB; tone2 = `NMFd;	end
    ///////////////////////////////////////////////////
        
        224 :begin tone = `NMB; tone2 = `NMFd;	end
        225 :begin tone = `NMB; tone2 = `NMFd;	end
        226 :begin tone = `NM0; tone2 = `NMDd;	end
        227 :begin tone = `NM0; tone2 = `NMDd;	end
        228 :begin tone = `NM0; tone2 = `NMDd;	end
        229 :begin tone = `NM0; tone2 = `NMDd;	end
        230 :begin tone = `NMDs; tone2 = `NMDd;	end
        231 :begin tone = `NMCs;  tone2 = `NMDd;	end
                       
        232 :begin tone = `NMDs; tone2 = `NMDd;	end
        233 :begin tone = `NMDs; tone2 = `NMDd;	end
        234 :begin tone = `NMDs; tone2 = `NMDd;	end
        235 :begin tone = `NMDs; tone2 = `NMDd;	end
        236 :begin tone = `NMF; tone2 = `NMDd;	end
        237 :begin tone = `NMF; tone2 = `NMDd;	end
        238 :begin tone = `NMF; tone2 = `NMDd;	end
        239 :begin tone = `NMF; tone2 = `NMDd;	end
    ///////////////////////////////////////////////////
    
        240 :begin tone = `NM0; tone2 = `NMGd;	end
        241 :begin tone = `NM0; tone2 = `NMGd;	end
        242 :begin tone = `NM0; tone2 = `NMGd;	end
        243 :begin tone = `NM0; tone2 = `NMGd;	end
        244 :begin tone = `NM0; tone2 = `NMGd;	end
        245 :begin tone = `NM0; tone2 = `NMGd;	end
        246 :begin tone = `NMB; tone2 = `NMGd;	end
        247 :begin tone = `NMA;  tone2 = `NMGd;	end
                       
        248 :begin tone = `NMB; tone2 = `NMFd;	end
        249 :begin tone = `NMB; tone2 = `NMFd;	end
        250 :begin tone = `NMA; tone2 = `NMFd;	end
        251 :begin tone = `NMA; tone2 = `NMFd;	end
        252 :begin tone = `NMG; tone2 = `NMFd;	end
        253 :begin tone = `NMG; tone2 = `NMFd;	end
        254 :begin tone = `NMB; tone2 = `NMFd;	end
        255 :begin tone = `NMB; tone2 = `NMFd;	end
    ///////////////////////////////////////////////////
    
        256 :begin tone = `NMA; tone2 = `NMAd;	end
        257 :begin tone = `NMA; tone2 = `NMAd;	end
        258 :begin tone = `NMA; tone2 = `NMAd;	end
        259 :begin tone = `NMA; tone2 = `NMAd;	end
        260 :begin tone = `NMA; tone2 = `NMAd;	end
        261 :begin tone = `NMA; tone2 = `NMAd;	end
        262 :begin tone = `NMG; tone2 = `NM0;	end
        263 :begin tone = `NMA;  tone2 = `NM0;	end
                       
        264 :begin tone = `NMB; tone2 = `NM0;	end
        265 :begin tone = `NMB; tone2 = `NM0;	end
        266 :begin tone = `NMB; tone2 = `NM0;	end
        267 :begin tone = `NMB; tone2 = `NM0;	end
        268 :begin tone = `NMB; tone2 = `NM0;	end
        269 :begin tone = `NMB; tone2 = `NM0;	end
        270 :begin tone = `NMA; tone2 = `NM0;	end
        271 :begin tone = `NMB; tone2 = `NM0;	end
    ///////////////////////////////////////////////////
    
        272 :begin tone = `NMCs; tone2 = `NM0;	end
        273 :begin tone = `NMCs; tone2 = `NM0;	end
        274 :begin tone = `NMB; tone2 = `NM0;	end
        275 :begin tone = `NMB; tone2 = `NM0;	end
        276 :begin tone = `NMA; tone2 = `NM0;	end
        277 :begin tone = `NMA; tone2 = `NM0;	end
        278 :begin tone = `NMG; tone2 = `NM0;	end
        279 :begin tone = `NMG;  tone2 = `NM0;	end
                      
        280 :begin tone = `NMF; tone2 = `NM0;	end
        281 :begin tone = `NMF; tone2 = `NM0;	end
        282 :begin tone = `NMF; tone2 = `NM0;	end
        283 :begin tone = `NMF; tone2 = `NM0;	end
        284 :begin tone = `NMDs; tone2 = `NM0;	end
        285 :begin tone = `NMDs; tone2 = `NM0;	end
        286 :begin tone = `NMDs; tone2 = `NM0;	end
        287 :begin tone = `NMDs; tone2 = `NM0;	end
    ///////////////////////////////////////////////////
        
        288 :begin tone = `NMCs; tone2 = `NM0;	end
        289 :begin tone = `NMCs; tone2 = `NM0;	end
        290 :begin tone = `NMCs; tone2 = `NM0;	end
        291 :begin tone = `NMCs; tone2 = `NM0;	end
        292 :begin tone = `NMCs; tone2 = `NM0;	end
        293 :begin tone = `NMCs; tone2 = `NM0;	end
        294 :begin tone = `NM0; tone2 = `NM0;	end
        295 :begin tone = `NMCs;  tone2 = `NM0;	end
                     
        296 :begin tone = `NMCs; tone2 = `NM0;	end
        297 :begin tone = `NMCs; tone2 = `NM0;	end
        298 :begin tone = `NMCs; tone2 = `NM0;	end
        299 :begin tone = `NMDs; tone2 = `NM0;	end
        300 :begin tone = `NMDs; tone2 = `NM0;	end
        301 :begin tone = `NMDs; tone2 = `NM0;	end
        302 :begin tone = `NMCs; tone2 = `NM0;	end
        303 :begin tone = `NMB; tone2 = `NM0;	end
    ///////////////////////////////////////////////////
            
        304 :begin tone = `NMCs; tone2 = `NM0;	end
        305 :begin tone = `NMCs; tone2 = `NM0;	end
        306 :begin tone = `NMCs; tone2 = `NM0;	end
        307 :begin tone = `NMCs; tone2 = `NM0;	end
        308 :begin tone = `NMCs; tone2 = `NM0;	end
        309 :begin tone = `NMCs; tone2 = `NM0;	end
        310 :begin tone = `NMCs; tone2 = `NM0;	end
        311 :begin tone = `NMCs;  tone2 = `NM0;	end
                      
        312 :begin tone = `NMCs; tone2 = `NM0;	end
        313 :begin tone = `NMCs; tone2 = `NM0;	end
        314 :begin tone = `NMCs; tone2 = `NM0;	end
        315 :begin tone = `NMCs; tone2 = `NM0;	end
        316 :begin tone = `NM0; tone2 = `NM0;	end
        317 :begin tone = `NM0; tone2 = `NM0;	end
        318 :begin tone = `NM0; tone2 = `NM0;	end
        319 :begin tone = `NM0; tone2 = `NM0;	end
        
        default : tone = `NM0;
        endcase
        end
        else begin
            tone = `NM0;
        end
    end
endmodule


module note_gen(
  clk, 
  rst, 
  note_div,
  note_div2, 
  audio_left, 
  audio_right
);

    input clk;
    input rst;
    input [21:0] note_div,note_div2;
    output [15:0] audio_left;
    output [15:0] audio_right;
    
    reg [21:0] clk_cnt_next, clk_cnt, clk_cnt_2, clk_cnt_next_2;
    reg b_clk, b_clk_next, c_clk, c_clk_next;

    
    always @(posedge clk or posedge rst)
      if (rst == 1'b1)
      begin
        clk_cnt <= 22'd0;
        clk_cnt_2 <= 22'd0;
        b_clk <= 1'b0;
        c_clk <= 1'b0;
      end
      else
      begin
        clk_cnt <= clk_cnt_next;
        clk_cnt_2 <= clk_cnt_next_2;
        b_clk <= b_clk_next;
        c_clk <= c_clk_next;
      end
      
    always @*
        if (clk_cnt == note_div)
        begin
          clk_cnt_next = 22'd0;
          b_clk_next = ~b_clk;
        end
        else
        begin
          clk_cnt_next = clk_cnt + 1'b1;
          b_clk_next = b_clk;
        end
      
    always @*
            if (clk_cnt_2 == note_div2)
            begin
              clk_cnt_next_2 = 22'd0;
              c_clk_next = ~c_clk;
            end
            else
            begin
              clk_cnt_next_2 = clk_cnt_2 + 1'b1;
              c_clk_next = c_clk;
            end

    
    assign audio_left =  (c_clk == 1'b0) ? 16'h8001 : 16'h7FFF;
    assign audio_right =  (b_clk == 1'b0) ? 16'h8001 : 16'h7FFF;

endmodule

module speaker_control(
  clk,  
  rst,  
  audio_in_left, 
  audio_in_right, 
  audio_mclk, 
  audio_lrck, 
  audio_sck, 
  audio_sdin 
);

    input clk;  
    input rst;  
    input [15:0] audio_in_left; 
    input [15:0] audio_in_right; 
    output audio_mclk; 
    output audio_lrck; 
    output audio_sck; 
    output audio_sdin; 
    reg audio_sdin;
    
    
    wire [8:0] clk_cnt_next;
    reg [8:0] clk_cnt;
    reg [15:0] audio_left, audio_right;
    
    
    assign clk_cnt_next = clk_cnt + 1'b1;
    
    always @(posedge clk or posedge rst)
      if (rst == 1'b1)
        clk_cnt <= 9'd0;
      else
        clk_cnt <= clk_cnt_next;
    
    
    assign audio_mclk = clk_cnt[1];
    assign audio_lrck = clk_cnt[8];
    assign audio_sck = 1'b1; 
    
   
    always @(posedge clk_cnt[8] or posedge rst)
      if (rst == 1'b1)
      begin
        audio_left <= 16'd0;
        audio_right <= 16'd0;
      end
      else
      begin
        audio_left <= audio_in_left;
        audio_right <= audio_in_right;
      end
    
    always @*
      case (clk_cnt[8:4])
        5'b00000: audio_sdin = audio_right[0];
        5'b00001: audio_sdin = audio_left[15];
        5'b00010: audio_sdin = audio_left[14];
        5'b00011: audio_sdin = audio_left[13];
        5'b00100: audio_sdin = audio_left[12];
        5'b00101: audio_sdin = audio_left[11];
        5'b00110: audio_sdin = audio_left[10];
        5'b00111: audio_sdin = audio_left[9];
        5'b01000: audio_sdin = audio_left[8];
        5'b01001: audio_sdin = audio_left[7];
        5'b01010: audio_sdin = audio_left[6];
        5'b01011: audio_sdin = audio_left[5];
        5'b01100: audio_sdin = audio_left[4];
        5'b01101: audio_sdin = audio_left[3];
        5'b01110: audio_sdin = audio_left[2];
        5'b01111: audio_sdin = audio_left[1];
        5'b10000: audio_sdin = audio_left[0];
        5'b10001: audio_sdin = audio_right[15];
        5'b10010: audio_sdin = audio_right[14];
        5'b10011: audio_sdin = audio_right[13];
        5'b10100: audio_sdin = audio_right[12];
        5'b10101: audio_sdin = audio_right[11];
        5'b10110: audio_sdin = audio_right[10];
        5'b10111: audio_sdin = audio_right[9];
        5'b11000: audio_sdin = audio_right[8];
        5'b11001: audio_sdin = audio_right[7];
        5'b11010: audio_sdin = audio_right[6];
        5'b11011: audio_sdin = audio_right[5];
        5'b11100: audio_sdin = audio_right[4];
        5'b11101: audio_sdin = audio_right[3];
        5'b11110: audio_sdin = audio_right[2];
        5'b11111: audio_sdin = audio_right[1];
        default: audio_sdin = 1'b0;
      endcase

endmodule
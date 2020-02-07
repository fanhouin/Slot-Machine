module IRsensor(clk,rst,o_btn,exist5,exist10,DIGIT,DISPLAY,coin,finish);
    input clk;
    input rst;
    input finish;
    input o_btn;
    input exist5;
    input exist10;
    output [6:0] DISPLAY;
    output [3:0] DIGIT;
    output [11:0]coin;
    
    parameter n=26;
    reg [3:0] DIGIT;
    reg [6:0] DISPLAY;
    reg [3:0] value;
    reg [11:0]coin,next_coin;
    reg [n:0]delay,next_delay;
    reg [1:0]state,next_state;
    reg [17:0] num;
    reg state2, state2_next;
    wire [17:0] next_num;
    wire dis_clk;
   
    assign next_num=num+1'b1;
    assign dis_clk=num[17];  

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            coin<=0;
            delay<=0;
            state<=0;
            num<=0;
            state2 <=0;
        end else begin
            coin<=next_coin;
            delay<=next_delay;
            state<=next_state;
            num<=next_num;
            state2<=state2_next;
        end
    end
    
    always@(*)begin
        next_coin=coin;
        next_delay=delay;
        next_state=state;
        state2_next = state2;
            if(state2 == 0)begin
                if(o_btn)begin
                    if(coin[11:8]>0 & ((coin[7:4]==1 & coin[3:0]==0) | (coin[7:4]==0 & coin[3:0]==5) | (coin[7:4]==0 & coin[3:0]==0)))begin
                         state2_next = 1;
                         next_coin[11:8]=coin[11:8]-1;
                         if(coin[7:4]==1 & coin[3:0]==0) begin next_coin[7:4]=9; next_coin[3:0]=5; end
                         else if  (coin[7:4]==0 & coin[3:0]==5) begin next_coin[7:4]=9; next_coin[3:0]=0; end
                         else if  (coin[7:4]==0 & coin[3:0]==0) begin next_coin[7:4]=8; next_coin[3:0]=5; end
                    end else if(!((coin[7:4]==1 & coin[3:0]==0) | (coin[7:4]==0 & coin[3:0]==5) | (coin[7:4]==0 & coin[3:0]==0)))begin
                        if(coin[3:0]==5) begin  next_coin[7:4]=coin[7:4]-1; next_coin[3:0]=0; end
                        else begin next_coin[7:4]=coin[7:4]-2; next_coin[3:0]=5; end
                        state2_next = 1;
                    end
                end
            end 
            else if(state2 == 1)begin
                if(finish == 1) state2_next = 0;
                else state2_next = 1;
            end
        
        case(state)
            0:begin
                if(!exist5)begin//get 5 coin
                    if(coin[11:8]!=9)begin
                        if(coin[3:0]==5)begin
                            if(coin[7:4]==9)begin
                               next_coin[11:8]=coin[11:8]+1;
                               next_coin[7:0]=0; 
                            end else begin
                                next_coin[7:4]=coin[7:4]+1;
                                next_coin[3:0]=0;
                            end
                        end else next_coin=coin+5; 
                        next_state=1;
                    end
                end else if(!exist10) begin//get 10 coin
                    if(coin[11:8]!=9)begin
                        if(coin[7:4]==9)begin
                            next_coin[11:8]=coin[11:8]+1;
                            next_coin[7:4]=0; 
                        end else next_coin[7:4]=coin[7:4]+1; 
                        next_state=1;
                    end
                end
            end
            
            1:begin
                if(delay[n]==1)begin
                    next_delay=0;
                    next_state=0;
                end else next_delay=delay+1;
            end
        endcase
    end
    
    
        always@(posedge dis_clk)begin
        case(DIGIT)
            4'b1110:begin
                DIGIT=4'b1101;
                value=coin[7:4];
            end
            4'b1101:begin
                DIGIT=4'b1011;
                value=coin[11:8];
            end
            4'b1011:begin
                DIGIT=4'b1110;
                value=coin[3:0];
            end
            default:begin
                DIGIT=4'b1101;
                value=coin[7:4];
            end
        endcase
    end
    
    always@(*)begin
        case(value)
            4'd0: DISPLAY=7'b1000000;//O
            4'd1: DISPLAY=7'b1111001;
            4'd2: DISPLAY=7'b0100100;
            4'd3: DISPLAY=7'b0110000;
            4'd4: DISPLAY=7'b0011001;
            4'd5: DISPLAY=7'b0010010;//S
            4'd6: DISPLAY=7'b0000010;//G
            4'd7: DISPLAY=7'b1111000;
            4'd8: DISPLAY=7'b0000000;
            4'd9: DISPLAY=7'b0010000;
            4'd10: DISPLAY=7'b0111111;//rst
            4'd11: DISPLAY=7'b1111111;//null
            4'd12: DISPLAY=7'b1000111;//L
            4'd13: DISPLAY=7'b0000110;//E
            4'd14: DISPLAY=7'b0001000;//A
            default: DISPLAY = 7'b1111111;
        endcase
    end
    
endmodule
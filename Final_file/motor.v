module motor(clk, rst , anglein , StepEnable, Dir, StepDrive);
    input clk; 
    input Dir; 
    input StepEnable; 
    input rst; 
    input [10:0] anglein;
    output[3:0] StepDrive; 
    
    reg[3:0] StepDrive;
    reg[2:0] state; 
    reg[31:0] StepCounter = 32'b0; 
    reg[10:0] angle = 0; 
    parameter[31:0] StepLockOut = 32'd100000;             //250HZ
    reg InternalStepEnable; 

    always @(posedge clk or posedge rst)begin 
        if (rst)begin 
            angle <= 0;
            StepDrive <= 4'b0;
            state <= 3'b0;
            StepCounter <= 32'b0;
        end else begin
            if (StepEnable == 1'b1)    InternalStepEnable <= 1'b1 ; 
  
            StepCounter <= StepCounter + 31'b1; 
            if (StepCounter >= StepLockOut) begin
                StepCounter <= 32'b0 ; 
                if(angle <= anglein) angle <= angle+1;

                if (InternalStepEnable == 1'b1 & angle < anglein) begin
                    //InternalStepEnable <= StepEnable ; 
                    if (Dir == 1'b0)    state <= state + 3'b001 ; 
                    else if (Dir == 1'b1)   state <= state - 3'b001 ; 
                    case (state)
                        3'b000 :    StepDrive <= 4'b0001 ; 
                        3'b001 :    StepDrive <= 4'b0011 ; 
                        3'b010 :    StepDrive <= 4'b0010 ; 
                        3'b011 :    StepDrive <= 4'b0110 ; 
                        3'b100 :    StepDrive <= 4'b0100 ; 
                        3'b101 :    StepDrive <= 4'b1100 ; 
                        3'b110 :    StepDrive <= 4'b1000 ; 
                        3'b111 :    StepDrive <= 4'b1001 ;  
                    endcase 
                end else begin angle <= 0; InternalStepEnable <= 1'b0; end
            end 
         end     
     end

endmodule

module motorcon(clk, rst , btn1, btn2, open, StepDrive);
    input clk; 
    input rst; 
    input btn1;
    input btn2;
    input open;
    output[3:0] StepDrive; 
    
    reg en;
    reg dir;
    reg [10:0] anglein;
    reg [28:0] count;
    reg close;
    wire [3:0] stepdrive;
    wire dis_clk;
    wire d_btn1,d_btn2,o_btn1,o_btn2;
    assign StepDrive=stepdrive;
    
    
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            en = 0;
            dir = 0;
            anglein = 0;
            count = 0;
            close = 0;
        end else begin
            if(open)begin
                en=1; dir=0; anglein=400; close=1;
            end else if(close==1)begin
                if(count[28]==1)begin
                    count=0;
                    en=1; dir=1; anglein=510; close=0;
                end else begin en=0; close=1; count = count + 1;end
            end
            else if(o_btn1) begin en=1; dir=1; anglein=510; end
            else if(o_btn2) begin en=1; dir=0; anglein=400; end
            else en=0;
        end
    end
    debounce dbtn1(.pb(btn1),.clk(dis_clk),.pb_debounced(d_btn1)); 
    onepulse obtn1(.pb_debounced(d_btn1),.clk(clk),.pb_1pulse(o_btn1));
    debounce dbtn2(.pb(btn2),.clk(dis_clk),.pb_debounced(d_btn2)); 
    onepulse obtn2(.pb_debounced(d_btn2),.clk(clk),.pb_1pulse(o_btn2));

    div_clk disclk(clk,dis_clk);
    
    motor motor1(clk, rst , anglein, en, dir, stepdrive);
endmodule

module div_clk (clk,clk_div);
    input clk;
    output clk_div;
    parameter n=17;
    
    wire[n-1:0]next_num;
    reg[n-1:0]num;
    
    always@(posedge clk) begin
        num<=next_num;
    end
    
    assign next_num=num+1'b1;
    assign clk_div=num[n-1];
    
endmodule

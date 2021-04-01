`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/28 18:36:22
// Design Name: 
// Module Name: sorter
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


module sorter(
    input [3:0]x0,
    input [3:0]x1,
    input [3:0]x2,
    input [3:0]x3,
    input clk,
    input rst,
    output reg [3:0]s0,
    output reg [3:0]s1,
    output reg [3:0]s2,
    output reg [3:0]s3,
    output reg done    //排序结果从大到小
    );
    reg [2:0]state;
    reg [2:0]nextstate;
    reg [3:0]a;
    reg [3:0]b;
    
    always @(posedge clk or negedge rst)
    begin
        if(rst)
        begin
            state<=3'b000;
        end
        else
        begin
            state<=nextstate;
        end
    end
    
    always @(*)
    begin
        if(state==0)       nextstate=1;
        else if(state==1)  nextstate=2;
        else if(state==2)  nextstate=3; 
        else if(state==3)  nextstate=4;
        else if(state==4)  nextstate=5;
        else if(state==5)  nextstate=6;
        else if(state==6)  nextstate=6;
    end
    
    always @(posedge clk)
    begin
            if (state==1|state==4|state==6)
            begin
                a=s0;
                b=s1;
            end
            else if (state==2|state==5)
            begin
                 a=s1;
                 b=s2;
            end
            else if (state==3)
            begin
                 a=s2;
                 b=s3;
            end
                              
            case(state)
                 3'b000:
                 begin
                    done<=0;
                    s0<=x0;
                    s1<=x1;
                    s2<=x2;
                    s3<=x3;
                 end 
                 3'b001:
                 begin
                    if(a<b)
                    begin
                        s0<=s1;
                        s1<=s0;
                    end
                 end
                 3'b010:
                 begin
                    if(a<b)
                    begin
                        s1<=s2;
                        s2<=s1;
                    end
                 end
                 3'b011:
                 begin
                    if(a<b)
                    begin
                        s2<=s3;
                        s3<=s2;
                    end
                 end
                 3'b100:
                 begin
                   if(a<b)
                   begin
                       s0<=s1;
                       s1<=s0;
                   end
                end
                3'b101:
                begin
                   if(a<b)
                   begin
                       s1<=s2;
                       s2<=s1;
                   end
                end
                3'b110:
                begin
                   if(a<b)
                   begin
                       s0<=s1;
                       s1<=s0;
                   end
                   done<=1;
                 end
             endcase   
    end  
    
endmodule

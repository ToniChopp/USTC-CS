`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/29 11:30:14
// Design Name: 
// Module Name: divider
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


module divider(
    input [3:0]x,
    input [3:0]y,
    input clk,
    input rst,
    output reg [3:0]q,
    output reg [3:0]r,  //q…Ã r”‡ ˝
    output reg done,
    output reg error
    );
    reg [7:0]X;
    reg [7:0]Y;
    reg [3:0]Z;
    reg [2:0]state;
    reg [2:0]nextstate;
    
    always @(posedge clk, negedge rst)
    begin
        if(rst)
            state<=3'b000;
        else
            state<=nextstate;
    end
    
    always @(*)
    begin
        case(state)
        3'b000: nextstate=3'b001;
        3'b001: nextstate=3'b010;
        3'b010: nextstate=3'b011;
        3'b011: nextstate=3'b100;
        3'b100: nextstate=3'b101;
        3'b101: nextstate=3'b110;
        3'b110: nextstate=3'b111;
        3'b111: nextstate=3'b111;
        endcase
    end
    
    always @(posedge clk)
    begin
    if(y==4'b0000)
    begin
        error=1;
        done=1;
    end
    else
    begin
        case(state)
        3'b000: 
        begin
            X={4'b0000,x};
            Y={y,4'b0000};
            q=4'b0000;
            r=4'b0000;
            done=0;
            error=0;
        end
        3'b001:
        begin
            X<=X+X;
            Z=X[7:4];
            if(Z>=y)
                X<=X-Y+1'b1;
        end
        3'b010:
        begin
            X<=X+X;
            Z=X[7:4];
            if(Z>=y)
                X<=X-Y+1'b1;
        end
        3'b011:
        begin
            X<=X+X;
            Z=X[7:4];
            if(Z>=y)
                 X<=X-Y+1'b1;
        end
        3'b100:
        begin
            X<=X+X;
            Z=X[7:4];
            if(Z>=y)
                 X<=X-Y+1'b1;
        end
         3'b101:
               begin
                   X<=X+X;
                   Z=X[7:4];
                   if(Z>=y)
                        X<=X-Y+1'b1;
               end
          3'b110:
              begin
                  X<=X+X;
                  Z=X[7:4];
                  if(Z>=y)
                        X<=X-Y+1'b1;
              end
          3'b111:
           begin
               q<=X[3:0];
               r<=X[7:4];
               done=1;
           end
        endcase
    end
    end
    
endmodule

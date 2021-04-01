`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/18 21:41:16
// Design Name: 
// Module Name: PCU
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


module PCU(
    input up,
    input left,
    input right,
    input down,
    input clk_5hz,
    input rst,
    input draw,
    input [3:0]R_in,
    input [3:0]G_in,
    input [3:0]B_in,
    output [15:0]a,
    output reg [11:0]data,
    output reg [7:0]x,
    output reg [7:0]y,
    output we
    );
    parameter RST_X=128;
    parameter RST_Y=128;
    wire u,l,r,d,ul,ur,dl,dr;           //控制移动方向
    
    
    assign a=x+256*y;
    assign u=up && ~left && ~right && ~down;          //打表表示实际控制方向，共8个方向
    assign l=~up && left && ~right && ~down;
    assign r=~up && ~left && right && ~down;
    assign d=~up && ~left && ~right && down;
    assign ul=up && left && ~right && ~down;
    assign ur=up && ~left && right && ~down;
    assign dl=~up && left && ~right && down;
    assign dr=~up && ~left && right && down;
    assign we=draw;
    
    always @(posedge clk_5hz or posedge rst)
    begin
        if(rst)
        begin
            x<=RST_X;
            y<=RST_Y;
        end
        else
        begin
            if(u)
            begin
                x<=x;
                y<=(y>0)? (y-1):y;   //碰到边界则无法继续下去
            end
            else if(l)
            begin
                x<=(x>0)? (x-1):x;
                y<=y;
            end
            else if(r)
            begin
                x<=(x<255)? (x+1):x;
                y<=y;
            end
            else if(d)
            begin
                x<=x;
                y<=(y<255)? (y+1):y;
            end
            else if(ul)
            begin
                x<=(x>0)? (x-1):x;
                y<=(y>0)? (y-1):y;
            end
            else if(ur)
            begin
                x<=(x<255)? (x+1):x;
                y<=(y>0)? (y-1):y;
            end
            else if(dl)
            begin
                x<=(x>0)? (x-1):x;
                y<=(y<255)? (y+1):y;
            end
            else if(dr)
            begin
                x<=(x<255)? (x+1):x;
                y<=(y<255)? (y+1):y;
            end
            else
            begin
                x<=x;
                y<=y;
            end
        end
    end
    
    always @(posedge clk_5hz)
    begin
        if(draw)
        begin
            data<={R_in,G_in,B_in};
        end
        else 
        begin
            data<=12'b111111111111;
        end
    end
endmodule

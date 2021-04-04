`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/19 15:51:07
// Design Name: 
// Module Name: Cross
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


module Cross(
    input clk_50mhz,
    input rst,
    input [3:0]R_out,
    input [3:0]G_out,
    input [3:0]B_out,
    input [7:0]x,
    input [7:0]y,
    output [3:0]VGA_R,
    output [3:0]VGA_G,
    output [3:0]VGA_B
    );
    wire is_cross;
    wire is_mark_x,is_mark_y,is_mark;
    wire is_mark_u_x,is_mark_u_y,is_mark_u;
    wire is_mark_l_x,is_mark_l_y,is_mark_l;
    wire is_mark_r_x,is_mark_r_y,is_mark_r;
    wire is_mark_d_x,is_mark_d_y,is_mark_d;
    
    parameter LINE1=272;
    parameter LINE2=528;
    parameter LINE3=800;
    parameter LINE4=856;
    parameter LINE5=976;
    parameter LINE6=1040;
                  
    parameter ROW1=172;
    parameter ROW2=428;
    parameter ROW3=600;
    parameter ROW4=637;
    parameter ROW5=643;
    parameter ROW6=666;
    
    reg [15:0]line;
    reg [15:0]row;
    
    assign is_mark_x=((line>=LINE1-1) && (line<LINE2-1) && (line-LINE1+1==x))? 1:0;    //画十字,先找到中心点
    assign is_mark_y=((row>=ROW1-1) && (row<ROW2-1) && (row-ROW1+1==y))? 1:0;
    assign is_mark=is_mark_x && is_mark_y;
    
    assign is_mark_u_x=((line>=LINE1-1) && (line<LINE2-1) && (line-LINE1+1==x))? 1:0;    //中心点上部
    assign is_mark_u_y=((row>=ROW1) && (row<ROW2-1) && (row-ROW1+1==y-1))? 1:0;
    assign is_mark_u=is_mark_u_x && is_mark_u_y;
    
    assign is_mark_l_x=((line>=LINE1-1) && (line<LINE2-1) && (line-LINE1+1==x-1))? 1:0;    //中心点左部
    assign is_mark_l_y=((row>=ROW1) && (row<ROW2-1) && (row-ROW1+1==y))? 1:0;
    assign is_mark_l=is_mark_l_x && is_mark_l_y;
    
    assign is_mark_r_x=((line>=LINE1-1) && (line<LINE2-1) && (line-LINE1+1==x+1))? 1:0;    //中心点右部
    assign is_mark_r_y=((row>=ROW1) && (row<ROW2-1) && (row-ROW1+1==y))? 1:0;
    assign is_mark_r=is_mark_r_x && is_mark_r_y;
    
    assign is_mark_d_x=((line>=LINE1-1) && (line<LINE2-1) && (line-LINE1+1==x))? 1:0;    //中心点下部
    assign is_mark_d_y=((row>=ROW1) && (row<ROW2-1) && (row-ROW1+1==y+1))? 1:0;
    assign is_mark_d=is_mark_d_x && is_mark_d_y;
    
    assign is_cross=is_mark || is_mark_u || is_mark_l || is_mark_r || is_mark_d;
    
    assign VGA_R=is_cross? 4'b0000:R_out;
    assign VGA_G=is_cross? 4'b0000:G_out;
    assign VGA_B=is_cross? 4'b0000:B_out;
    
    always @(posedge clk_50mhz or posedge rst)
    begin
        if(rst)
        begin
            line<=0;
            row<=0;
        end
        else
        begin
            if(line<LINE6-1)
            begin
                line<=line+1;
                row<=row;
            end
            else if(line==LINE6-1 && row!=ROW6-1)
            begin
                line<=0;
                row<=row+1;
            end
            else if(line==LINE6-1 && row==ROW6-1)
            begin
                line<=0;
                row<=0;
            end
        end
    end
endmodule

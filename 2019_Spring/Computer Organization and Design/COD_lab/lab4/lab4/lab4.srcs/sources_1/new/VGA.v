`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/18 20:18:03
// Design Name: 
// Module Name: VGA
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


module VGA(
    input clk_50mhz,
    input [3:0]R_in,
    input [3:0]G_in,
    input [3:0]B_in,
    input rst,
    output reg [3:0]R_out,
    output reg [3:0]G_out,
    output reg [3:0]B_out,
    output reg HS,
    output reg VS
    );
    reg [15:0]line;
    reg [15:0]row;
    
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
    
    always @(posedge clk_50mhz)
    begin
        if(row<ROW1-1)
        begin
            R_out<=0;
            G_out<=0;
            B_out<=0;
        end
        else if(row>=ROW1-1 && row<ROW2-1)
        begin
            if(line<LINE1-1)
            begin
                R_out<=0;
                G_out<=0;
                B_out<=0;
            end
            else if(line>=LINE1-1 && line<LINE2-1)
            begin
                R_out<=R_in;
                G_out<=G_in;
                B_out<=B_in;
            end
            else 
            begin
                R_out<=0;
                G_out<=0;
                B_out<=0;
            end
        end
        else
        begin
            R_out<=0;
            G_out<=0;
            B_out<=0;
        end
    end
    
    always @(posedge clk_50mhz or posedge rst)
    begin
        if(rst)
            HS<=0;
        else
        begin
            if(line<LINE4-1)
            begin
                HS<=1;
            end
            else if(line>=LINE4-1 && line<LINE5-1)
            begin
                HS<=0;
            end
            else
                HS<=1;
        end
    end
    
    always @(posedge clk_50mhz or posedge rst)
    begin
        if(rst)
            VS<=0;
        else
        begin
            if(row<ROW4-1)
            begin
                VS<=1;
            end
            else if(row>=ROW4-1 && row<ROW5-1)
            begin
                VS<=0;         
            end
            else
                VS<=1;
        end
    end
    
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
                row<=row+1;                        //循环，不出边界
            end
            else if(line==LINE6-1 && row==ROW6-1)
            begin
                line<=0;
                row<=0;
            end
        end
    end
endmodule

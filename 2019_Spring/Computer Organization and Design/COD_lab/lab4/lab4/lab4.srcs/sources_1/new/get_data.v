`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/18 22:13:25
// Design Name: 
// Module Name: get_data
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


module get_address_data(
    input clk_50mhz,
    input rst,
    output reg [15:0]dpra
    );
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
    
    always @(posedge clk_50mhz or posedge rst)
    begin
        if(rst)
        begin
            dpra<=0;
        end
        else
        begin
            if(row<ROW1-1)
            begin
                dpra<=0;
            end
            else if(row>=ROW1-1 && row<ROW2-1)
            begin
                if(line<LINE1-1)
                begin
                    dpra<=0;
                end
                else if(line>=LINE1-1 && line<LINE2-1)
                begin
                    dpra<=(line-LINE1+1)+(row-ROW1+1)*256;
                end
                else
                begin
                    dpra<=0;
                end 
            end
            else
            begin
                dpra<=0;
            end
        end
    end
endmodule

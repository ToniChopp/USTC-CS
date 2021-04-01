`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/18 19:53:47
// Design Name: 
// Module Name: clk_div
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


module clk_div(
    input clk_in,
    input en,
    input rst,
    output reg clk_out
    );
    reg [22:0]cnt;
    
    initial
    begin
        clk_out<=0;
        cnt<=23'b0;
    end
    
    always @(posedge clk_in)
    begin
        if(en)
        begin
            if(rst)
            begin
                clk_out<=0;
                cnt<=23'b0;
            end
            else if(cnt>=23'd49999)
            begin
                clk_out<=~clk_out;
                cnt<=23'b0;
            end
            else
            begin
                cnt<=cnt+23'd1;
            end
        end
    end
endmodule

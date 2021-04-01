`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/17 08:14:26
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
    input cont,
    input step,
    input clk,
    input rst,
    output reg clk_out
);
reg clk_slow;
reg [31:0]cnt;
always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        cnt<=0;
        clk_slow<=0;
    end
    else if(cnt<=32'h200000)
        cnt<=cnt+1;
    else 
    begin
        cnt<=0;
        clk_slow<=~clk_slow;
    end
end
always@(*)
begin
    if(cont==1)
        clk_out=clk_slow;
    else 
        clk_out=step;
    
end
endmodule

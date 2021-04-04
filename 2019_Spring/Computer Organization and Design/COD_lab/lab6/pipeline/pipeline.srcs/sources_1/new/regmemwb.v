`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/25 22:52:35
// Design Name: 
// Module Name: regmemwb
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


module regmemwb(
input clk,
input rst,
input stall,
output reg [70:0]out,
input [70:0]in
);
always@(posedge clk)
begin
    if(rst)
    out<=0;
    else if(stall)
        out<=out;
        else out<=in;
end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/25 18:23:04
// Design Name: 
// Module Name: regifid
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


module regifid(
    input clk,
    input rst,
    input [63:0]in,
    input stall,
    output reg [63:0]out
    );
    always@(posedge clk)
    if(rst)
    out<=96'd0;
    else if(stall)
    out<=out;
    else out<=in;
endmodule

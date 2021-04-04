`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/17 08:45:08
// Design Name: 
// Module Name: RegisterB
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


module RegisterB(
   input clk,
   input [31:0]in,
   output reg [31:0]out
);
always@(posedge clk)
begin
    out<=in;
end
endmodule

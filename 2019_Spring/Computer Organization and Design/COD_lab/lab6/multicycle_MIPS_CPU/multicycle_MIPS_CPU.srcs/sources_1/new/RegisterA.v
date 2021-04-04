`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/17 08:44:00
// Design Name: 
// Module Name: RegisterA
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


module RegisterA(
   input clk,
   input [31:0]in,
   output reg [31:0]out
 );
always@(posedge clk)
begin
   out<=in;
end
endmodule

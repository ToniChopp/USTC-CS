`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/09 17:38:37
// Design Name: 
// Module Name: PCNext
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


module PCNext(
PCSrc, ALUResult, ALUOut, PCJump, nextPC
);

input [1:0] PCSrc;
input [31:0] ALUResult, ALUOut, PCJump;
output [31:0] nextPC;
assign nextPC = PCSrc == 0 ? ALUResult : PCSrc == 1 ? ALUOut : PCJump;

endmodule

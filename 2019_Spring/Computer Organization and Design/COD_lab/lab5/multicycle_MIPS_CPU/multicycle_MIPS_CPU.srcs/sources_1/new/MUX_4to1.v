`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/17 12:19:34
// Design Name: 
// Module Name: MUX_4to1
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


module MUX_4to1(
    input [1:0]AluSrcB,
    input [31:0]in0,
    input [31:0]in2,
    input [31:0]in3,
    output reg [31:0]out
);
always@(*)
begin
    case(AluSrcB)
    2'b 00: out=in0;
    2'b 01: out=4;
    2'b 10: out=in2;
    2'b 11: out=in3;
    endcase
end
endmodule

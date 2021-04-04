`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/17 12:28:25
// Design Name: 
// Module Name: MUX_3to1
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


module MUX_3to1(
    input [1:0]signal,
    input [31:0]in1,
    input [31:0]in2,
    input [31:0]in3,
    output reg [31:0]out
    );
    always@(*)
    begin
       case(signal)
       2'b 00:out=in1;
       2'b 01:out=in2;
       2'b 10: out=in3;
       endcase
    end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/25 21:20:59
// Design Name: 
// Module Name: mux2
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


module mux2(
    input signal,
    input [4:0]in1,
    input [4:0]in2,
    output reg [4:0]out
    );
    always@(*)
    begin
        if(signal==0)
        out=in1;
        else
        out=in2;
    end
endmodule

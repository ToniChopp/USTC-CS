`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/25 21:23:52
// Design Name: 
// Module Name: mux2data
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


module mux2data(
    input signal,
    input [31:0]in1,
    input [31:0]in2,
    output reg [31:0]out
    );
    always@(*)
    begin
        if(signal==0)
        out=in1;
        else out=in2;
    end
endmodule

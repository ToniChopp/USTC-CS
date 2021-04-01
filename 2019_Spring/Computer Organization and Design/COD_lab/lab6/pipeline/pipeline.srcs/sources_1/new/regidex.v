`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/25 20:47:37
// Design Name: 
// Module Name: regidex
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


module regidex(
    input clk,
    input rst,
    input stall,
    output reg [152:0]out,
    input [152:0]in
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

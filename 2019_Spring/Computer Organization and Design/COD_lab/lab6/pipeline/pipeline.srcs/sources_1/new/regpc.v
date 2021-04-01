`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/26 09:09:18
// Design Name: 
// Module Name: regpc
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


module regpc(
input clk,
input rst,
input stall,
input [31:0]in,
output reg [31:0]out
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

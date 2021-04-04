`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/25 14:00:23
// Design Name: 
// Module Name: PC
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


module PC(
    input clk,
    input rst,
    input stall,
    input [31:0]pcnext,
    output reg [31:0]pc
    );
    always @(posedge clk)
    begin
        if(rst)
        pc<=0;
        else if(stall)
        pc<=pc;
        else pc<=pcnext;
    end
    
endmodule

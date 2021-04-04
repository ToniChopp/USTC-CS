`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/17 08:42:35
// Design Name: 
// Module Name: Registers
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


module Registers(
input clk,
input rst,
input RegWrite,
input [4:0]readR1,
input [4:0]readR2,
input [4:0]writeR,
input [31:0]writedata,
output [31:0]readdata1,
output [31:0]readdata2,
input [4:0]addr,
output [31:0]reg_data
);
reg [31:0] regFile [0:31];
integer i;
initial 
begin
    for (i = 0; i < 32; i = i + 1) 
        regFile[i] = 32'b0;
end
assign reg_data=regFile[addr];
always@(posedge clk)
if(rst)
begin
    for (i = 0; i < 32; i = i + 1) regFile[i] = 32'b0;
end
else
begin
    if (RegWrite) regFile[writeR] <= writedata;
end

assign readdata1=regFile[readR1];
assign readdata2=regFile[readR2];
endmodule

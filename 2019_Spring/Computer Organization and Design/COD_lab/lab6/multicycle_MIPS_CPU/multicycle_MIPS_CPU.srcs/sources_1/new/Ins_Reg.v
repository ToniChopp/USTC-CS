`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/17 08:36:24
// Design Name: 
// Module Name: Ins_Reg
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


module Ins_Reg(
input clk,
input IRWrite,
input [31:0]MemData,
output  [5:0]Instruction31_26,
output  [4:0]Instruction25_21,
output [4:0]Instruction20_16,
output [4:0]Instruction15_11,
output  [15:0]Instruction15_0,
output  [5:0]Instruction5_0,
output [25:0]Jaddr
);
reg [31:0]instruction;
always@(posedge clk)
begin
    if(IRWrite)
        instruction<=MemData;
end
IR_Decoder C(instruction,Instruction31_26,Instruction25_21,Instruction20_16,Instruction15_11,Instruction15_0,Instruction5_0,Jaddr);
endmodule

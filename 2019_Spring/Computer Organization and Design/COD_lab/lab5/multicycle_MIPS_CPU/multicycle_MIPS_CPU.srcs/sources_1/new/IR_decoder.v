`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/17 08:38:38
// Design Name: 
// Module Name: IR_decoder
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


module IR_Decoder(
input [31:0]instruction,
output  [5:0]Instruction31_26,
output  [4:0]Instruction25_21,
output [4:0]Instruction20_16,
output [4:0]Instruction15_11,
output  [15:0]Instruction15_0,
output [5:0]Instruction5_0,
output [25:0]Jaddr
    );
    assign Instruction31_26=instruction[31:26];
    assign Instruction25_21=instruction[25:21];
    assign Instruction20_16=instruction[20:16];
    assign Instruction15_11=instruction[15:11];
    assign Instruction15_0=instruction[15:0];
    assign Instruction5_0=instruction[5:0];
    assign Jaddr=instruction[25:0];
endmodule

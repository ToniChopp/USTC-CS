`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/25 14:02:41
// Design Name: 
// Module Name: imem
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


module imem(
  
    input [6:0]addr,
    output [31:0]instr,
    input [6:0]readaddr,
    output [31:0]readdata
    );
    reg [31:0]RAM[172:0];
    initial
    $readmemh("inst_rom.mem",RAM);
    assign instr=RAM[addr];
    assign readdata=RAM[readaddr];
endmodule

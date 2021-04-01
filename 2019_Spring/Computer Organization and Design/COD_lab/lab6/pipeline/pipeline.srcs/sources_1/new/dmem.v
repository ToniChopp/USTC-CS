`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/25 14:53:53
// Design Name: 
// Module Name: dmem
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


module dmem(
    input clk,
    input rst,
    input we,
    input [31:0]writedata,
    input [31:0]addr,
    output [31:0]readdata,
    input [9:0]readaddr,
    output [31:0]outputdata,
    output [31:0]flag
    );
    
    reg [31:0]RAM[127:0];
    initial
    $readmemh("inst_rom.mem",RAM);
    always@(posedge clk)
    begin
        if(we)
        RAM[addr[31:2]]<=writedata;
    end
    assign outputdata=RAM[readaddr];
    assign readdata=RAM[addr[31:2]];
    assign flag=RAM[2];
endmodule

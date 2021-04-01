`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/25 13:15:09
// Design Name: 
// Module Name: pipeline
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


module pipeline(
    input clk,
    input rst,
    input [1:0]choose,
    input [9:0]address,
    output [11:0]led,
    output stallD,
    output stallF,
    output flushD,
    output flushE,
    output [7:0]seg,
    output [7:0]an,
    input step,
    input stop,
    output reg io
    );
    wire [31:0]pc,instdata,writedata,addr,readdata;
    wire [31:0]readdmem,readimem,readreg,flag;
    reg [31:0]showdata;
    wire memwrite,clkreal,disclk;
    assign clkreal=step||(~stop&&disclk);
    assign led=pc[13:2];
    div DIV(clk,disclk);
    CPU mips(clkreal,rst,pc,instdata,memwrite,addr,readdata,writedata,address,readreg,stallD,stallF,flushE,flushD);
    imem i(pc[8:2],instdata,address[6:0],readimem);
    dmem d(clkreal,rst,memwrite,writedata,addr,readdata,address,readdmem,flag);
    always@(*)
    begin
    case(choose)
    2'b 00: showdata=readreg;
    2'b 01: showdata=readimem;
    2'b 10: showdata=readdmem;
    2'b 11: showdata=pc;
    endcase
 end
    display last(clk,showdata,an,seg);
    always@(*)
    if(flag==1)
    io=clk;
    else io=1;
endmodule

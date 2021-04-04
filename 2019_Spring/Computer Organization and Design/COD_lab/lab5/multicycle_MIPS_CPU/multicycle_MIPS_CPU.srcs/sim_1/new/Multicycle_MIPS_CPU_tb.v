`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/17 12:56:04
// Design Name: 
// Module Name: Multicycle_MIPS_CPU_tb
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


module Multicycle_MIPS_CPU_tb(
    );
    reg clk,rst,cont,step,mem;
    reg [7:0]addr;
    wire [7:0]led_pc;
    wire [7:0]led_addr;
    wire [7:0]an;
    wire [7:0]seg;
    DDU DUT(.clk(clk),.rst(rst),.cont(cont),.step(step),.mem(mem),.addr(addr),.led_pc(led_pc),.led_addr(led_addr),.an(an),.seg(seg));
    initial 
    begin 
        #8000 $finish; 
    end
    initial
    begin
        clk=0; rst=0; cont=0; step=0; addr=0; mem=0;  #5
        clk=1; #5
        clk=0; rst=1; #5
        clk=1; #5
        clk=0; cont=1; addr=1; #5
        clk=1; #5
        clk=0; addr=2; #5
        clk=1; #5
        clk=0; addr=3; #5
        clk=1; #5
        clk=0; addr=4; #5
        clk=1; #5
        clk=0; addr=5; #5
        clk=1; #5
        clk=0; addr=6; #5
        clk=1; #5
        clk=0; addr=7; #5
        clk=1; #5
        clk=0; addr=8; #5
        clk=1; #5
        clk=0; addr=9; cont=0; step=1; #5
        clk=1; #5
        clk=0; addr=10; step=0; #5
        clk=1; #5
        clk=0; addr=11; step=1; #5
        clk=1; #5
        clk=0; addr=12; step=0; #5
        clk=1; #5
        clk=0; addr=13; step=1; #5
        clk=1; #5
        clk=0; addr=14; cont=1; mem=1; #5
        clk=1; #5
        clk=0; addr=15; #5
        clk=1; #5
        clk=0; addr=16; #5
        clk=1; #5
        clk=0; addr=17; #5;
    end
endmodule

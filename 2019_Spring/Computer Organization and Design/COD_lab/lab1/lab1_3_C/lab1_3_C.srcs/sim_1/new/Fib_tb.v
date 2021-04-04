`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/22 19:10:45
// Design Name: 
// Module Name: Fib_tb
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


module Fib_tb(
    );
    reg [5:0]f0;
    reg [5:0]f1;
    reg rst;
    reg clk;
    wire [15:0]fn;
    
    lab1_3_C DUT(.f0(f0),.f1(f1),.rst(rst),.clk(clk),.fn(fn));
    
    initial
    begin
        f0=0; f1=1; clk=0; rst=1; #5
        clk=1; #5
        clk=0; rst=0; #5
        clk=1; #5
        clk=0; #5
        clk=1; #5
        clk=0; #5
        clk=1; #5
        clk=0; #5
        clk=1; #5
        clk=0; #5
        clk=1; rst=1; #5;
    end
endmodule

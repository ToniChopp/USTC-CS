`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/12 17:34:36
// Design Name: 
// Module Name: FIFO_tb
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


module FIFO_tb(

    );
    reg [3:0]in;
    reg en_in;
    reg en_out;
    reg clk;
    reg rst;
    wire [3:0]out;
    wire empty;
    wire full;
    
    FIFO DUT(.in(in),.en_in(en_in),.en_out(en_out),.clk(clk),.rst(rst),.out(out),.empty(empty),.full(full));
    
    initial
    begin
        in=2; en_in=1; en_out=0; rst=1; clk=0; #5
        clk=1; #5
        rst=0; clk=0; #5
        clk=1; #5
        in=3; clk=0; #5
        clk=1; #5
        in=4; clk=0; #5
        clk=1; #5
        in=5; clk=0; #5
        clk=1; #5
        in=6; clk=0; #5
        clk=1; #5
        in=7; clk=0; #5
        clk=1; #5
        in=8; clk=0; #5
        clk=1; #5
        in=9; clk=0; #5
        clk=1; #5
        en_in=0; en_out=1; clk=0; #5
        clk=1; #5
        clk=0; #5
        clk=1; #5
        clk=0; #5
        clk=1; #5
        clk=0; #5
        clk=1; #5
        clk=0; #5
        clk=1; #5
        clk=0; #5
        clk=1; #5
        clk=0; #5
        clk=1; #5
        clk=0; #5
        clk=1; #5
        en_in=1; en_out=0; in=6; clk=0; #5
        clk=1; #5
        en_out=1; in=7; clk=0; #5
        clk=1; #5
        in=8; clk=0; #5
        clk=1; #5
        rst=1; clk=0; #5
        clk=1; #5
        rst=0; clk=0; #5
        clk=1; #5
        clk=0; #5
        clk=1; #5
        clk=0; #5
        clk=1; #5
        clk=0; #5;
    end
endmodule

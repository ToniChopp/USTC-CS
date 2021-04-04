`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/11 20:30:23
// Design Name: 
// Module Name: register_file_tb
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


module register_file_tb(
    );
    reg clk;
    reg rst;
    reg we;
    reg [2:0]ra0;  
    reg [2:0]ra1;
    reg [2:0]wa;
    reg [3:0]wd;  
    wire [3:0]rd0;
    wire [3:0]rd1;
    
    Register_file LUT(.clk(clk),.we(we),.rst(rst),.ra0(ra0),.ra1(ra1),.wa(wa),.wd(wd),.rd0(rd0),.rd1(rd1));
    
    initial
    begin
        rst=1; we=0; ra0=0; ra1=1; wa=0; wd=8; clk=0; #5
        clk=1; #5
        rst=0; we=1; clk=0; #5
        clk=1; #5
        clk=0; #5
        clk=1; #5
        clk=0; #5
        clk=1; #5
        rst=0; clk=0; #5
        clk=1; #5
        clk=0; #5
        clk=1; #5
        wa=1; wd=4; clk=0; #5
        clk=1; #5
        clk=0; #5
        clk=1; #5
        we=0; clk=0; #5
        clk=1; #5
        wa=2; wd=6; ra0=2; clk=0; #5
        clk=1; #5
        we=1; clk=0; #5
        clk=1; #5
        clk=0; #5
        clk=1; #5
        clk=0; #5
        clk=1; #5
        clk=0; #5
        clk=1; #5
        rst=1; clk=0; #5
        clk=1; #5
        rst=0; clk=0; #5
        clk=1; #5
        clk=0; #5
        clk=1; #5
        clk=0; #5
        clk=1; #5
        clk=0; #5
        clk=1; #5
        clk=0; #5
        clk=1; #5
        clk=0; #5;
    end
endmodule

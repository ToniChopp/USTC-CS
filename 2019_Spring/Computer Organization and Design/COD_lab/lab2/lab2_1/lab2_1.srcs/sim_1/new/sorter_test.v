`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/28 20:43:27
// Design Name: 
// Module Name: sorter_test
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


module sorter_test(

    );
    reg [3:0]x0;
    reg [3:0]x1;
    reg [3:0]x2;
    reg [3:0]x3;
    reg clk;
    reg rst;
    wire [3:0]s0;
    wire [3:0]s1;
    wire [3:0]s2;
    wire [3:0]s3;
    wire done;
    
    sorter tb(.x0(x0),.x1(x1),.x2(x2),.x3(x3),.clk(clk),.rst(rst),.s0(s0),.s1(s1),.s2(s2),.s3(s3),.done(done));
    
    initial
    begin
        x0=4; x1=11; x2=3; x3=8; clk=0; rst=1; #5
        clk=1; #5
        clk=0; #5
        clk=1; rst=0; #5
        clk=0; rst=0; #5
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
        clk=0; rst=1; #5
        clk=1; #5
        clk=0; #5
        clk=1; rst=0; #5
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
        clk=0; rst=1; #5
        clk=1; #5
        clk=0; #5;
    end
endmodule

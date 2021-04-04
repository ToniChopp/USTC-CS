`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/29 17:29:00
// Design Name: 
// Module Name: divider_tb
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


module divider_tb(

    );
    reg [3:0]x;
    reg [3:0]y;
    reg clk;
    reg rst;
    wire [3:0]q;
    wire [3:0]r;  
    wire done;
    wire error;
    
    divider tb(.x(x),.y(y),.clk(clk),.rst(rst),.q(q),.r(r),.done(done),.error(error));
    
    initial
    begin
        x=11; y=3; clk=0; rst=1;
         #5;
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
        clk=0; #5
        clk=1; #5
        clk=0; #5
        clk=1; #5;
    end
endmodule

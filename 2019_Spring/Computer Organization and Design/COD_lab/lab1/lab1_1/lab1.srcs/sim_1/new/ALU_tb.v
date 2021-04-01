`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/21 20:29:38
// Design Name: 
// Module Name: ALU_tb
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


module ALU_tb(
    );
    reg [5:0]a;
    reg [5:0]b;
    reg [3:0]s;
    wire [5:0]y;
    wire [3:0]f;
    
    lab1_1 tb(.a(a),.b(b),.s(s),.y(y),.f(f));
    
    initial
    begin
        a=16; b=9; s=0; #5
        a=16; b=9; s=1; #5
        a=16; b=9; s=2; #5  
        a=16; b=9; s=3; #5  
        a=16; b=9; s=4; #5  
        a=16; b=9; s=5; #5  
        a=16; b=9; s=6; #5  
        a=10; b=23; s=0; #5
        a=10; b=23; s=1; #5
        a=10; b=23; s=2; #5
        a=10; b=23; s=3; #5
        a=10; b=23; s=4; #5
        a=10; b=23; s=5; #5
        a=10; b=23; s=6; #5;

    end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/22 16:36:09
// Design Name: 
// Module Name: lab1_3_C
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


module lab1_3_C(
    input [5:0]f0,
    input [5:0]f1,
    input rst,
    input clk,
    output wire [15:0]fn
    );
    wire [3:0]s;
    reg [15:0]f2;
    reg [15:0]f3;
    assign s=4'b0001;
    
    ALU FIB(.a(f2),.b(f3),.s(s),.y(fn));
    always @(posedge clk)
    begin
        if(rst)
        begin
            f2<=f0;
            f3<=f1;
        end
        else
        begin
            f2<=f3;
            f3<=fn;
        end
    end 
endmodule

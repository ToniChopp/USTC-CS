`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/11 15:21:47
// Design Name: 
// Module Name: Register_file
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


module Register_file(
    input clk,
    input rst,
    input we,
    input [2:0]ra0,  //m=3  寄存器数量=8
    input [2:0]ra1,
    input [2:0]wa,
    input [3:0]wd,  //n=4 位数
    output [3:0]rd0,
    output [3:0]rd1
    );
    reg [3:0]rf[7:0];
    integer i;
    
    assign rd0=rf[ra0];
    assign rd1=rf[ra1];
    
    always @(posedge clk)
    begin
        if(rst)
        begin
            for(i=0;i<8;i=i+1)
                rf[i]<=4'b0;
        end
        else if(we)
        begin
            rf[wa]<=wd;
        end
    end
endmodule

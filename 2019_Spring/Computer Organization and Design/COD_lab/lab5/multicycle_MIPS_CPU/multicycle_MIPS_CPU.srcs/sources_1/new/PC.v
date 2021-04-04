`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/17 08:32:43
// Design Name: 
// Module Name: PC
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


module PC(
input clk,
input rst,
input PCWrite,
input PCWriteCond1,
input PCWriteCond2,
input Zero,
input [31:0]pcn,
output reg [31:0]pc
    );
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            pc<=0;
        else
        begin
            if(PCWrite||(PCWriteCond1&&Zero)||(PCWriteCond2&&~Zero))
            begin
                pc<=pcn;
            end
         end
     end
endmodule

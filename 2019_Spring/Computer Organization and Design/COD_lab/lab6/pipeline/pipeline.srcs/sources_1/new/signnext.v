`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/25 22:20:10
// Design Name: 
// Module Name: signnext
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


module signnext(
    input [15:0]in,
    input extend,
    output reg [31:0]out
    );
   always@(*)
    if(extend)
        out= { {16{in[15]}},in };
    else
        out= { 16'b0,in };
endmodule

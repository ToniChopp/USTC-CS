`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/09 17:33:22
// Design Name: 
// Module Name: SignedExt
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


module SignedExt(
    input signed [15:0] input_num,
    output signed [31:0] output_num
);
    assign output_num = input_num;
endmodule

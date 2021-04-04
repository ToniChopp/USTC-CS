`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/25 19:01:43
// Design Name: 
// Module Name: CMP
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


module CMP(
    input [2:0]cmp,
    input [31:0]a,
    input [31:0]b,
    input [4:0] rt,
    output reg cmpout
    );
    always@(*)
    case(cmp)
    3'b000:cmpout= (a==b);//beq
    3'b001:cmpout=  (a!=b);//bne
    3'b010:cmpout= (a[31]|(a==0));//blez
    3'b011:cmpout= (~a[31]&(a!=0));//bgtz
    3'b100://bltz,bgez
     case(rt)
     5'b00000:cmpout= a[31];//bltz
     5'b00001:cmpout= ~a[31];//bgez
     default:cmpout=1'bx;
     endcase
    default:cmpout=1'bx;
    endcase
endmodule

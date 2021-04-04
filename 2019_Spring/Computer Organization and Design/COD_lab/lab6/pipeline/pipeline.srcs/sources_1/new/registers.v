`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/25 18:41:12
// Design Name: 
// Module Name: registers
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


module registers(
    input clk,
    input rst,
    input regwrite,
    input [4:0]rs,
    input [4:0]rt,
    input [4:0]rd,
    input [31:0]regdataW,
    output [31:0]read1,
    output [31:0]read2,
    input [4:0]address,
    output [31:0]regdata
    );
    integer i;
    reg [31:0] register[31:0];
    initial 
    begin
        for(i=0;i<32;i=i+1)
        register[i]=32'd0;
    end 
   assign read1=register[rs];
   assign read2=register[rt];
   always@(posedge clk)
   if(rst)
   begin
        for(i=0;i<32;i=i+1)
        register[i]<=0;
   end
   else if(regwrite)
        register[rd]<=regdataW;
   assign regdata=register[address];
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/09 19:21:33
// Design Name: 
// Module Name: DDU
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


module DDU(
    input clk,
    input rst,
    input cont,
    input step,
    input mem,
    input [7:0]addr,
    output [7:0]led_pc,
    output [7:0]led_addr,
    output [7:0]an,
    output [7:0]seg
    );
    wire clk_out,MemWrite;
    wire [31:0]mem_data,reg_data,output_B,MemData;
    wire [7:0]address_out;
    reg inc_1,dec_1;
    assign led_addr=addr;

    clk_div U0(cont,step,clk,rst,clk_out);
    CPU U1(rst,clk_out,reg_data,addr[4:0],led_pc,address_out,MemWrite,MemData,output_B);
    seg_ctrl U2(clk,rst,mem,mem_data,reg_data,an,seg);
    dist_mem_gen_0 U3(.clk(clk_out),.a(address_out),.d(output_B),.we(MemWrite),.dpra(addr),.spo(MemData),.dpo(mem_data));
endmodule
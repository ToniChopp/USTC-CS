`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/12 12:05:54
// Design Name: 
// Module Name: CSR_EX
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


module CSR_EX(
    input wire clk, bubbleE, flushE,
    input wire [11:0] CSR_addr_ID,
    input wire [31:0] CSR_zimm_ID,
    input wire CSR_write_en_ID,
    output reg [11:0] CSR_addr_EX,
    output reg [31:0] CSR_zimm_EX,
    output reg CSR_write_en_EX
    );
    initial
    begin
        CSR_addr_EX = 0;
        CSR_write_en_EX = 0;
        CSR_zimm_EX = 0;
    end    
    always@(posedge clk)
    begin
        if (!bubbleE) 
        begin
            if (flushE)
            begin
                CSR_addr_EX <= 0;
                CSR_write_en_EX <= 0;
                CSR_zimm_EX <= 0;
            end
            else
            begin
                CSR_addr_EX <= CSR_addr_ID;
                CSR_write_en_EX <= CSR_write_en_ID;
                CSR_zimm_EX <= CSR_zimm_ID;
            end
        end
    end
endmodule

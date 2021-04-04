`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/09 17:26:02
// Design Name: 
// Module Name: Regfile
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


module Regfile(    
    input clk,
    input rst,
    input [4:0]addr,
    output [31:0]data,
    input [4:0]r1Addr,
    input [4:0]r2Addr,
    output [31:0]r1Dout,
    output [31:0]r2Dout,
    input [4:0]wAddr,        
    input [31:0]wDin,
    input wEna
    );

    integer i;
    parameter rst_value = 32'h0000_0000;
    
    reg [31:0] regs [31:0];
    
    assign r1Dout = regs[r1Addr];
    assign r2Dout = regs[r2Addr];
    assign data = regs[addr];
    
    always @(posedge clk ,posedge rst) begin
        if (rst) begin
            // reset
            for (i = 0; i < 32; i = i + 1) begin
                regs[i] <= rst_value;
            end
        end else begin
            if (wEna) begin
                regs[wAddr] <= wDin;
            end
        end
    end

endmodule

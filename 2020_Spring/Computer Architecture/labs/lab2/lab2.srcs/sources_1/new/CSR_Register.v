`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: David Wang
// 
// Create Date: 2020/05/10 21:21:37
// Design Name: 
// Module Name: CSR_Register
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


module CSR_Register(
    input wire clk,
    input wire rst,
    input wire write_en,
    input [2:0] func,
    input [11:0] addr,
    input wire [31:0] data,
    output wire [31:0] csr_data
    );

    reg [31:0] csr_reg_file[4095:0];
    
    integer i;
    initial
    begin
        for(i = 1; i < 4096; i = i + 1) 
            csr_reg_file[i][31:0] <= 32'b0;
    end

    always@(posedge clk)
    begin
      if(write_en)
        csr_reg_file[addr] = data;
    end
    assign csr_data = csr_reg_file[addr];
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/10 23:51:34
// Design Name: 
// Module Name: BranchHistory
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


module BranchHistory(
    input clk,
    input rst,
    input br_predict_in,
    input [31:0] pc_in,
    output br_predict_out,
    output [31:0] pc_out
    );

    localparam LEN = 2;
    reg [31:0] pc_buffer [LEN-1:0];
    reg br_predict_buffer [LEN-1:0];
    integer i;

    assign pc_out = pc_buffer[LEN-1];
    assign br_predict_out = br_predict_buffer[LEN-1];

    always @ (posedge clk or posedge rst)
    begin
        if (rst)
        begin
            for (i = 0; i < LEN; i = i+1)
            begin
                pc_buffer[i] <= 0;
                br_predict_buffer[i] <= 0;
            end
        end
        else
        begin
            pc_buffer[0] <= pc_in;
            br_predict_buffer[0] <= br_predict_in;
            for (i = 1; i < LEN; i = i+1)
            begin
                pc_buffer[i] <= pc_buffer[i - 1];
                br_predict_buffer[i] <= br_predict_buffer[i - 1];
            end
        end
    end


endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/09 17:31:14
// Design Name: 
// Module Name: ALU
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


module ALU(
    input signed [31:0]alu_a,
    input signed [31:0]alu_b,
    input [2:0]alu_op,
    output reg [31:0]alu_out,
    output reg zero
    );
    

    always@(*) begin
      case (alu_op)
        1 : alu_out <= alu_a & alu_b;
        0 : alu_out <= alu_a | alu_b;
        2 : alu_out <= alu_a + alu_b;
        3 : alu_out <= alu_a ^ alu_b;
        4  : alu_out <= ~(alu_a | alu_b);
        6 : alu_out <= alu_a - alu_b;
        7 : alu_out <= (alu_a < alu_b)? 1 : 0 ;        
      endcase
      zero<=( alu_a == alu_b)? 1 : 0;
    end

endmodule

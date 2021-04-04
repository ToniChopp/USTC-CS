`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/09 17:34:52
// Design Name: 
// Module Name: ALUDecoder
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


module ALUDecoder(
    input [5:0]opcode,
    input [1:0] ALUOP,
    input [5:0] funct,
    output reg [2:0] ALUControl
);
    
    always@(*) begin
      case(ALUOP)
        0: ALUControl <= 2;
        1: ALUControl <= 6;
        2: 
        begin 
            case (funct)
                6'b100000: ALUControl <= 2;
                6'b100010: ALUControl <= 6;
                6'b100100: ALUControl <= 1;
                6'b100101: ALUControl <= 0;
                6'b100110: ALUControl <= 3;
                6'b100111: ALUControl <= 4;
                6'b101010: ALUControl <= 7;
                default: ALUControl <= 0;
            endcase
        end
        3:
        begin 
            case (opcode)
                6'b001000: ALUControl <= 2;
                6'b001100: ALUControl <= 1;
                6'b001101: ALUControl <= 0;
                6'b001110: ALUControl <= 3;
                6'b001010: ALUControl <= 7;
                default: ALUControl <= 0;
            endcase
        end
        default: ALUControl <= 0;
      endcase
    end

endmodule

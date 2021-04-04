`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: ALU
// Tool Versions: Vivado 2017.4.1
// Description: Arithmetic and logic computation module
// 
//////////////////////////////////////////////////////////////////////////////////

//  鍔熻兘璇存槑
    //  绠楁暟杩愮畻鍜岄?昏緫杩愮畻鍔熻兘閮ㄤ欢
// 杈撳叆
    // op1               绗竴涓搷浣滄暟
    // op2               绗簩涓搷浣滄暟
    // ALU_func          杩愮畻绫诲瀷
// 杈撳嚭
    // ALU_out           杩愮畻缁撴灉
// 瀹為獙瑕佹眰
    // 琛ュ叏妯″潡

`include "Parameters.v"   
module ALU(
    input wire [31:0] op1,
    input wire [31:0] op2,
    input wire [3:0] ALU_func,
    output reg [31:0] ALU_out
    );

    // TODO: Complete this module
    wire [4:0]temp;
    assign temp = op2[4:0];
    always@(*)
    begin
      case(ALU_func)
        `SLL: ALU_out = op1 << temp;
        `SRL: ALU_out = op1 >> temp;
        `SRA: ALU_out = $signed(op1) >>> temp;
        `ADD: ALU_out = op1 + op2;
        `SUB: ALU_out = op1 - op2;
        `XOR: ALU_out = op1 ^ op2;
        `OR:  ALU_out = op1 | op2;
        `AND: ALU_out = op1 & op2;
        `SLT: ALU_out = (op1[31] == op2[31]) ? op1 < op2 : op1 > op2;
        `SLTU: ALU_out = op1 < op2;
        `LUI: ALU_out = op2;
        `OP1:ALU_out = op1;
        `NAND: ALU_out = ~op1 & op2;
        default: ALU_out = 32'b0;
      endcase
    end

endmodule


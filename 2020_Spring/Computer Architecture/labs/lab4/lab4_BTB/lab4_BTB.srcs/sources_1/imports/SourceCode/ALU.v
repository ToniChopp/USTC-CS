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

//  ����˵��
    //  ����������߼����㹦�ܲ���
// ����
    // op1               ��һ��������
    // op2               �ڶ���������
    // ALU_func          ��������
// ���
    // ALU_out           ������
// ʵ��Ҫ��
    // ��ȫģ��

`include "Parameters.v"   
module ALU(
    input wire [31:0] op1,
    input wire [31:0] op2,
    input wire [3:0] ALU_func,
    output reg [31:0] ALU_out
    );
    // finished 
    // TODO: Complete this module
    
    wire signed [31:0] op1_s, op2_s;
    assign op1_s = op1;
    assign op2_s = op2;
    always @ (*)
    begin
        case(ALU_func)
            `SLL: ALU_out = op1 << op2[4:0];
            `SRL: ALU_out = op1 >> op2[4:0];
            `SRA: ALU_out = op1_s >>> op2[4:0];
            `ADD: ALU_out = op1 + op2; 
            `SUB: ALU_out = op1 + ~op2 + 1;
            `XOR: ALU_out = op1 ^ op2;
            `OR: ALU_out = op1 | op2;
            `AND: ALU_out = op1 & op2;
            `SLT: ALU_out = (op1_s < op2_s) ? 32'd1 : 32'd0;
            `SLTU: ALU_out = (op1 < op2) ? 32'd1 : 32'd0;
            `LUI: ALU_out = op2;
            `OP1: ALU_out = op1;
            `NAND: ALU_out = ~op1 & op2;
            default: ALU_out = 32'b0;
        endcase
    end

endmodule


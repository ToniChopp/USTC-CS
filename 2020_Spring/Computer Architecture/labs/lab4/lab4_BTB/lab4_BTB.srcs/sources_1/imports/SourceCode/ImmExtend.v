`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: Immediate Extend
// Tool Versions: Vivado 2017.4.1
// Description: Immediate Extension Module
// 
//////////////////////////////////////////////////////////////////////////////////

//  ����˵��
    //  ��������չ����ָ���е�������������չΪ����������
// ����
    // Inst              ָ���[31:7]
    // ImmType           ����������
// ���
    // imm               ��ȫ��������
// ʵ��Ҫ��
    // ��ȫģ��


`include "Parameters.v"   
module ImmExtend(
    input wire [31:7] inst,
    input wire [2:0] imm_type,
    output reg [31:0] imm
    );

    // finished

    always@(*)
    begin
        case(imm_type)
            `ITYPE: imm = {{21{inst[31]}}, inst[30:20]};
            // TODO: complete left part
            // Parameters.v defines all immediate type
            `STYPE: imm = {{21{inst[31]}}, inst[30:25], inst[11:7]};
            `BTYPE: imm = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
            `UTYPE: imm = {inst[31:12], 12'b0};
            `JTYPE: imm = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:25], inst[24:21], 1'b0};
            default: imm = 32'b0;
        endcase
    end
    
endmodule

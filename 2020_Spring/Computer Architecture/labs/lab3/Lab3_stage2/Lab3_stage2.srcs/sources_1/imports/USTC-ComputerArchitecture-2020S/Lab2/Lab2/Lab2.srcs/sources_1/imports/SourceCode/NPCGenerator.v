`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: NPC Generator
// Tool Versions: Vivado 2017.4.1
// Description: RV32I Next PC Generator
// 
//////////////////////////////////////////////////////////////////////////////////


//  ����˵��
    //  ������ת�źţ�����ִ�е���һ��ָ���ַ
    //  debug�˿�����simulationʱ����д�����ݣ����Ժ���
// ����
    // PC                ָ���ַ��PC + 4, ����PC��
    // jal_target        jal��ת��ַ
    // jalr_target       jalr��ת��ַ
    // br_target         br��ת��ַ
    // jal               jal == 1ʱ����jal��ת
    // jalr              jalr == 1ʱ����jalr��ת
    // br                br == 1ʱ����br��ת
// ���
    // NPC               ��һ��ִ�е�ָ���ַ
// ʵ��Ҫ��  
    // ʵ��NPC_Generator

module NPC_Generator(
    input wire [31:0] PC, jal_target, jalr_target, br_target,
    input wire jal, jalr, br,
    output reg [31:0] NPC
    );
    // finish, priority is considered.
    // TODO: Complete this module
    always @ (*)
    begin
        if (br == 1)
        begin
            NPC = br_target;
        end
        else if (jalr == 1)
        begin
            NPC = jalr_target;
        end
        else if (jal == 1)
        begin
            NPC = jal_target;
        end
        else 
        begin
            NPC = PC;
        end
    end
endmodule
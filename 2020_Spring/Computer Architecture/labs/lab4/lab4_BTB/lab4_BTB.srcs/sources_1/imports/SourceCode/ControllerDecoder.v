`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: Controller Decoder
// Tool Versions: Vivado 2017.4.1
// Description: Controller Decoder Module
// 
//////////////////////////////////////////////////////////////////////////////////

//  ����˵��
    //  ��ָ��������룬���䷭��ɿ����źţ��������������
// ����
    // Inst              ������ָ��
// ���
    // jal               jal��תָ��
    // jalr              jalr��תָ��
    // op2_src           ALU�ĵڶ�����������Դ��Ϊ1ʱ��op2ѡ��imm��Ϊ0ʱ��op2ѡ��reg2
    // ALU_func          ALUִ�е���������
    // br_type           branch���ж������������ǲ�����branch
    // load_npc          д�ؼĴ�����ֵ����Դ��PC����ALU��������, load_npc == 1ʱѡ��PC
    // wb_select         д�ؼĴ�����ֵ����Դ��Cache���ݻ���ALU����������wb_select == 1ʱѡ��cache����
    // load_type         load����
    // src_reg_en        ָ����src reg�ĵ�ַ�Ƿ���Ч��src_reg_en[0] == 1��ʾreg1��ʹ�õ��ˣ�src_reg_en[1]==1��ʾreg2��ʹ�õ���
    // reg_write_en      ͨ�üĴ���дʹ�ܣ�reg_write_en == 1��ʾ��Ҫд��reg
    // cache_write_en    ���ֽ�д��data cache
    // imm_type          ָ��������������
    // op1_src           0��ʾALU������1���ԼĴ�����1��ʾ����PC-4
    // op2_src           0��ʾALU������1���ԼĴ�����1��ʾ����imm
    // alu_src1          alu������1��Դ��alu_src1 == 0��ʾ����reg1��alu_src1 == 1��ʾ����PC
    // alu_src2          alu������2��Դ��alu_src2 == 2'b00��ʾ����reg2��alu_src2 == 2'b01��ʾ����reg2��ַ��alu_src2 == 2'b10��ʾ����������
// ʵ��Ҫ��
    // ��ȫģ��


`include "Parameters.v"   
module ControllerDecoder(
    input wire [31:0] inst,
    output reg jal,
    output reg jalr,
    output reg op1_src, op2_src,
    output reg [3:0] ALU_func,
    output reg [2:0] br_type,
    output reg load_npc,
    output reg wb_select,
    output reg [2:0] load_type,
    output reg reg_write_en,
    output reg [3:0] cache_write_en,
    output reg [2:0] imm_type,
    // CSR signals
    output reg CSR_write_en,
    output reg CSR_zimm_or_reg
    );

    // TODO: Complete this module
    wire [6:0] opcode, funct7;
    wire [2:0] funct3;
    assign opcode = inst[6:0];
    assign funct7 = inst[31:25];
    assign funct3 = inst[14:12];
    always @ (*)
    begin
        if (opcode == `U_LUI)
        begin
            jal = 0;
            jalr = 0;
            op1_src = 0;
            op2_src = 1;
            ALU_func = `LUI;
            br_type = 0;
            load_npc = 0;
            wb_select = 0;
            load_type = 0;
            reg_write_en = 1;
            cache_write_en = 0;
            imm_type = `UTYPE;
            CSR_write_en = 0;
            CSR_zimm_or_reg = 0;
        end
        else if (opcode == `U_AUIPC)
        begin
            jal = 0;
            jalr = 0;
            op1_src = 1;
            op2_src = 1;
            ALU_func = `ADD;
            br_type = 0;
            load_npc = 0;
            wb_select = 0;
            load_type = 0;
            reg_write_en = 1;
            cache_write_en = 0;
            imm_type = `UTYPE;
            CSR_write_en = 0;
            CSR_zimm_or_reg = 0;
        end
        else if (opcode == `J_JAL)
        begin
            jal = 1;
            jalr = 0;
            op1_src = 0;
            op2_src = 0;
            ALU_func = 0;
            br_type = 0;
            load_npc = 1;
            wb_select = 0;
            load_type = 0;
            reg_write_en = 1;
            cache_write_en = 0;
            imm_type = `JTYPE;
            CSR_write_en = 0;
            CSR_zimm_or_reg = 0;
        end
        else if (opcode == `J_JALR)
        begin
            jal = 0;
            jalr = 1;
            op1_src = 0;
            op2_src = 1;
            ALU_func = `ADD;
            br_type = 0;
            load_npc = 1;
            wb_select = 0;
            load_type = 0;
            reg_write_en = 1;
            cache_write_en = 0;
            imm_type = `ITYPE;
            CSR_write_en = 0;
            CSR_zimm_or_reg = 0;
        end
        else if (opcode == `B_TYPE)
        begin
            jal = 0;
            jalr = 0;
            op1_src = 0;
            op2_src = 0;
            ALU_func = 0;
            
            load_npc = 0;
            wb_select = 0;
            load_type = 0;
            reg_write_en = 0;
            cache_write_en = 0;
            imm_type = `BTYPE;
            CSR_write_en = 0;
            CSR_zimm_or_reg = 0;
            if (funct3 == `B_BEQ)
            begin
                br_type = `BEQ;
            end
            else if (funct3 == `B_BNE)
            begin
                br_type = `BNE;
            end
            else if (funct3 == `B_BLT)
            begin
                br_type = `BLT;
            end
            else if (funct3 == `B_BGE)
            begin
                br_type = `BGE;
            end
            else if (funct3 == `B_BLTU)
            begin
                br_type = `BLTU;
            end
            else if (funct3 == `B_BGEU)
            begin
                br_type = `BGEU;
            end
            else 
            begin
                br_type = `NOBRANCH;
            end
        end
        else if (opcode == `I_LOAD)
        begin
            jal = 0;
            jalr = 0;
            op1_src = 0;
            op2_src = 1;
            ALU_func = `ADD;
            br_type = 0;
            load_npc = 0;
            wb_select = 1;
            
            reg_write_en = 1;
            cache_write_en = 0;
            imm_type = `ITYPE;
            CSR_write_en = 0;
            CSR_zimm_or_reg = 0;
            if (funct3 == `I_LB)
            begin
                load_type = `LB;
            end
            else if (funct3 == `I_LH)
            begin
                load_type = `LH;
            end
            else if (funct3 == `I_LW)
            begin
                load_type = `LW;
            end
            else if (funct3 == `I_LBU)
            begin
                load_type = `LBU;
            end
            else if (funct3 == `I_LHU)
            begin
                load_type = `LHU;
            end
            else 
            begin
                reg_write_en = 0;
                load_type = `NOREGWRITE;
            end
        end
        else if (opcode == `I_ARI)
        begin
            jal = 0;
            jalr = 0;
            op1_src = 0;
            op2_src = 1;
            
            br_type = 0;
            load_npc = 0;
            wb_select = 0;
            load_type = 0;
            reg_write_en = 1;
            cache_write_en = 0;
            imm_type = `ITYPE;
            CSR_write_en = 0;
            CSR_zimm_or_reg = 0;
            if (funct3 == `I_ADDI)
            begin
                ALU_func = `ADD;
            end
            else if (funct3 == `I_SLTI)
            begin
                ALU_func = `SLT;
            end
            else if (funct3 == `I_SLTIU)
            begin
                ALU_func = `SLTU;
            end
            else if (funct3 == `I_XORI)
            begin
                ALU_func = `XOR;
            end
            else if (funct3 == `I_ORI)
            begin
                ALU_func = `OR;
            end
            else if (funct3 == `I_ANDI)
            begin
                ALU_func = `AND;
            end
            else if (funct3 == `I_SLLI)
            begin
                ALU_func = `SLL;
            end
            else if (funct3 == `I_SR)
            begin
                if (funct7 == `I_SRAI)
                begin
                    ALU_func = `SRA;
                end
                else if (funct7 ==`I_SRLI)
                begin
                    ALU_func = `SRL;
                end
                else 
                begin
                    reg_write_en = 0;
                    ALU_func = 0;
                end
            end
            else
            begin
                reg_write_en = 0;
                ALU_func = 0;
            end
        end
        else if (opcode == `S_TYPE)
        begin
            jal = 0;
            jalr = 0;
            op1_src = 0;
            op2_src = 1;
            ALU_func = `ADD;
            br_type = 0;
            load_npc = 0;
            wb_select = 0;
            load_type = 0;
            reg_write_en = 0;
            cache_write_en = 1;
            imm_type = `STYPE;
            CSR_write_en = 0;
            CSR_zimm_or_reg = 0;
            if (funct3 == `S_SB)
            begin
                cache_write_en = 4'b0001;
            end
            else if (funct3 == `S_SH)
            begin
                cache_write_en = 4'b0011;
            end
            else if (funct3 == `S_SW)
            begin
                cache_write_en = 4'b1111;
            end
            else 
            begin
                cache_write_en = 4'b0000;
            end
        end
        else if (opcode == `R_TYPE)
        begin
            jal = 0;
            jalr = 0;
            op1_src = 0;
            op2_src = 0;
            ALU_func = 0;
            br_type = 0;
            load_npc = 0;
            wb_select = 0;
            load_type = 0;
            reg_write_en = 1;
            cache_write_en = 0;
            imm_type = 0;
            CSR_write_en = 0;
            CSR_zimm_or_reg = 0;
            if (funct3 == `R_AS)
            begin
                if (funct7 == `R_ADD)
                begin
                    ALU_func = `ADD;
                end
                else if (funct7 == `R_SUB)
                begin
                    ALU_func = `SUB;
                end
                else 
                begin
                    ALU_func = 0;
                    reg_write_en = 0;
                end
            end
            else if (funct3 == `R_SLL)
            begin
                ALU_func = `SLL;
            end
            else if (funct3 == `R_SLT)
            begin
                ALU_func = `SLT;
            end
            else if (funct3 == `R_SLTU)
            begin
                ALU_func = `SLTU;
            end
            else if (funct3 == `R_XOR)
            begin
                ALU_func = `XOR;
            end
            else if (funct3 == `R_SR)
            begin
                if (funct7 == `R_SRL)
                begin
                    ALU_func = `SRL;
                end
                else if (funct7 == `R_SRA)
                begin
                    ALU_func = `SRA;
                end
                else
                begin
                    ALU_func = 0;
                    reg_write_en = 0;
                end
            end
            else if (funct3 == `R_OR)
            begin
                ALU_func = `OR;
            end
            else if (funct3 == `R_AND)
            begin
                ALU_func = `AND;
            end
            else 
            begin
                ALU_func = 0;
                reg_write_en = 0;
            end
        end
        else if (opcode == `I_CSR)
        begin
            jal = 0;
            jalr = 0;
            op1_src = 0;
            op2_src = 0;
            ALU_func = 0;
            br_type = 0;
            load_npc = 0;
            wb_select = 0;
            load_type = 0;
            reg_write_en = 1;
            cache_write_en = 0;
            imm_type = 0;
            CSR_write_en = 1;
            
            if (funct3 == `I_CSRRC)
            begin
                 ALU_func = `NAND;
                 CSR_zimm_or_reg = 0;
            end
            else if (funct3 == `I_CSRRCI)
            begin
                 ALU_func = `NAND;
                 CSR_zimm_or_reg = 1;
            end
            else if (funct3 == `I_CSRRS)
            begin
                ALU_func = `OR;
                CSR_zimm_or_reg = 0;
            end
            else if (funct3 == `I_CSRRSI)
            begin
                ALU_func = `OR;
                CSR_zimm_or_reg = 1;
            end
            else if (funct3 == `I_CSRRW)
            begin
                ALU_func = `OP1;
                CSR_zimm_or_reg = 0;
            end
            else if (funct3 == `I_CSRRWI)
            begin
                ALU_func = `OP1;
                CSR_zimm_or_reg = 1;
            end
            else 
            begin
                ALU_func = 0;
                CSR_zimm_or_reg = 0;
                CSR_write_en = 0;
                reg_write_en = 0;
            end
        end
        else 
        begin
            jal = 0;
            jalr = 0;
            op1_src = 0;
            op2_src = 0;
            ALU_func = 0;
            br_type = 0;
            load_npc = 0;
            wb_select = 0;
            load_type = 0;
            reg_write_en = 0;
            cache_write_en = 0;
            imm_type = 0;
            CSR_write_en = 0;
            CSR_zimm_or_reg = 0;
        end
    end
    

endmodule
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

//  功能说明
    //  对指令进行译码，将其翻译成控制信号，传输给各个部件
// 输入
    // Inst              待译码指令
// 输出
    // jal               jal跳转指令
    // jalr              jalr跳转指令
    // op2_src           ALU的第二个操作数来源。为1时，op2选择imm，为0时，op2选择reg2,2 为CSR的结果
    // ALU_func          ALU执行的运算类型
    // br_type           branch的判断条件，可以是不进行branch
    // load_npc          写回寄存器的值的来源（PC或者ALU计算结果）, load_npc == 1时选择PC
    // wb_select         写回寄存器的值的来源（Cache内容或者ALU计算结果），wb_select == 1时选择cache内容
    // load_type         load类型
    // src_reg_en        指令中src reg的地址是否有效，src_reg_en[1] == 1表示reg1被使用到了，src_reg_en[0]==1表示reg2被使用到了
    // reg_write_en      通用寄存器写使能，reg_write_en == 1表示需要写回reg
    // cache_write_en    按字节写入data cache
    // imm_type          指令中立即数类型
    // alu_src1          alu操作数1来源，alu_src1 == 0表示来自reg1，alu_src1 == 1表示来自PC
    // alu_src2          alu操作数2来源，alu_src2 == 2'b00表示来自reg2，alu_src2 == 2'b01表示来自reg2地址，alu_src2 == 2'b10表示来自立即数或者CSR
    //csr_src            0对应为立即数，1对应为reg1
// 实验要求
    // 补全模块


`include "Parameters.v"   
module ControllerDecoder(
    input wire [31:0] inst,
    output reg jal,
    output reg jalr,
    output reg [1:0]op2_src,
    output reg [3:0] ALU_func,
    output reg [2:0] br_type,
    output reg load_npc,
    output reg wb_select,
    output reg [2:0] load_type,
    output reg [1:0] src_reg_en,
    output reg reg_write_en,
    output reg [3:0] cache_write_en,
    output reg alu_src1,
    output reg [1:0] alu_src2,
    output reg [2:0] imm_type,
    output reg csr_src,
    output [2:0]csr_type,
    output [11:0] csr_addr,
    output  reg csr_en
    );

    wire [6:0] opcode;
    wire [2:0] func;
    
    assign opcode = inst[6:0];
    assign func = inst[14:12];
    assign csr_type = func;
    assign csr_addr = inst[31:20];
always @(*)
begin
    case(opcode) 
        7'b 0010011:                // I-type
        begin
            if(inst==8'h00000013)       // nop
            begin
                jal = 0;
                jalr = 0;
                op2_src = 2'd1;
                br_type = `NOBRANCH;
                load_npc =  0;
                wb_select = 0;
                load_type = `NOREGWRITE;
                src_reg_en = 2'b00;
                reg_write_en = 1;
                load_type = 0; // 不需要读入
                cache_write_en = 4'b0;
                alu_src1 = 0;
                alu_src2 = 2'b10;
                imm_type = `ITYPE;
                ALU_func = `ADD;
                alu_src2 = 2'b10;
                csr_src = 0;
                csr_en = 0;
            end
            else 
            begin
                jal = 0;
                jalr = 0;
                op2_src = 2'd1;
                br_type = `NOBRANCH;
                load_npc =  0;
                wb_select = 0;
                load_type = `NOREGWRITE;
                src_reg_en = 2'b10;
                reg_write_en = 1;
                load_type = 0; // 不需要读入
                cache_write_en = 4'b0;
                alu_src1 = 0;
                alu_src2 = 2'b10;
                imm_type = `ITYPE;
                case(func)
                    3'b000: begin ALU_func = `ADD;  alu_src2 = 2'b10; end
                    3'b001: begin  ALU_func = `SLL;   alu_src2 = 2'b01; end   
                    3'b010: begin ALU_func = `SLT;  alu_src2 = 2'b10; end
                    3'b011: begin ALU_func = `SLTU;  alu_src2 = 2'b10; end
                    3'b100: begin ALU_func = `XOR;  alu_src2 = 2'b10; end
                    3'b101:  
                    begin 
                        if  (inst[30]) 
                        begin
                            ALU_func = `SRA;   
                            alu_src2 = 2'b01;  
                        end 
                        else  
                        begin 
                            ALU_func = `SRL;  
                            alu_src2 = 2'b01; 
                        end
                    end
                    3'b110:
                    begin  
                        ALU_func = `OR;  
                        alu_src2 = 2'b10; 
                    end
                    3'b111:
                    begin  
                        ALU_func = `AND;  
                        alu_src2 = 2'b10; 
                    end
                endcase
                csr_src = 0;
                csr_en = 0;
            end
        end
        7'b 0110011:              // R-type
        begin
            jal = 0;
            jalr = 0;
            op2_src = 2'd0;
            br_type = `NOBRANCH;
            load_npc =  0;
            wb_select = 0;
            load_type = `NOREGWRITE;
            src_reg_en = 2'b11;
            reg_write_en = 1;
            load_type = 0;               // 不需要读入
            cache_write_en = 4'b0;
            alu_src1 = 0;
            alu_src2 = 2'b00;
            imm_type = `RTYPE;
            case(func)
                3'b000: 
                begin 
                    if (inst[30] == 1) 
                        ALU_func = `SUB; 
                    else 
                        ALU_func = `ADD; 
                end
                3'b001: ALU_func = `SLL;
                3'b010: ALU_func = `SLT;
                3'b011: ALU_func = `SLTU;
                3'b100: ALU_func = `XOR;
                3'b101: 
                begin 
                    if (inst[30]) 
                        ALU_func = `SRA; 
                    else 
                        ALU_func = `SRL;
                end
                3'b110: ALU_func = `OR;
                3'b111: ALU_func = `AND;
            endcase
            csr_src = 0;
            csr_en = 0;
        end
        7'b 0110111:                  // LUI
        begin
            jal = 0;
            jalr = 0;
            op2_src = 2'd1;
            br_type = `NOBRANCH;
            load_npc =  0;
            wb_select = 0;
            load_type = 0;
            src_reg_en = 2'b00;
            reg_write_en = 1;
            load_type = `NOREGWRITE;   // 不需要读入
            cache_write_en = 4'b0;
            alu_src1 = 0;
            alu_src2 = 2'b10;
            imm_type = `UTYPE;
            ALU_func = `LUI; 
            csr_src = 0;
            csr_en = 0;
        end
        7'b 0010111:               // AUIPC
        begin
            jal = 0;
            jalr = 0;
            op2_src = 2'd1;
            br_type = `NOBRANCH;
            load_npc =  0;
            wb_select = 0;
            load_type = 0;
            src_reg_en = 2'b00;
            reg_write_en = 1;
            load_type = `NOREGWRITE;     // 不需要读入
            cache_write_en = 4'b0;
            alu_src1 = 1;
            alu_src2 = 2'b10;
            imm_type = `UTYPE;
            ALU_func = `ADD;
            csr_src = 0; 
            csr_en = 0;
        end
        7'b 1100111:              // JALR
        begin
            jal = 0;
            jalr = 1;
            op2_src = 2'd1;
            br_type = `NOBRANCH;
            load_npc =  1;
            wb_select = 0;
            load_type = 0;
            src_reg_en = 2'b10;
            reg_write_en = 1;
            load_type = `NOREGWRITE;        // 不需要读入
            cache_write_en = 4'b0;
            alu_src1 = 0;
            alu_src2 = 2'b10;
            imm_type = `ITYPE;
            ALU_func = `ADD;
            csr_src = 0; 
            csr_en = 0;
        end
        7'b 1101111:          // JAL
        begin
            jal = 1;
            jalr = 0;
            op2_src = 2'd1;
            br_type = `NOBRANCH;
            load_npc = 1;
            wb_select = 0;
            src_reg_en = 2'b00;
            reg_write_en = 1;
            load_type = `NOREGWRITE;
            cache_write_en = 4'b0;
            alu_src1 = 0;              //no matter
            alu_src2 = 2'b 10;         //no matter
            imm_type = `JTYPE;
            ALU_func = `ADD;           //no matter
            csr_src = 0;
            csr_en = 0;
        end
        7'b 1100011:             // BR
        begin
            jal = 0;
            jalr = 0;
            op2_src = 2'd1;
            case(func)
                3'b000: br_type = `BEQ;
                3'b001: br_type = `BNE;
                3'b100: br_type = `BLT;
                3'b101: br_type = `BGE;
                3'b110: br_type = `BLTU;
                3'b111: br_type = `BGEU;
            endcase
            load_npc = 0;             //no matter
            wb_select = 0;           // no matter
            src_reg_en = 2'b11;
            reg_write_en =0;
            load_type = `NOREGWRITE;
            cache_write_en = 4'b0;
            alu_src1 = 0;             //no matter
            alu_src2 = 2'b 10;        //no mattter
            imm_type = `BTYPE;
            ALU_func = `ADD;          //no matter
            csr_src = 0;
            csr_en = 0;
        end
        7'b 0000011:            // L-type
        begin
            jal = 0;
            jalr = 0;
            op2_src = 2'd1;            // imm
            br_type = `NOBRANCH;
            load_npc = 0;
            wb_select = 1;
            src_reg_en = 2'b10;
            reg_write_en = 1;
            case(func)
                3'b000: load_type =`LB;
                3'b001: load_type =`LH;
                3'b010: load_type =`LW;
                3'b100: load_type =`LBU;
                3'b101: load_type =`LHU;
            endcase
            cache_write_en = 4'b0;
            alu_src1 = 0;
            alu_src2 = 2'b10;
            imm_type = `ITYPE;
            ALU_func = `ADD;
            csr_src = 0;
            csr_en = 0;
        end
        7'b 0100011:                 // S-type
        begin  
            jal = 0;
            jalr = 0;
            op2_src = 2'd1;
            br_type = `NOBRANCH;
            load_npc = 0;
            wb_select = 0;            //no matter
            src_reg_en =2'b10;
            reg_write_en = 0;
            load_type = `NOREGWRITE;
            case(func)
                3'b000:cache_write_en = 4'b0001;    // SB
                3'b001:cache_write_en = 4'b0011;    // SH
                3'b010:cache_write_en = 4'b1111;    // SW
            endcase
            alu_src1 = 0;
            alu_src2 = 2'b10;
            imm_type = `STYPE;
            ALU_func = `ADD;
            csr_src = 0;
            csr_en = 0;
        end
        7'b 1110011:            // CSR
        begin
            jal = 0;
            jalr = 0;
            op2_src = 2'd2;
            br_type = `NOBRANCH;
            load_npc = 0;
            wb_select = 0;
            if(func == 3'b001)
            begin
                src_reg_en =2'b00;          
                csr_src = 1;
                ALU_func = `OP1;
            end
            else if(func == 3'b010)
            begin
                src_reg_en = 2'b00;
                csr_src = 1;
                ALU_func = `OR;
            end
            else if(func == 3'b011)
            begin
                src_reg_en = 2'b00;
                csr_src = 1;
                ALU_func = `NAND;
            end
            else if(func == 3'b101)
            begin
                src_reg_en =2'b10;
                csr_src = 0;
                ALU_func =  `OP1;
            end
            else if(func == 3'b110)
            begin
                src_reg_en =2'b10;
                csr_src = 0;
                ALU_func =  `OR;
            end
            else if(func == 3'b111)
            begin
                src_reg_en =2'b10;
                csr_src = 0;
                ALU_func =  `NAND;
            end
            reg_write_en = 1;
            load_type = `NOREGWRITE;
            cache_write_en = 4'b0;
            alu_src1 = 0;             // no matter
            alu_src2 = 2'b10;
            imm_type = `CSRTYPE;
            csr_en = 1;
        end
        default:
        begin
            jal = 0;
            jalr = 0;
            op2_src = 2'd2;
            br_type = `NOBRANCH;
            load_npc = 0;
            wb_select = 0;
            src_reg_en =2'b00;
            csr_src = 0;
            reg_write_en = 0;
            load_type = `NOREGWRITE;
            cache_write_en = 4'b0;
            alu_src1 = 0;           // no matter
            alu_src2 = 2'b10;
            imm_type = `ITYPE;
            ALU_func = `ADD;
            csr_en = 0;
        end
    endcase
end
endmodule

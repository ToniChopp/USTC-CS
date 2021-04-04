`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: Hazard Module
// Tool Versions: Vivado 2017.4.1
// Description: Hazard Module is used to control flush, bubble and bypass
// 
//////////////////////////////////////////////////////////////////////////////////

//  功能说明
    //  识别流水线中的数据冲突，控制数据转发，和flush、bubble信号
// 输入
    // rst               CPU的rst信号
    // reg1_srcD         ID阶段的源reg1地址
    // reg2_srcD         ID阶段的源reg2地址
    // reg1_srcE         EX阶段的源reg1地址
    // reg2_srcE         EX阶段的源reg2地址
    // reg_dstE          EX阶段的目的reg地址
    // reg_dstM          MEM阶段的目的reg地址
    // reg_dstW          WB阶段的目的reg地址
    // br                是否branch
    // jalr              是否jalr
    // jal               是否jal
    // src_reg_en        指令中的源reg1和源reg2地址是否有效
    // wb_select         写回寄存器的值的来源（Cache内容或者ALU计算结果） LD需要暂停 wb_select == 1时选择cache内容
    // reg_write_en_MEM  MEM阶段的寄存器写使能信号
    // reg_write_en_WB   WB阶段的寄存器写使能信号
    // alu_src1          ALU操作数1来源：0表示来自reg1，1表示来自PC
    // alu_src2          ALU操作数2来源：2'b00表示来自reg2，2'b01表示来自reg2地址，2'b10表示来自立即数
// 输出
    // flushF            IF阶段的flush信号
    // bubbleF           IF阶段的bubble信号
    // flushD            ID阶段的flush信号
    // bubbleD           ID阶段的bubble信号
    // flushE            EX阶段的flush信号
    // bubbleE           EX阶段的bubble信号
    // flushM            MEM阶段的flush信号
    // bubbleM           MEM阶段的bubble信号
    // flushW            WB阶段的flush信号
    // bubbleW           WB阶段的bubble信号
    // op1_sel           ALU的操作数1来源：2'b00表示来自ALU转发数据，2'b01表示来自write back data转发，2'b10表示来自PC，2'b11表示来自reg1
    // op2_sel           ALU的操作数2来源：2'b00表示来自ALU转发数据，2'b01表示来自write back data转发，2'b10表示来自reg2地址，2'b11表示来自reg2或立即数
    // reg2_sel          reg2的来源
// 实验要求
    // 补全模块


module HarzardUnit(
    input wire rst,
    input wire [4:0] reg1_srcD, reg2_srcD, reg1_srcE, reg2_srcE, reg_dstE, reg_dstM, reg_dstW,
    input wire br, jalr, jal,
    input wire [1:0] src_reg_en,
    input wire wb_select,
    input wire reg_write_en_EX,
    input wire reg_write_en_MEM,
    input wire reg_write_en_WB,
    input wire alu_src1,
    input wire [1:0] alu_src2,
    output bubbleD, bubbleF, flushE, flushD, flushF,
    output reg   bubbleE, flushM, bubbleM, flushW, bubbleW,
    output reg [1:0] op1_sel, op2_sel, reg2_sel
    );

    // TODO: Complete this module
    assign bubbleD = reg_write_en_EX && jalr && (reg1_srcD == reg_dstE) && src_reg_en[1] || 
                        reg_write_en_EX && wb_select && ((reg1_srcD == reg_dstE) && src_reg_en[1] || 
                            (reg2_srcD == reg_dstE) && src_reg_en[0]);
    assign bubbleF = bubbleD;
    assign flushE = jalr||br||bubbleD||rst;
    assign flushD = jal||jalr||br||rst;
    assign flushF = rst;      //don't need


    always@(*)               // op1_sel
    begin
      if(rst)
        op1_sel = 2'b11;//all OK
      else if(alu_src1)  //from pc
      begin
        op1_sel = 2'b10;
      end
      else
      begin
        if(reg_dstM==reg1_srcE&&reg_write_en_MEM&&src_reg_en[1]&&reg_dstM!=0)
            op1_sel = 2'b00;
        else if(reg_dstW==reg1_srcE&&reg_write_en_WB&&src_reg_en[1]&&reg_dstW!=0)
            op1_sel = 2'b01;
        else
            op1_sel = 2'b11;
      end     
    end

    always@(*)       // op2_sel
    begin
        if(rst)
            op2_sel = 2'b11;
        else if(alu_src2==2'b00)
        begin
            if(reg_dstM==reg2_srcE&&reg_write_en_MEM&&src_reg_en[0]&&reg_dstM!=0)
                op2_sel = 2'b00;
            else if(reg_dstW==reg2_srcE&&reg_write_en_WB&&src_reg_en[0]&&reg_dstW!=0)
                op2_sel = 2'b01;
            else
                op2_sel = 2'b11;
        end
        else if(alu_src2==2'b01)
        begin
            op2_sel = 2'b10;
        end
        else 
            op2_sel = 2'b11;
    end

    always@(*)         // reg2_sel
    begin
        if(reg2_srcE==reg_dstM&&reg_write_en_MEM&&reg_dstM!=0)
            reg2_sel = 2'b00;
        else if(reg2_srcE==reg_dstW&&reg_write_en_WB&&reg_dstW!=0)
            reg2_sel = 2'b01;
        else
            reg2_sel = 2'b10;
    end

    always@(*) 
    begin
        if(rst)
        begin
            flushM = 1;
            flushW = 1;
            bubbleM = 0;
            bubbleW = 0;
            bubbleE = 0;
        end
        else
        begin
            flushM = 0;
            flushW = 0;
            bubbleM = 0;
            bubbleW = 0;
            bubbleE = 0;
        end
    end


endmodule
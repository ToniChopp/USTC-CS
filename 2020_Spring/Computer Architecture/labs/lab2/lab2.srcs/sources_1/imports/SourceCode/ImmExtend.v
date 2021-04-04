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

//  鍔熻兘璇存槑
    //  绔嬪嵆鏁版嫇灞曪紝灏嗘寚浠や腑鐨勭珛鍗虫暟閮ㄥ垎鎷撳睍涓哄畬鏁寸珛鍗虫暟
// 杈撳叆
    // Inst              鎸囦护鐨刐31:7]
    // ImmType           绔嬪嵆鏁扮被鍨?
// 杈撳嚭
    // imm               琛ュ叏鐨勭珛鍗虫暟
// 瀹為獙瑕佹眰
    // 琛ュ叏妯″潡


`include "Parameters.v"   
module ImmExtend(
    input wire [31:7] inst,
    input wire [2:0] imm_type,
    output reg [31:0] imm
    );

    always@(*)
    begin
        case(imm_type)
            `ITYPE: imm = {{21{inst[31]}}, inst[30:20]};
            // TODO: complete left part
            // Parameters.v defines all immediate type
            `RTYPE: imm = 32'b0;
            `STYPE: imm = {{21{inst[31]}}, inst[30:25], inst[11:7]};
            `BTYPE: imm = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
            `UTYPE: imm = {inst[31:12], 12'b0};
            `JTYPE: imm = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0};
            `CSRTYPE: imm = {{27{1'b0}},inst[19:15]};
            default: imm = 32'b0;
        endcase
    end
    
endmodule

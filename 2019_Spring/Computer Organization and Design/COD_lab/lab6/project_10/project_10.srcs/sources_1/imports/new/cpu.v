`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/09 17:06:44
// Design Name: 
// Module Name: cpu
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


module Cpu(
    input clk_en0,
    input clk,
    input rst,
    input mem,
    input [7:0]addr,
    output [31:0]data,
    output [7:0]pc,
    input [5:0]sw
    );
    wire clk_en;
    assign clk_en = clk_en0 & ~sw[5];
    wire IorD;
    wire  MemWrite, IRWrite, RegDst, MemtoReg, RegWrite, Zero;
    wire [31:0] MDR, RD1, RD2, SignImm, ALUResult, nextPC;
    wire ALUSrcA, Branch, PCWrite;
    wire [1:0] ALUSrcB;
    wire [2:0] ALUControl;
    wire [1:0] PCSrc;
    wire [1:0] ALUOp;
    reg [31:0] PC=0,mdr,IR, A, B, ALUOut;
    wire [31:0] PCJump = {2'b00, PC[31:28], IR[25:0]};
    wire [4:0] A1 = IR[25:21];
    wire [4:0] A2 = IR[20:16];
    wire [4:0] A3 = RegDst ? IR[15:11] : IR[20:16];
    wire [5:0] Funct = IR[5:0];

    wire [31:0] Adr = IorD ? ALUOut : PC;
    wire [31:0]data1,data2;
    wire [4:0]addr1;
    
    assign pc = PC[7:0]; 
    assign data = (mem==1) ? data1 : data2;
    assign addr1 = addr[4:0];
    // memory
    dist_mem_gen_0 MEM(
         sw[5] == 0?Adr[7:0]:2'd2,
         sw[5] == 0?B:sw[4:0], 
         sw[5] == 0?addr:2'd2, 
         clk, 
         sw[5] == 0?MemWrite:1'b1, 
         MDR, 
         data1);
    // regfile
    Regfile regfile(
        clk, 
        rst,
        addr1,
        data2,
        A1, 
        A2, 
        RD1,
        RD2,
        A3, 
        (MemtoReg ? mdr : ALUOut),
        RegWrite
    );

    wire [31:0] SrcA = ALUSrcA ? A : PC;
    
    wire [31:0] SrcB = ALUSrcB == 0 ? B : ALUSrcB == 1 ? 1 : ALUSrcB == 2 ? ({2'b00,SignImm >> 2}): (SignImm);
    
    ALU alu(
        SrcA,
        SrcB,
        ALUControl,
        ALUResult,
        Zero
    );

    SignedExt signed_ext(IR[15:0], SignImm);

    Control control(clk_en,clk, rst, IR[31:26], IorD, MemWrite, IRWrite, RegDst, 
        MemtoReg, RegWrite, ALUSrcA, Branch, PCWrite, ALUSrcB, ALUOp, PCSrc);

    ALUDecoder alu_decoder(IR[31:26],ALUOp, Funct, ALUControl);

    wire PCEn = (IR[31:26]==6'h5 && ~Zero && Branch) || (IR[31:26]==6'h4 && Zero && Branch) || PCWrite;
    
    assign nextPC = PCSrc == 0 ? ALUResult : PCSrc == 1 ? ALUOut : PCJump;
    
    always@(posedge clk or posedge rst) begin
        if(rst) begin
            PC <= 0; IR <= 0; A <= 0; B <= 0; ALUOut <= 0;
        end else begin
            if(PCEn) PC <= nextPC;
            if(IRWrite) IR <= MDR;
            mdr <= MDR;
            A <= RD1;
            B <= RD2;
            ALUOut <= ALUResult;
        end
    end

endmodule


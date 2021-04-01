`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/17 08:17:14
// Design Name: 
// Module Name: CPU
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


module CPU(
input rst,
input clk,
output [31:0]reg_data,
input [4:0]addr,
output [7:0]led_pc,
output [7:0]address_out,
output MemWrite,
input  [31:0]MemData,
output [31:0]output_B
);
wire [31:0]pc;
wire [31:0]pcn;
wire [3:0] currentstate;
wire [31:0]alu_outR,MDR;
wire [31:0]regA,regB;
wire [31:0]IR;
wire [31:0]read1,read2,alu1,alu2,alu_out,PCJump;
wire [31:0]WriteData;
wire [5:0] op;
wire [4:0] rs;
wire [4:0] rt;
wire [4:0] rd;
wire [4:0]WriteRegister;
wire [31:0]extended,extendedshrift;
wire [5:0] func;
wire [15:0] imm;
wire PCWriteCond1,PCWriteCond2,IorD,MemRead,MemtoReg,PCWrite,IRWrite,ALUSrcA,RegDst,RegWrite,Zero;
wire [1:0]ALUSrcB,ALUOp,PCSource;
wire [31:0]address,Writedata; 
wire [25:0]Jaddr;
assign led_pc=pc;
assign PCJump = {pcn[31:28],extendedshrift};
assign extended=imm;
assign extendedshrift=(imm*4);
assign address_out=address[9:2];
assign output_B=regB;
state_control A0(rst,clk,op,currentstate,PCWriteCond1,PCWriteCond2,IorD,MemRead,MemWrite,MemtoReg,PCWrite,IRWrite,ALUSrcB,ALUSrcA,RegDst,RegWrite,PCSource, ALUOp); 
PC A1(clk,rst,PCWrite,PCWriteCond1,PCWriteCond2,Zero,pcn,pc);
MUX_MEM A2(IorD,pc,alu_outR,address);  
Ins_Reg A3(clk,IRWrite,MemData,op,rs,rt,rd,imm,func,Jaddr);
MUX_write_register A4(RegDst,rt,rd,WriteRegister);
Registers A5(clk,rst,RegWrite,rs,rt,WriteRegister,WriteData,read1,read2,addr,reg_data);
RegisterA ALU_A(clk,read1,regA);
RegisterB ALU_B(clk,read2,regB);
Reg_ALUout ALU(clk,alu_out,alu_outR);
Reg_MEM mdr(clk,MemData,MDR);
MUX_MEM ALU1(ALUSrcA,pc,regA,alu1);
MUX_4to1 A8(ALUSrcB,regB,extended,extendedshrift,alu2);
ALU A9(ALUOp,op,func,alu1,alu2,alu_out,Zero);
MUX_3to1 A10(PCSource,alu_out,alu_outR,PCJump,pcn) ;
MUX_MEM data(MemtoReg,alu_outR,MDR,WriteData);
endmodule

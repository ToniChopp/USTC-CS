`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/25 13:17:20
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
    input clk,
    input rst,
    output [31:0]pcF,
    input [31:0]instrdataF,
    output memwriteM,
    output [31:0]aluoutM,
    input [31:0]readdataM,
    output [31:0] writedataM,
    input [9:0]address,
    output [31:0]regdata,
    output stallD,
    output stallF,
    output flushE,
    output flushD
    );
    wire memtoregD,regwriteD,extendD,branchD,regdstD,regdstE,cmpoutD,regwriteE,regwriteM,regwriteW,memtoregE,memtoregM,memtoregW;
    wire memwriteD,memwriteE,forwardaD,forwardbD,pcsrcD,alusrcbD,alusrcbE,alusrcaD,alusrcaE;
    wire [1:0] forwardaE,forwardbE;
    wire [31:0]slimmD,immD,immE,pcplus4F,pcplus4D,pcplus4E,pcd,extendnumber,read1D,read2D,read1E,read2E,rd1,rd2,aluoutW;
    wire [31:0]srca0,srcb0,resultW,alua,alub,aluoutE,writedataE,readdataW,pcbranchD,pcnextbrFD,instrdataD,pcnextFD;
    wire [5:0]op,func;
    wire [1:0]jumpD;
    wire [2:0]cmpD;
    wire [3:0]alucontrolD,alucontrolE;
    wire [4:0]rsD,rtD,rdD,rsE,rtE,rdE,writeregE,writeregM,writeregW;
    assign extendnumber={16'b0,instrdataD[15:0]};
    assign op=instrdataD[31:26];
    assign func=instrdataD[5:0];
    assign rsD=instrdataD[25:21];
    assign rtD=instrdataD[20:16];
    assign rdD=instrdataD[15:11];
    assign pcsrcD=branchD&&cmpoutD;
    assign flushD=jumpD||pcsrcD;
    hazard h(rsD,rtD,rsE,rtE,
                 writeregE,writeregM,writeregW,
                 regwriteE,regwriteM,regwriteW,
                 memtoregE,memtoregM,branchD,
                 forwardaD,forwardbD,forwardaE,forwardbE,
                 stallF,stallD,flushE,
                 jumpD);
//    PC p(clk,rst,stallF,pcnext,pc);
    regpc A7(clk,rst,stallF,pcnextFD,pcF);
    controller c(instrdataD,op,func,memtoregD,memwriteD,branchD,alusrcaD,alusrcbD,regdstD,regwriteD,jumpD,alucontrolD,extendD,cmpD);
    aluadd pcadd(pcF,32'b100,pcplus4F);
    regifid A1(clk,flushD,{pcplus4F,instrdataF},stallD,{pcplus4D,instrdataD});
    registers F(clk,rst,regwriteW,rsD,rtD,writeregW,resultW,read1D,read2D,address[4:0],regdata);
    CMP A8(cmpD,rd1,rd2,rtD,cmpoutD);
    regidex A2(clk,flushE,0,{rsE,rtE,rdE,regwriteE,memtoregE,memwriteE,alucontrolE,alusrcaE,alusrcbE,regdstE,read1E,read2E,immE,pcplus4E},
    {rsD,rtD,rdD,regwriteD,memtoregD,memwriteD,alucontrolD,alusrcaD,alusrcbD,regdstD,read1D,read2D,immD,pcplus4D});
    signnext A10(instrdataD[15:0],extendD,immD);
    sl2 A3(immD[29:0],slimmD);
    aluadd pcbranch(pcplus4D,slimmD,pcbranchD);
    mux2 writereg(regdstE,rtE,rdE,writeregE);
    mux2data  a1(forwardaD,read1D,aluoutM,rd1);
    mux2data  b1(forwardbD,read2D,aluoutM,rd2);
    mux3data  a2(forwardaE,read1E,resultW,aluoutM,srca0);
    mux3data  b2(forwardbE,read2E,resultW,aluoutM,srcb0);
    mux2data  pcmux2(pcsrcD,pcplus4F,pcbranchD,pcnextbrFD);
    mux3data  pcmux3(jumpD,pcnextbrFD,{pcF[31:28],instrdataD[25:0],2'b00},rd1,pcnextFD);
    
    mux2data  alu1(alusrcaE,srca0,pcplus4E,alua);
    mux2data  alu2(alusrcbE,srcb0,immE,alub);
    alu A4(alua,alub,alucontrolE,aluoutE);
    regexmem A5(clk,rst,0,{regwriteM,memtoregM,memwriteM,aluoutM,writedataM,writeregM},{regwriteE,memtoregE,memwriteE,aluoutE,srcb0,writeregE});
    regmemwb A6(clk,rst,0,{regwriteW,memtoregW,readdataW,aluoutW,writeregW},{regwriteM,memtoregM,readdataM,aluoutM,writeregM});
    mux2data wb(memtoregW,aluoutW,readdataW,resultW);
endmodule

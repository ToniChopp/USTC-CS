`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/17 08:30:00
// Design Name: 
// Module Name: state_control
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


module state_control(
input rst,
input clk,
input [5:0] op,
output reg [3:0]currentstate,
output reg  PCWriteCond1,
output reg  PCWriteCond2,
output reg IorD,
output reg MemRead, 
output reg MemWrite, 
output reg MemtoReg,
output reg PCWrite,
output reg IRWrite,
output reg [1:0]ALUSrcB,
output reg ALUSrcA,
output reg RegDst,
output reg RegWrite,
output reg [1:0]PCSource,
output reg [1:0]ALUOp
    );
     parameter IF=4'b0000;
     parameter ID=4'b0001;
     parameter EXC_LS=4'b0010;
     parameter EXC_R=4'b0011;
     parameter EXC_BEQ=4'b0100;
     parameter EXC_BNE=4'b0101;
     parameter EXC_J=4'b0110;
     parameter EXC_Itype=4'b1011;
     parameter MEM_LW=4'b0111;
     parameter MEM_SW=4'b1000;
     parameter REG_R=4'b1001;
     parameter REG_LW=4'b1010;
     parameter REG_Itype=4'b1100;
     parameter Rtype=6'b000000;
     parameter lw=6'b100011;
     parameter sw=6'b101011;
     parameter beq=6'b000100;
     parameter bne=6'b000101;
     parameter jump=6'b000010;
     parameter addi=6'b001000; 
     parameter andi=6'b001100; 
     parameter ori=6'b001101; 
     parameter xori=6'b001110; 
     parameter slti=6'b001010;
    reg [3:0] nextstate;
        always@(posedge clk or posedge rst)
    begin
        if(rst)
        currentstate<=IF;
        else
        currentstate<=nextstate;
     end
     always@(*)
     begin
     case(currentstate)
        IF: nextstate=ID;
        ID:
        begin
            if(op==Rtype)    nextstate=EXC_R;
            else if(op==lw||op==sw)    nextstate=EXC_LS;
            else if(op==beq)    nextstate=EXC_BEQ;
            else if(op==bne)    nextstate=EXC_BNE;
            else if(op==jump)    nextstate=EXC_J;
            else if(op==addi||op==andi||op==ori||op==xori||op== slti)    nextstate=EXC_Itype;
        end
        EXC_LS:
        begin
        if(op==sw)
            nextstate=MEM_SW;
        else 
            nextstate=MEM_LW;
        end
        EXC_R:nextstate=REG_R;
        MEM_LW:nextstate=REG_LW;
        REG_R:nextstate=IF;
        REG_LW:nextstate=IF;
        MEM_SW:nextstate=IF;
        EXC_J:nextstate=IF;
        EXC_BEQ:nextstate=IF;
        EXC_BNE:nextstate=IF;
        EXC_Itype:nextstate=REG_Itype;
        REG_Itype:nextstate=IF;
        endcase
     end
     always@(*)
     begin
         case(currentstate)
         IF:begin 
                MemRead=1;
                ALUSrcA= 0; 
                IorD = 0;
                IRWrite=1;
                ALUSrcB=2'b 01;
                ALUOp=2'b00; 
                PCWrite=1 ;
                PCSource =2'b 00; 
                PCWriteCond1=0;
                PCWriteCond2=0;
                MemWrite=0;
                RegWrite=0;
             end
         ID:begin
             IRWrite=0;
             ALUSrcA= 0;
             ALUSrcB=2'b11;
             ALUOp=2'b00;
             PCWrite=0;
            end
         EXC_LS:
         begin
             ALUSrcA= 1; ALUSrcB= 2'b10; ALUOp =2'b00;  
         end
         EXC_R:
         begin
             ALUSrcA=1; ALUSrcB=2'b00; ALUOp=2'b 10; 
         end
         EXC_BEQ:
         begin
             ALUSrcA=1; ALUSrcB=2'b00; ALUOp=2'b 01; PCWriteCond1=1; PCSource=2'b 01; 
         end
         EXC_BNE:
         begin
             ALUSrcA=1; ALUSrcB=2'b00; ALUOp=2'b 01; PCWriteCond2=1; PCSource=2'b 01; 
         end
         EXC_J:
         begin
             PCWrite=1; PCSource=2'b 10; 
         end
         MEM_SW:
         begin
             IorD=1; MemWrite=1;
         end
         MEM_LW:
         begin
             IorD=1; MemRead=1; 
         end
         REG_R:
         begin
             RegDst=1; RegWrite=1; MemtoReg=0; 
         end
         REG_LW:
         begin
             RegDst=0; RegWrite=1;   MemtoReg=1; MemRead=0; 
         end
         EXC_Itype:
         begin
             ALUSrcA=1; ALUSrcB=2'b10; ALUOp=2'b11; 
         end
         REG_Itype:
         begin
             RegDst=0; RegWrite=1; MemtoReg=0; 
         end
      endcase
   end

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/09 17:41:28
// Design Name: 
// Module Name: Control
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


module Control(

	clk_en,clk, rst, opcode,
	IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite, ALUSrcA, Branch, PCWrite,
	ALUSrcB,ALUOp, PCSrc
   );
	input clk_en,clk, rst;
	input [5:0] opcode;
	output reg IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite, ALUSrcA, Branch, PCWrite;
	output reg [1:0] ALUSrcB, ALUOp, PCSrc;
	reg [3:0] cur_state=12, next_state;
	
	always@(posedge clk or negedge rst) begin
		if(rst) begin
			cur_state <= 12;
		end else begin
			cur_state <= next_state;
		end
	end
	
	always@(*)
	begin
		case(cur_state)
			0:
		    begin // wait mem
                IorD=0;
                MemWrite=0;
                IRWrite=1;
                RegDst=0;
                MemtoReg=0;
                RegWrite=0;
                ALUSrcA=0;
                Branch=0;
                PCWrite=1;
                ALUSrcB=1;
                ALUOp=0;
                PCSrc=0;
            end			
            1:
			begin
				IorD=0;
				MemWrite=0;
				IRWrite=0;
				RegDst=0;
				MemtoReg=0;
				RegWrite=0;
				ALUSrcA=0;
				Branch=0;
				PCWrite=0;
				ALUSrcB=3;
				ALUOp=0;
				PCSrc=0;
			end
			2:
			begin
				IorD=0;
				MemWrite=0;
				IRWrite=0;
				RegDst=0;
				MemtoReg=0;
				RegWrite=0;
				ALUSrcA=1;
				Branch=0;
				PCWrite=0;
				ALUSrcB=2;
				ALUOp=0;
				PCSrc=0;
			end
			3:
			begin
				IorD=1;
				MemWrite=0;
				IRWrite=0;
				RegDst=0;
				MemtoReg=0;
				RegWrite=0;
				ALUSrcA=0;
				Branch=0;
				PCWrite=0;
				ALUSrcB=0;
				ALUOp=0;
				PCSrc=0;
			end
			4:
			begin
				IorD=0;
				MemWrite=0;
				IRWrite=0;
				RegDst=0;
				MemtoReg=1;
				RegWrite=1;
				ALUSrcA=0;
				Branch=0;
				PCWrite=0;
				ALUSrcB=0;
				ALUOp=0;
				PCSrc=0;
			end
			5:
			begin
				IorD=1;
				MemWrite=1;
				IRWrite=0;
				RegDst=0;
				MemtoReg=0;
				RegWrite=0;
				ALUSrcA=0;
				Branch=0;
				PCWrite=0;
				ALUSrcB=0;
				ALUOp=0;
				PCSrc=0;
			end
			6:
			begin
				IorD=0;
				MemWrite=0;
				IRWrite=0;
				RegDst=0;
				MemtoReg=0;
				RegWrite=0;
				ALUSrcA=1;
				Branch=0;
				PCWrite=0;
				ALUSrcB=0;
				ALUOp=2;
				PCSrc=0;
			end
			7:
			begin
				IorD=0;
				MemWrite=0;
				IRWrite=0;
				RegDst=1;
				MemtoReg=0;
				RegWrite=1;
				ALUSrcA=0;
				Branch=0;
				PCWrite=0;
				ALUSrcB=0;
				ALUOp=0;
				PCSrc=0;
			end
			8:
			begin
				IorD=0;
				MemWrite=0;
				IRWrite=0;
				RegDst=0;
				MemtoReg=0;
				RegWrite=0;
				ALUSrcA=1;
				Branch=1;
				PCWrite=0;
				ALUSrcB=0;
				ALUOp=1;
				PCSrc=1;
			end
			9:
			begin
				IorD=0;
				MemWrite=0;
				IRWrite=0;
				RegDst=0;
				MemtoReg=0;
				RegWrite=0;
				ALUSrcA=1;
				Branch=0;
				PCWrite=0;
				ALUSrcB=3;
				ALUOp=3;
				PCSrc=0;
			end
			10:
			begin
				IorD=0;
				MemWrite=0;
				IRWrite=0;
				RegDst=0;
				MemtoReg=0;
				RegWrite=1;
				ALUSrcA=0;
				Branch=0;
				PCWrite=0;
				ALUSrcB=0;
				ALUOp=0;
				PCSrc=0;
			end
			11:
			begin
				IorD=0;
				MemWrite=0;
				IRWrite=0;
				RegDst=0;
				MemtoReg=0;
				RegWrite=0;
				ALUSrcA=0;
				Branch=0;
				PCWrite=1;
				ALUSrcB=0;
				ALUOp=0;
				PCSrc=2;
			end
			12:
            begin
                IorD=0;
                MemWrite=0;
                IRWrite=0;
                RegDst=0;
                MemtoReg=0;
                RegWrite=0;
                ALUSrcA=0;
                Branch=0;
                PCWrite=0;
                ALUSrcB=0;
                ALUOp=0;
                PCSrc=0;
            end			
			default:
			begin
				IorD=0;
				MemWrite=0;
				IRWrite=0;
				RegDst=0;
				MemtoReg=0;
				RegWrite=0;
				ALUSrcA=0;
				Branch=0;
				PCWrite=0;
				ALUSrcB=0;
				ALUOp=0;
				PCSrc=0;
			end
		endcase
	end
	
	always@(*)
	begin
		case(cur_state)
			1:
			begin
				if(opcode == 6'h23 || opcode == 6'h2b) next_state = 2;
				else if(opcode == 6'h0) next_state = 6;
				else if(opcode == 6'h4 | opcode == 6'h5) next_state = 8;
				else if(opcode[5:3] == 3'h1) next_state = 9;
				else if(opcode ==  6'h2) next_state = 11;
				else next_state = 0;
			end
			2:
			begin
				if(opcode == 6'h23) next_state = 3;
				else next_state = 5;
			end
			3: next_state = 4;
			6: next_state = 7;
			9: next_state = 10;
			0: next_state = 1;
			12:
			begin
			    next_state=(clk_en==1) ? 0 : 12;
			end
			default: begin next_state = 12;end
		endcase
	end

endmodule

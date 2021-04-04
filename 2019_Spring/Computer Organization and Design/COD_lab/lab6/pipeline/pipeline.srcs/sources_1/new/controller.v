`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/25 15:27:48
// Design Name: 
// Module Name: controller
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


module controller(
   input [31:0]instrdata,
   input [5:0]op,
   input [5:0]func,
   output memtoreg,
   output memwrite,
   output branch,
   output alusrca,
   output alusrcb,
   output  regdst,
   output  regwrite,
   output  [1:0]jump,
   output  reg [3:0]alucontrol,
   output  extend,
   output [2:0]cmp
    );
   reg  [17:0]controls;
   wire [2:0]aluop;
   assign {regwrite,regdst,alusrca,alusrcb,branch,memwrite,memtoreg,jump,aluop,extend,cmp}=controls;
   always@(*)
   begin
        if(instrdata==32'h0000_0000)
        controls=16'b0000_0000_0000_0000;
        else
        begin 
        case(op)
        6'b000000:
            case(func)           //sll,srl,sra
            6'b000000:controls=16'b1100000001111000;
            6'b000011:controls=16'b1100000001111000;
            6'b000010:controls=16'b1100000001111000;
            //jalr
            6'b001001:controls=16'b1110000100001000;
            //jr
            6'b001000:controls=16'b0000000100001000;
            //and,or,add,sub,slt,xor,nor
            default:  controls=16'b1100000001111000;
            endcase
    6'b100011:    controls=16'b1001001000001000;//LW
    6'b101011:    controls=16'b0001010000001000;//SW
    
    6'b000100:    controls=16'b0000100000011000;//BEQ
    6'b000101:    controls=16'b0000100000011001;//BNE
    6'b000110:    controls=16'b0000100000011010;//BLEZ
    6'b000111:    controls=16'b0000100000011011;//BGTZ
    6'b000001:    controls=16'b0000100000011100;//BGEZ,BLTZ
    
    6'b001000:    controls=16'b1001000000001000;//ADDI
    6'b000010:    controls=16'b0000000010001000;//J
    6'b001100:    controls=16'b1001000000100000;//ANDI
    6'b001101:    controls=16'b1001000000110000;//ORI
    6'b001010:    controls=16'b1001000001000000;//SLTI
    6'b001110:    controls=16'b1001000001010000;//XORI
    default:      controls=16'bxxxxxxxxxxxxxxxx;//???
        endcase
   end
end

  always@(*)
    case(aluop)
    3'b000:alucontrol=4'b0010;//add
    3'b001:alucontrol=4'b0110;//sub
    //add aluop
    3'b010:alucontrol=4'b0000;//and (for andi)
    3'b011:alucontrol=4'b0001;//or (for ori)
    3'b100:alucontrol=4'b0111;//slt (for slti)
    3'b101:alucontrol=4'b0101;//xor (for xori)
    3'b110:alucontrol=4'b0011;//sll (for lui)
    default:
        case(func)//RTYPE
        6'b100000:alucontrol=4'b0010;//ADD
        6'b100010:alucontrol=4'b0110;//SUB
        6'b100100:alucontrol=4'b0000;//AND
        6'b100101:alucontrol=4'b0001;//OR
        6'b101010:alucontrol=4'b0111;//SLT
        //new
        6'b100111:alucontrol=4'b0100;//NOR
        6'b100110:alucontrol=4'b0101;//XOR
        6'b000000:alucontrol=4'b0011;//SLL
        6'b000010:alucontrol=4'b1000;//SRL
        6'b000011:alucontrol=4'b1001;//SRA
        default:  alucontrol=4'bxxxx;//???
        endcase
    endcase
    
endmodule

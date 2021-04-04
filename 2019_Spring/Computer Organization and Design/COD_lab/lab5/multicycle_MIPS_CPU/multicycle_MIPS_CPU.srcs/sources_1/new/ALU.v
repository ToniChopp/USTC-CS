`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/17 12:21:25
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [1:0]ALUop,
    input [5:0]op,
    input [5:0]func,
    input [31:0]ALUin1,
    input [31:0]ALUin2,
    output reg [31:0]ALUout,
    output Zero
);
parameter addi=6'b001000; 
parameter andi=6'b001100; 
parameter ori=6'b001101; 
parameter xori=6'b001110; 
parameter slti=6'b001010;
always@(*)
begin
    case(ALUop)
    2'b 00: 
    begin 
        ALUout=ALUin1+ALUin2;
    end
    2'b 01:
    begin  
        ALUout=ALUin1-ALUin2;    
    end  
    2'b 10: 
    begin
       case(func)
       6'b 100000:ALUout=ALUin1+ALUin2;
       6'b 100001:ALUout=ALUin1+ALUin2;
       6'b 100010:ALUout=ALUin1-ALUin2;
       6'b 100011:ALUout=ALUin1-ALUin2;
       6'b 100100:ALUout=ALUin1&ALUin2;
       6'b 100101:ALUout=ALUin1|ALUin2;
       6'b 100110:ALUout=ALUin1^ALUin2;
       6'b 100111:ALUout=~(ALUin1|ALUin2);
       6'b 101010:
       begin 
           if(ALUin1<ALUin2 ) 
               ALUout=1; 
           else 
               ALUout=0; 
       end
       default ALUout=0;
       endcase
    end
    2'b 11:
    begin
       case(op)
       addi :ALUout= ALUin1+ALUin2;
       andi :ALUout=ALUin1&ALUin2;
       ori : ALUout=ALUin1|ALUin2;
       xori : ALUout=ALUin1^ALUin2;
       slti :
       begin
           if(ALUin1<ALUin2)
               ALUout=1;
           else 
               ALUout=0;
        end 
        endcase
     end
     endcase
end
assign Zero=ALUout==0?1:0;
endmodule

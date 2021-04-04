`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/26 09:12:07
// Design Name: 
// Module Name: hazard
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


module hazard(
input [4:0] rsD,rtD,rsE,rtE,
input [4:0] writeregE,writeregM,writeregW,
input regwriteE,regwriteM,regwriteW,
input memtoregE,memtoregM,branchD,
output forwardaD,forwardbD,
output reg [1:0] forwardaE,forwardbE,
output stallF,stallD,flushE,
input [1:0] jumpD
    );
    wire lwstallD,branchstallD;
    wire jalrstallD;
    
    assign forwardaD=(rsD!=0 && rsD==writeregM && regwriteM);
    assign forwardbD=(rtD!=0 && rtD==writeregM && regwriteM);
    
   always@(*)
     begin
         if(rsE!=0)
         begin
             if(rsE==writeregM && regwriteM)
                 forwardaE=2'b10;
             else
                 if(rsE==writeregW && regwriteW)
                     forwardaE=2'b01;
                 else     forwardaE=2'b00;
         end
         
      
         if(rtE!=0)
         begin 
             if(rtE==writeregM & regwriteM)
                 forwardbE=2'b10;
             else
                 if(rtE==writeregW & regwriteW)
                     forwardbE=2'b01;
                 else forwardbE=2'b00;
         end
     end
     
     
     //here cause problems addd pcsrcdD stall add jump D stall
    assign  lwstallD=(memtoregE && (rtE==rsD || rtE==rtD));
    assign  branchstallD=branchD && (regwriteE && (writeregE==rsD || writeregE==rtD) || memtoregM && (writeregM==rsD || writeregM==rtD));
    assign  jalrstallD=(jumpD==2'b10) && (regwriteE && writeregE==rsD ||memtoregM && writeregM==rsD);//jalr waits for the reg to be ready
    assign  stallD=lwstallD || branchstallD || jalrstallD;
    assign  stallF=stallD;//stalling D stalls all previous stages
    assign  flushE=stallD;//stalling D flushes next 
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/21 18:45:52
// Design Name: 
// Module Name: lab1
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
    input [5:0]a,
    input [5:0]b,
    input [3:0]s,  //0001�� 0010�� 0011�� 0100�� 0101�� 0110���
    output reg [3:0]y,
    output reg [5:0]f    //f[0]��λ f[1]��λ f[2]��� f[3]��
    );
    reg [5:0]c;
    
    always @(*)
    begin
        f=4'b0000;
        case(s)
        4'b0000:
        begin
            y=6'b0; f=4'b0000;  
        end
        4'b0001: 
        begin
            y=a+b;
            if(y==0)
            begin
                f[3]=1;
            end
            else if((a[5]==0 && b[5]==0 && y[5]==1))
            begin
                f[2]=1;
                f[0]=1;
            end
            else if(a[5]==1 && b[5]==1 && y[5]==0)
            begin
               f[2]=1;
               f[0]=1;
            end
            else if((a[5]==1 && b[5]==0 && y[5]==0) || (a[5]==0 && b[5]==1 && y[5]==0))
            begin
                f[0]=1;
            end
        end
        4'b0010:
        begin
            c=~b;
            c=c+1;
            y=a+c;
            if(a<b)
                f[1]=1;
            else if(a[5]==1 && b[5]==0)
            begin
                if(y[5]==0)
                begin
                    f[2]=1;
                end
            end
            else if(a[5]==0 && b[5]==1 && y[5]==1)
            begin
                f[2]=1;
            end
            else if(y==0)
            begin 
                f[3]=1;
            end
        end 
        4'b0011:
        begin
            y=a & b;
            if(y==0)
            begin
                f[3]=1;
            end
        end 
        4'b0100:
        begin
            y=a | b;
            if(y==0)
            begin
                f[3]=1;
            end
        end  
        4'b0101:
        begin
            y=~a;
            if(y==0)
            begin
                f[3]=1;
            end
         end     
         4'b0110:
         begin
             y=a^b;
             if(y==0)
             begin
                 f[3]=1;
             end
          end        
        endcase
    end
endmodule

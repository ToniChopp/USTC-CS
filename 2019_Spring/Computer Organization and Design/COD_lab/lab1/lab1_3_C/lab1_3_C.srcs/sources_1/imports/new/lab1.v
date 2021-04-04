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
    input [15:0]a,
    input [15:0]b,
    input [3:0]s,  //0001加 0010减 0011与 0100或 0101非 0110异或
    output reg [15:0]y,
    output reg [3:0]f    //f[0]进位 f[1]借位 f[2]溢出 f[3]零
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
            if(a[5]==b[5])
            begin
                if(a<b)
                    f[1]=1;
            end
            else if(a[5]==1 && b[5]==0)
            begin
                f[1]=1;
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

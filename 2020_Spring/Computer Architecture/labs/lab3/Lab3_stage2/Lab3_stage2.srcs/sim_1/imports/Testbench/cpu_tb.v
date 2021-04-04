`timescale 1ns / 1ps

module cpu_tb();
    reg clk = 1'b1;
    reg rst = 1'b1;
    
    always  #2 clk = ~clk;
    initial #8 rst = 1'b0;
    
    wire miss;
    wire access_signal;
    
    RV32ICore RV32ICore_tb_inst(
        .CPU_CLK    ( clk          ),
        .CPU_RST    ( rst          ),
        .miss       ( miss         ),
        .access_signal(access_signal)
    );
    
    reg [31:0]access_count, miss_count;
    initial 
    begin
        access_count = 0;
        miss_count = 0;
    end
    always @ (posedge miss)
    begin
        miss_count <= miss_count+1;
    end
    
    always @ (posedge access_signal)
    begin
        access_count <= access_count+1;
    end
    
endmodule

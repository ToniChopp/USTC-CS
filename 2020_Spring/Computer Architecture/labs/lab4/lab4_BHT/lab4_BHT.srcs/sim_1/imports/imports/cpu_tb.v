`timescale 1ns / 1ps

module cpu_tb();
    reg clk = 1'b1;
    reg rst = 1'b1;
    
    always  #2 clk = ~clk;
    initial #8 rst = 1'b0;

    wire BR_predict;
    wire BR_predict_miss;
    wire BP_update;

    
    RV32ICore RV32ICore_tb_inst(
        .CPU_CLK    ( clk          ),
        .CPU_RST    ( rst          ),
        .CPU_BR_predict ( BR_predict   ),
        .CPU_BR_predict_miss( BR_predict_miss ),
        .CPU_BP_update (BP_update)
    );

    reg [31:0] BR_predict_cnt, BR_predict_miss_cnt, BR_cnt;
    initial
    begin
        BR_predict_cnt = 0;
        BR_predict_miss_cnt = 0;
        BR_cnt = 0;
    end

    always @ (posedge clk)
    begin
        if (BR_predict == 1'b1)
        begin
            BR_predict_cnt <= BR_predict_cnt + 1;
        end
    end

    always @ (posedge clk)
    begin
        if (BR_predict_miss == 1'b1)
        begin
            BR_predict_miss_cnt <= BR_predict_miss_cnt + 1;
        end
    end
    
    always @ (posedge clk)
    begin
        if (BP_update == 1'b1)
        begin
            BR_cnt <= BR_cnt + 1;
        end
    end

endmodule

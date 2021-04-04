`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: Hazard Module
// Tool Versions: Vivado 2017.4.1
// Description: Hazard Module is used to control flush, bubble and bypass
// 
//////////////////////////////////////////////////////////////////////////////////

//  閸旂喕鍏樼拠瀛樻
    //  鐠囧棗鍩嗗ù浣规寜缁惧じ鑵戦惃鍕殶閹诡喖鍟跨粣渚婄礉閹貉冨煑閺佺増宓佹潪顒€褰傞敍灞芥嫲flush閵嗕攻ubble娣団€冲娇
// 鏉堟挸鍙�
    // rst               CPU閻ㄥ墔st娣団€冲娇
    // reg1_srcD         ID闂冭埖顔岄惃鍕爱reg1閸︽澘娼�
    // reg2_srcD         ID闂冭埖顔岄惃鍕爱reg2閸︽澘娼�
    // reg1_srcE         EX闂冭埖顔岄惃鍕爱reg1閸︽澘娼�
    // reg2_srcE         EX闂冭埖顔岄惃鍕爱reg2閸︽澘娼�
    // reg_dstE          EX闂冭埖顔岄惃鍕窗閻ㄥ墔eg閸︽澘娼�
    // reg_dstM          MEM闂冭埖顔岄惃鍕窗閻ㄥ墔eg閸︽澘娼�
    // reg_dstW          WB闂冭埖顔岄惃鍕窗閻ㄥ墔eg閸︽澘娼�
    // br                閺勵垰鎯乥ranch
    // jalr              閺勵垰鎯乯alr
    // jal               閺勵垰鎯乯al
    // wb_select         閿熸枻鎷烽敓鏂ゆ嫹EX閿熻娇纰夋嫹WBselect閿熸枻鎷烽敓鍙鎷積x鎸囬敓鏂ゆ嫹閿熻鍑ゆ嫹涓簂oad鎸囬敓鏂ゆ嫹
    // reg_write_en_MEM  MEM闂冭埖顔岄惃鍕槑鐎涙ê娅掗崘娆庡▏閼虫垝淇婇敓锟�?
    // reg_write_en_WB   WB闂冭埖顔岄惃鍕槑鐎涙ê娅掗崘娆庡▏閼虫垝淇婇敓锟�?
// 鏉堟挸鍤�
    // flushF            IF闂冭埖顔岄惃鍒ush娣団€冲娇
    // bubbleF           IF闂冭埖顔岄惃鍒bble娣団€冲娇
    // flushD            ID闂冭埖顔岄惃鍒ush娣団€冲娇
    // bubbleD           ID闂冭埖顔岄惃鍒bble娣団€冲娇
    // flushE            EX闂冭埖顔岄惃鍒ush娣団€冲娇
    // bubbleE           EX闂冭埖顔岄惃鍒bble娣団€冲娇
    // flushM            MEM闂冭埖顔岄惃鍒ush娣団€冲娇
    // bubbleM           MEM闂冭埖顔岄惃鍒bble娣団€冲娇
    // flushW            WB闂冭埖顔岄惃鍒ush娣団€冲娇
    // bubbleW           WB闂冭埖顔岄惃鍒bble娣団€冲娇
    // op1_sel           00 is reg1, 01 is mem stage forwarding, 01 is wb stage forwarding
    // op2_sel           00 is reg2, 01 is mem stage forwarding, 01 is wb stage forwarding


`include "Parameters.v"   
module HarzardUnit(
    input wire rst,
    input miss,
    input wire [4:0] reg1_srcD, reg2_srcD, reg1_srcE, reg2_srcE, reg_dstE, reg_dstM, reg_dstW,
    input wire br, jalr, jal,
    input wire wb_select,
    input wire reg_write_en_MEM,
    input wire reg_write_en_WB,
    input wire br_predict_miss,
    output reg flushF, bubbleF, flushD, bubbleD, flushE, bubbleE, flushM, bubbleM, flushW, bubbleW,
    output reg [1:0] op1_sel, op2_sel
    );

    // TODO: Complete this module
    // generate op1_sel
    always @ (*)
    begin 
        if (reg1_srcE == reg_dstM && reg_write_en_MEM == 1 && reg1_srcE != 0)
        begin
            // mem to ex forwarding, mem forwarding first
            op1_sel = 2'b01;
        end
        else if (reg1_srcE == reg_dstW && reg_write_en_WB == 1 && reg1_srcE != 0)
        begin
            // wb to ex forwarding
            op1_sel = 2'b10;
        end
        else 
        begin
            op1_sel = 2'b00;
        end
    end
    
    // generate op2_sel
    always @ (*)
    begin
        if (reg2_srcE == reg_dstM && reg_write_en_MEM == 1 && reg2_srcE != 0)
        begin
            // mem to ex forwarding, mem forwarding first
            op2_sel = 2'b01;
        end
        else if (reg2_srcE == reg_dstW && reg_write_en_WB == 1 && reg2_srcE != 0)
        begin
            // wb to ex forwarding
            op2_sel = 2'b10;
        end
        else 
        begin
            op2_sel = 2'b00;
        end
    end
    
    // generate bubbleF and flushF and bubbleD and flushD and  bubbleE and flushE
    always @ (*)
    begin
        if (rst)
        begin
            bubbleF = 0;
            flushF = 1;
            bubbleD = 0;
            flushD = 1;
            bubbleE = 0;
            flushE = 1;
        end
        else 
        begin
            if (wb_select == 1 && (reg_dstE == reg1_srcD || reg_dstE == reg2_srcD))
            begin
                // load-use type data hazard, bubble IF, bubble ID, flushE
                bubbleF = 1;
                flushF = 0;
                bubbleD = 1;
                flushD = 0;
                bubbleE = 0;
                flushE = 1;
            end
            else if (miss)
            begin          // miss bubbleF bubbleD bubbleE
                bubbleF = 1;
                flushF = 0;
                bubbleD = 1;
                flushD = 0;
                bubbleE = 1;
                flushE = 0;
           end
            // implement branch predict with default no branch
            else if (br_predict_miss == 1)
            begin
                // branch instruction, flush ID, 
                bubbleF = 0;
                flushF = 0;
                bubbleD = 0;
                flushD = 1;
                bubbleE = 0;
                flushE = 1;
            end
            else if (jalr == 1)
            begin
                bubbleF = 0;
                flushF = 0;
                bubbleD = 0;
                flushD = 1;
                bubbleE = 0;
                flushE = 1;
            end
            else if (jal == 1)
            begin
                bubbleF = 0;
                flushF = 0;
                bubbleD = 0;
                flushD = 1;
                bubbleE = 0;
                flushE = 0;
            end
            else
            begin
                bubbleF = 0;
                flushF = 0;
                bubbleD = 0;
                flushD = 0;
                bubbleE = 0;
                flushE = 0;
            end
        end
    end
    
    // generate bubbleM and flushM
    always @ (*)
    begin
        if (rst)
        begin
            bubbleM = 0;
            flushM = 1;
        end
        else 
        begin
            if (miss)
            begin
                bubbleM = 1;
                flushM = 0;
            end
            else 
            begin
                bubbleM = 0;
                flushM = 0;
            end
        end
    end
    
    
    // generate bubbleW and flushW
    always @ (*)
    begin
        if (rst)
        begin
            bubbleW = 0;
            flushW = 1;
        end
        else 
        begin
            if (miss)
            begin
                bubbleW = 1;
                flushW = 0;
            end
            else 
            begin
                bubbleW = 0;
                flushW = 0;
            end
        end
    end

endmodule
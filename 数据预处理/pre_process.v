`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/30 12:42:49
// Design Name: 
// Module Name: pre_process
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


module pre_process(
    input clk,
    input rstn,
    
    input set_sel_i,
    input set_sel_val,
    
    input micro_pdm_i,
    output reg [1:0] pdm_o,
    output reg micro_clk,
    output reg sel_lr);
    
    wire clk_2x;//2倍的micro_clk信号
    //麦克风时钟生成 2分频
    always@(posedge clk_2x or negedge rstn)begin
        if(!rstn)begin
            micro_clk <= 0;
        end
        else begin
            micro_clk <= ~micro_clk;
        end
    end 
    
    //声道选择，默认为左声道
    always@(posedge clk or negedge rstn)begin
        if(!rstn)begin
            sel_lr <= 0;
        end
        else if(set_sel_val) begin
            sel_lr <= set_sel_i;
        end
        else begin
            sel_lr <= sel_lr;
        end
    end
    
    //单bit转有符号数
    always@(posedge clk or negedge rstn)begin
        if(!rstn)begin
            pdm_o <= 2'b00;
        end
        else if(!micro_pdm_i) begin
            pdm_o <= 2'b11;
        end
        else if(micro_pdm_i) begin
            pdm_o <= 2'b01;
        end
        else begin
            pdm_o <= pdm_o;
        end
    end

  clk_wiz_0 clk_wiz_0
   (
    // Clock out ports
    .clk_out1(clk_2x),     // output clk_out1
    // Status and control signals
    .resetn(rstn), // input resetn
    .locked(),       // output locked
   // Clock in ports
    .clk_in1(clk));      // input clk_in1
    
endmodule

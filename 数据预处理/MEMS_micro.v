`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/02 17:01:14
// Design Name: 
// Module Name: MEMS_micro
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


module MEMS_micro(
        input   sys_clk,//ÊäÈëÊ±ÖÓ50MHz
        input   sys_rst_n,
        
        input     set_sel_i,
        input     set_sel_val,
        input     micro_pdm_i,
        
        output    micro_clk_o,//3.072MHz
        output    sel_lr_o,//GND:L  VDD:R
        
        output    [15:0] data_o,
        output           valid_o
    );

    wire  [28:0] data_sinc3;
    wire  [1:0]  pdm_o;
    
    assign data_o = data_sinc3 >> 5;
    
    pre_process  u_pre_process (
        .clk                     ( sys_clk       ),
        .rstn                    ( sys_rst_n     ),
        .set_sel_i               ( set_sel_i     ),
        .set_sel_val             ( set_sel_val   ),
        .micro_pdm_i             ( micro_pdm_i   ),
    
        .pdm_o                   ( pdm_o         ),
        .micro_clk               ( micro_clk_o   ),
        .sel_lr                  ( sel_lr_o      )
    );
    
    sinc3_0#(
        .M(8))
    sinc3_0
    (
        .rst_l(sys_rst_n),
        .mclk(micro_clk_o),
        .data_in(pdm_o),
        .data_out(data_sinc3),
        .valid_out(valid_o)
    );
    
endmodule

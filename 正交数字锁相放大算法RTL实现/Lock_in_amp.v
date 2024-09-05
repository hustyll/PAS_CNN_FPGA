`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/12 15:12:06
// Design Name: 
// Module Name: Lock_in_amp
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


module Lock_in_amp(
    input sys_clk,
    input sys_rst_n,
    
    input [23:0] Fword,
    input [15:0] mems_data,//400Hz
    
    output          lock_tdata_valid,
    output [23 : 0] lock_tdata
);
    //相敏检波后的输出
    wire [31:0] psd_sin;
    wire [31:0] psd_cos;
    
    //低通滤波器的输出
    wire [47 : 0] fir_sin;
    wire [47 : 0] fir_cos;
    
    //低通滤波器的截位输出
    wire [32 : 0] fir_sin_j;
    wire [32 : 0] fir_cos_j;
    
    wire s_axis_data_tready_sin;
    wire m_axis_data_tvalid_sin;
    wire s_axis_data_tready_cos;
    wire m_axis_data_tvalid_cos;
    
    //滤波器截位输出 截掉小数
    assign fir_sin_j = fir_sin >> 15;
    assign fir_cos_j = fir_cos >> 15;

PSD u_PSD(
    .clk(sys_clk),
    .rstn(sys_rst_n),
    
    .mems_data(mems_data),
    .Fword(Fword),
    
    .data_sin_o(psd_sin),
    .data_cos_o(psd_cos)
);

fir_compiler_lock fil_sin (
  .aclk(sys_clk),                              // input wire aclk
  .s_axis_data_tvalid(1'b1),  // input wire s_axis_data_tvalid
  .s_axis_data_tready(s_axis_data_tready_sin),  // output wire s_axis_data_tready
  .s_axis_data_tdata(psd_sin),    // input wire [31 : 0] s_axis_data_tdata
  .m_axis_data_tvalid(m_axis_data_tvalid_sin),  // output wire m_axis_data_tvalid
  .m_axis_data_tdata(fir_sin)    // output wire [47 : 0] m_axis_data_tdata
);

fir_compiler_lock fil_cos (
  .aclk(sys_clk),                              // input wire aclk
  .s_axis_data_tvalid(1'b1),  // input wire s_axis_data_tvalid
  .s_axis_data_tready(s_axis_data_tready_cos),  // output wire s_axis_data_tready
  .s_axis_data_tdata(psd_cos),    // input wire [31 : 0] s_axis_data_tdata
  .m_axis_data_tvalid(m_axis_data_tvalid_cos),  // output wire m_axis_data_tvalid
  .m_axis_data_tdata(fir_cos)    // output wire [47 : 0] m_axis_data_tdata
);

amp_caculate  u_amp_caculate (
    .clk                     ( sys_clk              ),
    .rstn                    ( sys_rst_n            ),
    .fil_sin_i               ( fir_sin_j            ),
    .fil_cos_i               ( fir_cos_j            ),

    .m_axis_dout_tvalid      ( lock_tdata_valid     ),
    .lock_tdata              ( lock_tdata           )
);

endmodule

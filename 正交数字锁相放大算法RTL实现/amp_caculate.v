`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/22 17:06:54
// Design Name: 
// Module Name: amp_caculate
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


module amp_caculate(
    input clk,
    input rstn,
    
    input [32:0] fil_sin_i,
    input [32:0] fil_cos_i,
    
    output wire m_axis_dout_tvalid,
    output wire [23 : 0] lock_tdata
    );
    
    wire [65 : 0] sin_2;
    wire [65 : 0] cos_2;
    wire [65 : 0] sin_2_logic;
    wire [65 : 0] cos_2_logic;
    wire [39 : 0] s_axis_cartesian_tdata;
    wire [65 : 0] s_axis_cartesian_tdata0;
    wire [23 : 0] m_axis_dout_tdata;
    
    
    assign lock_tdata = m_axis_dout_tdata << 1;
    assign sin_2_logic = sin_2 >> 30;
    assign cos_2_logic = cos_2 >> 30;
    assign s_axis_cartesian_tdata0 = sin_2_logic + cos_2_logic;
    assign s_axis_cartesian_tdata = s_axis_cartesian_tdata0[39:0];

mult_gen_1 mult_sin (
  .CLK(clk),  // input wire CLK
  .A(fil_sin_i),      // input wire [32 : 0] A
  .B(fil_sin_i),      // input wire [32 : 0] B
  .P(sin_2)      // output wire [65 : 0] P
);

mult_gen_1 mult_cos (
  .CLK(clk),  // input wire CLK
  .A(fil_cos_i),      // input wire [32 : 0] A
  .B(fil_cos_i),      // input wire [32 : 0] B
  .P(cos_2)      // output wire [65 : 0] P
);
    
cordic_0 your_instance_name (
      .aclk(clk),                                       // input wire aclk
      .s_axis_cartesian_tvalid(1'b1),                   // input wire s_axis_cartesian_tvalid
      .s_axis_cartesian_tdata(s_axis_cartesian_tdata),  // input wire [39 : 0] s_axis_cartesian_tdata
      .m_axis_dout_tvalid(m_axis_dout_tvalid),          // output wire m_axis_dout_tvalid
      .m_axis_dout_tdata(m_axis_dout_tdata)             // output wire [23 : 0] m_axis_dout_tdata
    ); 
endmodule

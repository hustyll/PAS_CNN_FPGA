`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/26 22:10:17
// Design Name: 
// Module Name: fifo_srteam_test
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


module fifo_srteam_test(
    input wire wr_clk,
    input wire wr_rstn,
    input wire wr_en,
    input wire [15 : 0] wr_data,
    
    output wire [31 : 0] m00_axis_tdata,
    output wire [3 : 0] m00_axis_tstrb,
    output wire m00_axis_tlast,
    output wire m00_axis_tvalid,
    
    input wire m00_axis_aclk,
    input wire m00_axis_aresetn
    );
    
wire m00_axis_tready;

m_fifo_steam_0 m_fifo_steam_1 (
  .wr_clk(wr_clk),                      // input wire wr_clk
  .wr_rstn(wr_rstn),                    // input wire wr_rstn
  .wr_en(wr_en),                        // input wire wr_en
  .wr_data(wr_data),                    // input wire [15 : 0] wr_data
  .m00_axis_tdata(m00_axis_tdata),      // output wire [31 : 0] m00_axis_tdata
  .m00_axis_tstrb(m00_axis_tstrb),      // output wire [3 : 0] m00_axis_tstrb
  .m00_axis_tlast(m00_axis_tlast),      // output wire m00_axis_tlast
  .m00_axis_tvalid(m00_axis_tvalid),    // output wire m00_axis_tvalid
  .m00_axis_tready(m00_axis_tready),    // input wire m00_axis_tready
  .m00_axis_aclk(m00_axis_aclk),        // input wire m00_axis_aclk
  .m00_axis_aresetn(m00_axis_aresetn)  // input wire m00_axis_aresetn
);

s_stream_test_0 s_stream_test_1 (
  .s00_axis_tdata(m00_axis_tdata),      // input wire [31 : 0] s00_axis_tdata
  .s00_axis_tstrb(m00_axis_tstrb),      // input wire [3 : 0] s00_axis_tstrb
  .s00_axis_tlast(m00_axis_tlast),      // input wire s00_axis_tlast
  .s00_axis_tvalid(m00_axis_tvalid),    // input wire s00_axis_tvalid
  .s00_axis_tready(m00_axis_tready),    // output wire s00_axis_tready
  .s00_axis_aclk(m00_axis_aclk),        // input wire s00_axis_aclk
  .s00_axis_aresetn(m00_axis_aresetn)  // input wire s00_axis_aresetn
);
endmodule

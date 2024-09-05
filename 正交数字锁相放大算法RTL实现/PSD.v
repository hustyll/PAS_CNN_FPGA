`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/12 16:24:18
// Design Name: 
// Module Name: PSD
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


module PSD(
    input clk,
    input rstn,
    
    input [15:0] mems_data,
    input [23:0] Fword,
    
    output [31:0] data_sin_o,
    output [31:0] data_cos_o  
);

    wire [15:0] sin_data;
    wire [15:0] cos_data;
    wire [31 : 0] data_s;
    wire [31 : 0] data_c;
    
    assign data_sin_o = data_s;
    assign data_cos_o = data_c;

mult_gen_0 mult_sin (
  .CLK(clk),  // input wire CLK
  .A(mems_data),      // input wire [15 : 0] A
  .B(sin_data),      // input wire [15 : 0] B
  .P(data_s)      // output wire [31 : 0] P
);

mult_gen_0 mult_cos (
  .CLK(clk),  // input wire CLK
  .A(mems_data),      // input wire [15 : 0] A
  .B(cos_data),      // input wire [15 : 0] B
  .P(data_c)      // output wire [31 : 0] P
);

DDS_sin_cos u_DDS_sin_cos(
    .Clk(clk),
    .Reset_n(rstn),
    .Fword(Fword),
    .Data_sin(sin_data),
    .Data_cos(cos_data)
); 
endmodule

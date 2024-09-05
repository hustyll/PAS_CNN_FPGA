`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/20 13:57:08
// Design Name: 
// Module Name: top_11
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


module top_11#(
    parameter WIDTH_DATA    = 16,
    parameter WIDTH_KERNEL  = 8
)(
    // conv_11 Inputs
    input   clk,
    input   rstn,
    input   enable,
    input   [WIDTH_DATA-1:0]  data_in1, 
    input   [WIDTH_DATA-1:0]  data_in2,    
    input   [WIDTH_DATA-1:0]  data_in3,  
    input   [WIDTH_DATA-1:0]  data_in4,   
    input   [WIDTH_DATA-1:0]  data_in5,    
    input   [WIDTH_KERNEL-1:0]  kernel_in1,
    input   [WIDTH_KERNEL-1:0]  kernel_in2,
    input   [WIDTH_KERNEL-1:0]  kernel_in3,
    input   [WIDTH_KERNEL-1:0]  kernel_in4,
    input   [WIDTH_KERNEL-1:0]  kernel_in5,
    input   [WIDTH_KERNEL-1:0]  bias,
    
    output   [WIDTH_DATA + WIDTH_KERNEL +3:0] data_o,
    output   flag_o
    );

// conv_11 Outputs
wire  [WIDTH_DATA + WIDTH_KERNEL +3:0]  data_o1;
wire  flag_o1;
// relu_11 Outputs
wire  [WIDTH_DATA + WIDTH_KERNEL +3:0]  data_o2;
wire  flag_o2;
  
conv_11 #(
        .WIDTH_DATA   ( 16 ),
        .WIDTH_KERNEL ( 8  ))
     u_conv_11 (
        .clk                     ( clk          ),
        .rstn                    ( rstn         ),
        .enable                  ( enable       ),
        .data_in1                ( data_in1     ),
        .data_in2                ( data_in2     ),
        .data_in3                ( data_in3     ),
        .data_in4                ( data_in4     ),
        .data_in5                ( data_in5     ),
        .kernel_in1              ( kernel_in1   ),
        .kernel_in2              ( kernel_in2   ),
        .kernel_in3              ( kernel_in3   ),
        .kernel_in4              ( kernel_in4   ),
        .kernel_in5              ( kernel_in5   ),
        .bias                    ( bias         ),
    
        .data_out                ( data_o1      ),
        .flag_o                  ( flag_o1      )
    );

relu_11 #(
    .WIDTH_DATA   ( 16 ),
    .WIDTH_KERNEL ( 8  ))
 u_relu_11 (
    .clk                     ( clk        ),
    .rstn                    ( rstn       ),
    .valid_i                 ( flag_o1    ),
    .data_i                  ( data_o1    ),

    .data_o                  ( data_o2     ),
    .flag_o                  ( flag_o2     )
);


pooling_11 #(
    .WIDTH_DATA   ( 16 ),
    .WIDTH_KERNEL ( 8  ),
    .POOL_SIZE    ( 4  ))
 u_pooling_11 (
    .clk                     ( clk       ),
    .rstn                    ( rstn      ),
    .valid_i                 ( flag_o2   ),
    .data_i                  ( data_o2   ),

    .data_o                  ( data_o    ),
    .flag_o                  ( flag_o    )
);

endmodule

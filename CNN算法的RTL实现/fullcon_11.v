`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/30 09:58:03
// Design Name: 
// Module Name: fullcon_11
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


module fullcon_11#(
    parameter DEPTH_IN      = 12,
    parameter WIDTH_DATA    = 16,
    parameter WIDTH_KERNEL  = 8
)(
    input clk,
    input rstn,
    input [WIDTH_DATA*DEPTH_IN - 1:0] data_in,
    input [WIDTH_KERNEL*DEPTH_IN - 1:0] kernel_in,
    
    output reg [WIDTH_KERNEL + WIDTH_DATA - 1:0] data_o
    );
    
    wire [WIDTH_DATA - 1:0] data_in0 [DEPTH_IN - 1:0];
    wire [WIDTH_KERNEL - 1:0] kernel_in0 [DEPTH_IN - 1:0];
    wire [WIDTH_KERNEL + WIDTH_DATA - 1:0] data_reg [DEPTH_IN - 1:0];
    wire [WIDTH_KERNEL + WIDTH_DATA - 1:0] sum;
    
    assign sum[0] = data_reg[0];
    
    genvar i;
    generate
        for(i = 0;i<DEPTH_IN;i=i+1)
        begin
            assign data_in0[i] = data_in[(i+1)*WIDTH_DATA-1:i*WIDTH_DATA];
            assign kernel_in0[i] = kernel_in[(i+1)*WIDTH_DATA-1:i*WIDTH_DATA];
            assign data_reg[i] = kernel_in0[i]*data_in0[i];
        end
    endgenerate
    
    genvar k;
    generate
        for(k = 1;k<DEPTH_IN;k=k+1)
        begin
            assign sum[k] = sum[k-1] + data_reg[k];
        end
    endgenerate
 
    always@(posedge clk or negedge rstn)begin
        if(!rstn)begin
            data_o <= 0;
        end
        else begin
            data_o <= sum;
        end
    end
endmodule

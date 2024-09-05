`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/19 09:43:15
// Design Name: 
// Module Name: relu_11
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


module relu_11#(
    parameter WIDTH_DATA = 16,
    parameter WIDTH_KERNEL = 8
)(
    input clk,
    input rstn,
    
    input valid_i,
    input [WIDTH_DATA + WIDTH_KERNEL +3:0] data_i,
    output reg [WIDTH_DATA + WIDTH_KERNEL +3:0] data_o,
    output reg flag_o
    );

always@(posedge clk or negedge rstn)
    if(!rstn)begin
        data_o <= 0;
        flag_o <= 0;
    end
    else if(valid_i)begin
        flag_o <= 1;
        if(~data_i[WIDTH_DATA + WIDTH_KERNEL +3])
           data_o <= data_i;
        else 
           data_o <= 0;
     end
     else begin
        flag_o <= 0;
        data_o <= 0;
     end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/19 09:53:44
// Design Name: 
// Module Name: pooling_11
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


module pooling_11#(
    parameter WIDTH_DATA = 16,
    parameter WIDTH_KERNEL = 8,
    parameter POOL_SIZE = 4
    )(
    input clk,
    input rstn,
    
    input  valid_i,
    input [WIDTH_DATA + WIDTH_KERNEL +3:0] data_i,
    
    output reg  [WIDTH_DATA + WIDTH_KERNEL +3:0] data_o,
    output reg flag_o
    );
    
    reg  [2*WIDTH_DATA + 2*WIDTH_KERNEL +7:0] data2;
    reg  [$clog2(POOL_SIZE):0] cnt;
    reg  busy;
    
    //计数器计数
    always@(posedge clk or negedge rstn)
        if(!rstn)begin
            cnt <= 0;
        end
        else if(cnt == POOL_SIZE - 1)begin
            cnt <= 0;
        end
        else if(valid_i)begin
            cnt <= cnt + 1;
        end
        else begin
            cnt <= 0;
        end
    
    //将两个数大的存入data2的高字节
    always@(posedge clk or negedge rstn)
        if(!rstn)begin
            data2 <= 0;
            busy <= 0;
        end
        else if(valid_i)begin
            busy <= 1;
            if(cnt == 0)begin
                data2 <= {{(WIDTH_DATA + WIDTH_KERNEL +4){1'b0}},data_i}; 
            end
            else if(data2[WIDTH_DATA + WIDTH_KERNEL +3:0] < data2[2*WIDTH_DATA + 2*WIDTH_KERNEL +7:WIDTH_DATA + WIDTH_KERNEL +4])begin
                data2 <= {data2[2*WIDTH_DATA + 2*WIDTH_KERNEL +7:WIDTH_DATA + WIDTH_KERNEL +4],data_i}; 
            end
            else begin
                data2 <= {data2[WIDTH_DATA + WIDTH_KERNEL +3:0],data_i}; 
            end
        end
        else begin
            busy <= busy;
            data2 <= data2;
        end
    
    //控制输出
    always@(posedge clk or negedge rstn)
        if(!rstn)begin
            data_o <= 0;
            flag_o <= 0;
        end
        else if(busy&&(cnt == 0))begin
            flag_o <= 1;
            if(data2[WIDTH_DATA + WIDTH_KERNEL +3:0] > data2[2*WIDTH_DATA + 2*WIDTH_KERNEL +7:WIDTH_DATA + WIDTH_KERNEL +4])
                data_o <= data2[WIDTH_DATA + WIDTH_KERNEL +3:0]; 
            else
                data_o <= data2[2*WIDTH_DATA + 2*WIDTH_KERNEL +7:WIDTH_DATA + WIDTH_KERNEL +4];
        end
        else begin
            data_o <= data_o;
            flag_o <= 0;
        end
endmodule

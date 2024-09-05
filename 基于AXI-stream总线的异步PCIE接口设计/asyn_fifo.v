`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/23 16:36:58
// Design Name: 
// Module Name: asyn_fifo
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


module asyn_fifo#(
    parameter WDATA_WIDTH = 16,
    parameter RDATA_WIDTH = 16,
    parameter WFIFO_DEPTH = 1024 , //写深度
    parameter RFIFO_DEPTH = (WFIFO_DEPTH*WDATA_WIDTH)/RDATA_WIDTH
)(
    //写端口
    input wr_clk,//写时钟
    input wr_rstn,//写复位
    input wr_en,//写使能
    input [WDATA_WIDTH - 1:0] wr_data,//写数据
    
    //读端口
    input  rd_clk,//读时钟
    input  rd_rstn,//读复位
    input  rd_en,//读使能
    output reg [RDATA_WIDTH - 1:0] rd_data,//读数据
    
    //满空
    output empty,//读空
    output full//写满
);

localparam DATA_WIDTH = (WDATA_WIDTH>RDATA_WIDTH) ? RDATA_WIDTH : WDATA_WIDTH;//小的作为存储器位宽
localparam FIFO_DEPTH = (WDATA_WIDTH>RDATA_WIDTH) ? RFIFO_DEPTH : WFIFO_DEPTH;
localparam WR_BURST_LEN = (WDATA_WIDTH>RDATA_WIDTH) ? (WDATA_WIDTH/RDATA_WIDTH) : 1'b1;
localparam RD_BURST_LEN = (RDATA_WIDTH>WDATA_WIDTH) ? (RDATA_WIDTH/WDATA_WIDTH) : 1'b1;

//用二维数组实现RAM
reg [DATA_WIDTH - 1 : 0] fifo_buffer [FIFO_DEPTH - 1 : 0];

reg [$clog2(FIFO_DEPTH) : 0]wr_ptr;//二进制ram写地址,位宽拓展一位
reg [$clog2(FIFO_DEPTH) : 0]rd_ptr;//二进制ram读地址
reg [$clog2(FIFO_DEPTH) : 0]wr_ptr_g;//格雷码写地址指针
reg [$clog2(FIFO_DEPTH) : 0]rd_ptr_g;//格雷码读地址指针
reg [$clog2(FIFO_DEPTH) : 0]rd_ptr_d0;//读地址同步寄存器1
reg [$clog2(FIFO_DEPTH) : 0]rd_ptr_d1;//读地址同步寄存器2
reg [$clog2(FIFO_DEPTH) : 0]wr_ptr_d0;//写地址同步寄存器1
reg [$clog2(FIFO_DEPTH) : 0]wr_ptr_d1;//写地址同步寄存器2

//wire define
wire [$clog2(FIFO_DEPTH) : 0]wr_ptr_gray;//格雷码写地址指针
wire [$clog2(FIFO_DEPTH) : 0]rd_ptr_gray;//格雷码读地址指针
wire [$clog2(FIFO_DEPTH) - 1 : 0]wr_ptr_ram;//写地址指针，未扩展的真实地址
wire [$clog2(FIFO_DEPTH) - 1 : 0]rd_ptr_ram;//读地址指针

//真实地址
assign wr_ptr_ram = wr_ptr[$clog2(FIFO_DEPTH) - 1 : 0];
assign rd_ptr_ram = rd_ptr[$clog2(FIFO_DEPTH) - 1 : 0];

//二进制地址转格雷码
assign wr_ptr_gray = wr_ptr_g^(wr_ptr_g >> 1);
assign rd_ptr_gray = rd_ptr_g^(rd_ptr_g >> 1);

//写指针和写数据更新
integer w = 0;
always@(posedge wr_clk or negedge wr_rstn)begin
    if(!wr_rstn)begin
        wr_ptr <= 0;
        wr_ptr_g <= 0;
    end
    else if(!full&&wr_en)begin
        wr_ptr <= wr_ptr + WR_BURST_LEN;
        wr_ptr_g <= (wr_ptr + WR_BURST_LEN)/RD_BURST_LEN*RD_BURST_LEN;
        for(w = 0;w<WR_BURST_LEN;w = w + 1)begin
            fifo_buffer[wr_ptr_ram + w] <= wr_data[w*DATA_WIDTH +: DATA_WIDTH];
        end
    end
    else begin
        wr_ptr <= wr_ptr;
        wr_ptr_g <= wr_ptr_g;
    end
end

//读地址同步到写时钟域
always@(posedge wr_clk or negedge wr_rstn)begin
    if(!wr_rstn)begin
        rd_ptr_d0 <= 0;
        rd_ptr_d1 <= 0;
    end
    else begin
        rd_ptr_d0 <= rd_ptr_gray;
        rd_ptr_d1 <= rd_ptr_d0;
    end
end

//读指针和读数据更新
integer r = 0;
always@(posedge rd_clk or negedge rd_rstn)begin
    if(!rd_rstn)begin
        rd_ptr <= 0;
        rd_ptr_g <= 0;
        rd_data <= 0;
    end
    else if(!empty&&rd_en)begin
        rd_ptr <= rd_ptr + RD_BURST_LEN;
        rd_ptr_g <= (rd_ptr + RD_BURST_LEN)/WR_BURST_LEN*WR_BURST_LEN;
        for(r = 0;r<RD_BURST_LEN;r = r + 1)begin
            rd_data[r*DATA_WIDTH +: DATA_WIDTH] <= fifo_buffer[rd_ptr_ram + r];
        end
    end
    else begin
        rd_ptr <= rd_ptr;
        rd_ptr_g <= rd_ptr_g;
        rd_data <= 0;
    end
end

//写地址同步到读时钟域
always@(posedge rd_clk or negedge rd_rstn)begin
    if(!rd_rstn)begin
        wr_ptr_d0 <= 0;
        wr_ptr_d1 <= 0;
    end
    else begin
        wr_ptr_d0 <= wr_ptr_gray;
        wr_ptr_d1 <= wr_ptr_d0;
    end
end

//读空判断
assign empty = (wr_ptr_d1 == rd_ptr_gray)?1:0;
//写满判断
assign full = ({~rd_ptr_d1[$clog2(FIFO_DEPTH):$clog2(FIFO_DEPTH) - 1],rd_ptr_d1[$clog2(FIFO_DEPTH) - 2:0]} == wr_ptr_gray)?1:0;

endmodule

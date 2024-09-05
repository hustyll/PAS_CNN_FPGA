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
    parameter WFIFO_DEPTH = 1024 , //д���
    parameter RFIFO_DEPTH = (WFIFO_DEPTH*WDATA_WIDTH)/RDATA_WIDTH
)(
    //д�˿�
    input wr_clk,//дʱ��
    input wr_rstn,//д��λ
    input wr_en,//дʹ��
    input [WDATA_WIDTH - 1:0] wr_data,//д����
    
    //���˿�
    input  rd_clk,//��ʱ��
    input  rd_rstn,//����λ
    input  rd_en,//��ʹ��
    output reg [RDATA_WIDTH - 1:0] rd_data,//������
    
    //����
    output empty,//����
    output full//д��
);

localparam DATA_WIDTH = (WDATA_WIDTH>RDATA_WIDTH) ? RDATA_WIDTH : WDATA_WIDTH;//С����Ϊ�洢��λ��
localparam FIFO_DEPTH = (WDATA_WIDTH>RDATA_WIDTH) ? RFIFO_DEPTH : WFIFO_DEPTH;
localparam WR_BURST_LEN = (WDATA_WIDTH>RDATA_WIDTH) ? (WDATA_WIDTH/RDATA_WIDTH) : 1'b1;
localparam RD_BURST_LEN = (RDATA_WIDTH>WDATA_WIDTH) ? (RDATA_WIDTH/WDATA_WIDTH) : 1'b1;

//�ö�ά����ʵ��RAM
reg [DATA_WIDTH - 1 : 0] fifo_buffer [FIFO_DEPTH - 1 : 0];

reg [$clog2(FIFO_DEPTH) : 0]wr_ptr;//������ramд��ַ,λ����չһλ
reg [$clog2(FIFO_DEPTH) : 0]rd_ptr;//������ram����ַ
reg [$clog2(FIFO_DEPTH) : 0]wr_ptr_g;//������д��ַָ��
reg [$clog2(FIFO_DEPTH) : 0]rd_ptr_g;//���������ַָ��
reg [$clog2(FIFO_DEPTH) : 0]rd_ptr_d0;//����ַͬ���Ĵ���1
reg [$clog2(FIFO_DEPTH) : 0]rd_ptr_d1;//����ַͬ���Ĵ���2
reg [$clog2(FIFO_DEPTH) : 0]wr_ptr_d0;//д��ַͬ���Ĵ���1
reg [$clog2(FIFO_DEPTH) : 0]wr_ptr_d1;//д��ַͬ���Ĵ���2

//wire define
wire [$clog2(FIFO_DEPTH) : 0]wr_ptr_gray;//������д��ַָ��
wire [$clog2(FIFO_DEPTH) : 0]rd_ptr_gray;//���������ַָ��
wire [$clog2(FIFO_DEPTH) - 1 : 0]wr_ptr_ram;//д��ַָ�룬δ��չ����ʵ��ַ
wire [$clog2(FIFO_DEPTH) - 1 : 0]rd_ptr_ram;//����ַָ��

//��ʵ��ַ
assign wr_ptr_ram = wr_ptr[$clog2(FIFO_DEPTH) - 1 : 0];
assign rd_ptr_ram = rd_ptr[$clog2(FIFO_DEPTH) - 1 : 0];

//�����Ƶ�ַת������
assign wr_ptr_gray = wr_ptr_g^(wr_ptr_g >> 1);
assign rd_ptr_gray = rd_ptr_g^(rd_ptr_g >> 1);

//дָ���д���ݸ���
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

//����ַͬ����дʱ����
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

//��ָ��Ͷ����ݸ���
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

//д��ַͬ������ʱ����
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

//�����ж�
assign empty = (wr_ptr_d1 == rd_ptr_gray)?1:0;
//д���ж�
assign full = ({~rd_ptr_d1[$clog2(FIFO_DEPTH):$clog2(FIFO_DEPTH) - 1],rd_ptr_d1[$clog2(FIFO_DEPTH) - 2:0]} == wr_ptr_gray)?1:0;

endmodule

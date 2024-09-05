`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/26 22:14:47
// Design Name: 
// Module Name: tb_stream_fifo
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


module tb_stream_fifo();
// fifo_srteam_test Inputs
reg   wr_clk;
reg   wr_rstn;
reg   wr_en;
reg   [15 : 0]  wr_data;  
reg   m00_axis_tready;    
reg   m00_axis_aclk;      
reg   m00_axis_aresetn;   

// fifo_srteam_test Outputs
wire  [31 : 0]  m00_axis_tdata;
wire  [3 : 0]  m00_axis_tstrb;
wire  m00_axis_tlast;
wire  m00_axis_tvalid;
initial begin
    wr_clk = 0;
    wr_rstn = 0;
    wr_en = 0;
    wr_data = 0;
    m00_axis_aclk = 0;
    m00_axis_aresetn = 0;
    m00_axis_tready = 1;
    
    #20
    wr_rstn = 1;
    m00_axis_aresetn = 1;
    
    //重复64次写操作，让FIFO写满     
    repeat(1024) begin
        @(negedge wr_clk)begin        
            wr_en <= 1'b1;
            wr_data <= $random;    //生成8位随机数
        end
    end  
end

always #10 wr_clk = ~wr_clk;
always #5  m00_axis_aclk = ~m00_axis_aclk;


fifo_srteam_test  u_fifo_srteam_test (
    .wr_clk                  ( wr_clk             ),
    .wr_rstn                 ( wr_rstn            ),
    .wr_en                   ( wr_en              ),
    .wr_data                 ( wr_data            ),
    .m00_axis_aclk           ( m00_axis_aclk      ),
    .m00_axis_aresetn        ( m00_axis_aresetn   ),

    .m00_axis_tdata          ( m00_axis_tdata     ),
    .m00_axis_tstrb          ( m00_axis_tstrb     ),
    .m00_axis_tlast          ( m00_axis_tlast     ),
    .m00_axis_tvalid         ( m00_axis_tvalid    )
);

endmodule

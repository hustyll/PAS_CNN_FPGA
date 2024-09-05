`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/17 14:40:55
// Design Name: 
// Module Name: sinc3
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


module sinc3(
	rst_l,
	mclk,
	data_in,
	data_out,
	M
);

input rst_l;
input mclk;
input data_in;
output reg [24:0] data_out;
input [3:0] M;

wire [24:0] int1_out;
wire [24:0] int2_out;
wire [24:0] int3_out;
wire [24:0] diff1_out;
wire [24:0] diff2_out;
wire [24:0] diff3_out;
reg [24:0] int_out_reg;
reg data_in_reg;
reg data_in_reg1;
reg deci_clk_reg;
reg deci_clk_reg1;
wire posedge_deci_clk_reg;
reg [9:0] deci_counter;

always@(posedge mclk or negedge rst_l)
begin
	if(~rst_l)
	begin
		data_in_reg  <= 1'b0;
		data_in_reg1 <= 1'b0;
		deci_counter <= 10'd0;
	end
	else
	begin
		data_in_reg  <= data_in;
		data_in_reg1 <= data_in_reg;
		deci_counter <= deci_counter + 10'd1;
		
	end
end

always@(posedge mclk or negedge rst_l)
begin
	if(~rst_l)
	begin
		int_out_reg <= 24'd0;
		data_out <= 24'd0;
	end
	else
	begin
	    if(posedge_deci_clk_reg == 1'b1) begin
            int_out_reg <= int3_out;
            data_out    <= diff3_out;
		end else begin
            int_out_reg <= int_out_reg;
            data_out    <= data_out;
		end
	end
end

always@(posedge mclk or negedge rst_l)
begin
if(~rst_l)
	begin
		deci_clk_reg  <= 1'b0;
		deci_clk_reg1 <= 1'b0;
	end
	else
	begin
		deci_clk_reg  <= deci_counter[M];
		deci_clk_reg1 <= deci_clk_reg;
	end
end
assign posedge_deci_clk_reg = deci_clk_reg & (~deci_clk_reg1);

integrator_0 int1(rst_l, mclk, {24'b0, data_in_reg1}, int1_out);
integrator_0 int2(rst_l, mclk, int1_out, int2_out);
integrator_0 int3(rst_l, mclk, int2_out, int3_out);
differentiator_0 diff1(rst_l, mclk, posedge_deci_clk_reg, int_out_reg, diff1_out);
differentiator_0 diff2(rst_l, mclk, posedge_deci_clk_reg, diff1_out, diff2_out);
differentiator_0 diff3(rst_l, mclk, posedge_deci_clk_reg, diff2_out, diff3_out);

endmodule

/////////////////////////////////// integrator
module integrator_0
(
	rst_l,
	clk,
	data_in,
	data_out
);

input rst_l;
input clk;
input [24:0] data_in;
output reg [24:0] data_out;

always@(posedge clk  or negedge rst_l)
begin
	if(~rst_l)
	begin
		data_out <= 25'd0;
	end
	else
	begin
		data_out <= data_out + data_in;
	end
end

endmodule

/////////////////////////////////// differentiator
module differentiator_0
(
	rst_l,
	clk,
	enable,
	data_in,
	data_out
);

input rst_l;
input clk;
input enable;
input [24:0] data_in;
output wire [24:0] data_out;

reg [24:0] data_in_reg;

assign data_out = data_in - data_in_reg;
always@(posedge clk or negedge rst_l)
begin
	if(~rst_l)
	begin
		data_in_reg <= 25'd0;
	end
	else
	begin
	    if(enable == 1'b1) begin
		    data_in_reg <= data_in;
		end
		else begin
		    data_in_reg <= data_in_reg;
		end
	end
end

endmodule

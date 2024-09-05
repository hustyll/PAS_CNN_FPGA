module conv_11
#(
    parameter WIDTH_DATA = 16,
    parameter WIDTH_KERNEL = 8
)
(
    input   clk,
    input   rstn,
    input   enable,
    input   [WIDTH_DATA-1:0]   data_in1,
    input   [WIDTH_DATA-1:0]   data_in2,
    input   [WIDTH_DATA-1:0]   data_in3,
    input   [WIDTH_DATA-1:0]   data_in4,
    input   [WIDTH_DATA-1:0]   data_in5,

    input   [WIDTH_KERNEL-1:0]   kernel_in1,
    input   [WIDTH_KERNEL-1:0]   kernel_in2,
    input   [WIDTH_KERNEL-1:0]   kernel_in3,
    input   [WIDTH_KERNEL-1:0]   kernel_in4,
    input   [WIDTH_KERNEL-1:0]   kernel_in5,
    
    input   [WIDTH_KERNEL-1:0] bias,//鍋忕�?

    output  reg [WIDTH_DATA + WIDTH_KERNEL +3:0] data_out,
    output  reg flag_o
);
wire   valid_o1;
wire   valid_o2;
wire   valid_o3;
wire   valid_o4;
wire   valid_o5;
wire   valid_o6;
wire   valid_o7;
wire   valid_o8;
wire   enable1;
wire   enable2;
wire   [WIDTH_DATA + WIDTH_KERNEL -1:0] data_out1;
wire   [WIDTH_DATA + WIDTH_KERNEL -1:0] data_out2;
wire   [WIDTH_DATA + WIDTH_KERNEL -1:0] data_out3;
wire   [WIDTH_DATA + WIDTH_KERNEL -1:0] data_out4;
wire   [WIDTH_DATA + WIDTH_KERNEL -1:0] data_out5;

wire   [WIDTH_DATA + WIDTH_KERNEL   :0] data_out6;
wire   [WIDTH_DATA + WIDTH_KERNEL +1:0] data_out7;
wire   [WIDTH_DATA + WIDTH_KERNEL +2:0] data_out8;

assign enable1 = valid_o1&&valid_o2&&valid_o3&&valid_o4&&valid_o5;
assign enable2 = valid_o6&&valid_o7;

always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        data_out <= 0;
        flag_o <= 0;
    end
    else if(valid_o8)begin
        data_out <= data_out8 + {{(WIDTH_DATA + 3){bias[WIDTH_KERNEL - 1]}},bias};
        flag_o <= 1;
    end
    else begin
        data_out <= 0;
        flag_o <= 0;
    end
end

mult#(
    .WIDTH_DATA(WIDTH_DATA),
    .WIDTH_KERNEL(WIDTH_KERNEL)
)mult1(
    .clk(clk),
    .rstn(rstn),
    .enable(enable),
    .data_in(data_in1),
    .kernel_in(kernel_in1),
    .data_out(data_out1),
    .valid_o(valid_o1)
);

mult#(
    .WIDTH_DATA(WIDTH_DATA),
    .WIDTH_KERNEL(WIDTH_KERNEL)
)mult2(
    .clk(clk),
    .rstn(rstn),
    .enable(enable),
    .data_in(data_in2),
    .kernel_in(kernel_in2),
    .data_out(data_out2),
    .valid_o(valid_o2)
);

mult#(
    .WIDTH_DATA(WIDTH_DATA),
    .WIDTH_KERNEL(WIDTH_KERNEL)
)mult3(
    .clk(clk),
    .rstn(rstn),
    .enable(enable),
    .data_in(data_in3),
    .kernel_in(kernel_in3),
    .data_out(data_out3),
    .valid_o(valid_o3)
);

mult#(
    .WIDTH_DATA(WIDTH_DATA),
    .WIDTH_KERNEL(WIDTH_KERNEL)
)mult4(
    .clk(clk),
    .rstn(rstn),
    .enable(enable),
    .data_in(data_in4),
    .kernel_in(kernel_in4),
    .data_out(data_out4),
    .valid_o(valid_o4)
);

mult#(
    .WIDTH_DATA(WIDTH_DATA),
    .WIDTH_KERNEL(WIDTH_KERNEL)
)mult5(
    .clk(clk),
    .rstn(rstn),
    .enable(enable),
    .data_in(data_in5),
    .kernel_in(kernel_in5),
    .data_out(data_out5),
    .valid_o(valid_o5)
);

add2#(
    .WIDTH_DATA(WIDTH_DATA),
    .WIDTH_KERNEL(WIDTH_KERNEL)
)add2(
    .clk(clk),
    .rstn(rstn),
    .enable(enable1),
    .data_in1(data_out1),
    .data_in2(data_out2),
    .data_out(data_out6),
    .valid_o(valid_o6)
);

add3#(
    .WIDTH_DATA(WIDTH_DATA),
    .WIDTH_KERNEL(WIDTH_KERNEL)
)add3(
    .clk(clk),
    .rstn(rstn),
    .enable(enable1),
    .data_in1(data_out3),
    .data_in2(data_out4),
    .data_in3(data_out5),
    .data_out(data_out7),
    .valid_o(valid_o7)
);

add4#(
    .WIDTH_DATA(WIDTH_DATA),
    .WIDTH_KERNEL(WIDTH_KERNEL)
)add4(
    .clk(clk),
    .rstn(rstn),
    .enable(enable2),
    .data_in1(data_out6),
    .data_in2(data_out7),
    .data_out(data_out8),
    .valid_o(valid_o8)
);
endmodule

//mult
module mult#(
    parameter WIDTH_DATA = 16,
    parameter WIDTH_KERNEL = 8
)(
    input   clk,
    input   rstn,
    input   enable,
    input   signed [WIDTH_DATA-1:0] data_in,
    input   signed [WIDTH_KERNEL-1:0] kernel_in,
    output  reg signed [WIDTH_DATA + WIDTH_KERNEL - 1:0] data_out,
    output  reg valid_o
);

always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        data_out <= 0;
        valid_o <= 0;
    end
    else if(enable)begin
        data_out <= data_in*kernel_in;
        valid_o <= 1;
    end
    else begin
        data_out <= 0;
        valid_o <= 0;
    end
end
endmodule

//add2
module add2#(
    parameter WIDTH_DATA = 16,
    parameter WIDTH_KERNEL = 8
)(
    input   clk,
    input   rstn,
    input   enable,
    input   signed [WIDTH_DATA + WIDTH_KERNEL-1:0] data_in1,
    input   signed [WIDTH_DATA + WIDTH_KERNEL-1:0] data_in2,
    output   reg signed [WIDTH_DATA + WIDTH_KERNEL:0] data_out,
    output   reg valid_o
);
always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        data_out <= 0;
        valid_o <= 0;
    end
    else if(enable)begin
        data_out <= data_in1 + data_in2;
        valid_o <= 1;
    end
    else begin
        data_out <= 0;
        valid_o <= 0;
    end
end
endmodule

//add3
module add3#(
    parameter WIDTH_DATA = 16,
    parameter WIDTH_KERNEL = 8
)(
    input   clk,
    input   rstn,
    input   enable,
    input   signed [WIDTH_DATA + WIDTH_KERNEL-1:0] data_in1,
    input   signed [WIDTH_DATA + WIDTH_KERNEL-1:0] data_in2,
    input   signed [WIDTH_DATA + WIDTH_KERNEL-1:0] data_in3,
    output  reg signed [WIDTH_DATA + WIDTH_KERNEL + 1:0] data_out,
    output  reg valid_o
);
always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        data_out <= 0;
        valid_o <= 0;
    end
    else if(enable)begin
        data_out <= data_in1 + data_in2 + data_in3;
        valid_o <= 1;
    end
    else begin
        data_out <= 0;
        valid_o <= 0;
    end
end
endmodule


//add4
module add4#(
    parameter WIDTH_DATA = 16,
    parameter WIDTH_KERNEL = 8
)(
    input   clk,
    input   rstn,
    input   enable,
    input   signed [WIDTH_DATA + WIDTH_KERNEL:0] data_in1,
    input   signed [WIDTH_DATA + WIDTH_KERNEL + 1:0] data_in2,
    output  reg signed [WIDTH_DATA + WIDTH_KERNEL + 2:0] data_out,
    output  reg valid_o
);
always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        data_out <= 0;
        valid_o <= 0;
    end
    else if(enable)begin
        data_out <= {data_in1[WIDTH_DATA + WIDTH_KERNEL],data_in1} + data_in2;
        valid_o <= 1;
    end
    else begin
        data_out <= 0;
        valid_o <= 0;
    end
end
endmodule
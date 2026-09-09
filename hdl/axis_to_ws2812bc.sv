module axis_to_ws2812bc #(
    // Clock frequency in Hz
    parameter FREQ_HZ = 100000000,

    // AXI-S Data bus format
    parameter TDATA_WIDTH = 24,
    parameter COLOR_WIDTH = 8,
    parameter R_START_INDEX = 16,
    parameter G_START_INDEX = 8,
    parameter B_START_INDEX = 0,

    // FIFO Params
    parameter FIFO_DEPTH = 1024
) (
    // Clock and reset
    input logic aclk,
    input logic aresetn,

    // AXI-S
    input logic [TDATA_WIDTH-1:0] tdata,
    input logic tvalid,
    input logic tlast,
    output logic tready,

    // WS2812B/C data
    output logic Dout
);

logic [TDATA_WIDTH:0] fifo_data_in;
logic [TDATA_WIDTH:0] fifo_data_out;
logic fifo_pop;
logic fifo_empty;

logic [TDATA_WIDTH-1:0] color_data_out;
logic end_frame_out;

logic [3*COLOR_WIDTH-1:0] grb_color;

assign fifo_data_in = {tlast, tdata};
assign end_frame_out = fifo_data_out[TDATA_WIDTH];
assign color_data_out = fifo_data_out[TDATA_WIDTH-1:0];

assign grb_color[3*COLOR_WIDTH-1:2*COLOR_WIDTH] = color_data_out[G_START_INDEX+COLOR_WIDTH-1:G_START_INDEX];
assign grb_color[2*COLOR_WIDTH-1:COLOR_WIDTH] = color_data_out[R_START_INDEX+COLOR_WIDTH-1:R_START_INDEX];
assign grb_color[COLOR_WIDTH-1:0] = color_data_out[B_START_INDEX+COLOR_WIDTH-1:B_START_INDEX];


olo_base_fifo_sync # (
    .Width_g(TDATA_WIDTH+1),
    .Depth_g(FIFO_DEPTH),
    .AlmFullOn_g(1),
    .AlmFullLevel_g(1)
) fifo (
    // Control Ports
    .Clk(aclk),
    .Rst(~aresetn),
    // Input Data
    .In_Data(fifo_data_in),
    .In_Valid(tvalid),
    .In_Ready(tready),
    .In_Level(),
    // Output Data
    .Out_Data(fifo_data_out),
    .Out_Valid(),
    .Out_Ready(fifo_pop),
    .Out_Level(),
    // Status
    .Full(),
    .AlmFull(),
    .Empty(fifo_empty),
    .AlmEmpty()
);

ws2812bc_master_parallel_in #(
    // Clock frequency in Hz
    .FREQ_HZ(FREQ_HZ),
    .DATA_WIDTH(TDATA_WIDTH)
) ws_master_parallel (
    // Clock and reset
    .clk(aclk),
    .resetn(aresetn),

    // Control signals
    .grb_color(grb_color),
    .end_frame(end_frame_out),
    .color_empty(fifo_empty),
    .color_pop(fifo_pop),

    // WS2812B/C data
    .Dout(Dout)
);

endmodule
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
    parameter FIFO_DEPTH = 1024,

    // Calculated params
    parameter TSTRB_WIDTH = $clog2(TDATA_WIDTH)
) (
    // Clock and reset
    input logic aclk,
    input logic aresetn,

    // AXI-S
    input logic [TDATA_WIDTH-1:0] tdata,
    input logic [TSTRB_WIDTH-1:0] tstrb,
    input logic tvalid,
    input logic tlast,
    output logic tready,

    // WS2812B/C data
    output logic Dout
);

logic [TDATA_WIDTH:0] fifo_data_in;
logic [TDATA_WIDTH:0] fifo_data_out;
logic fifo_push;
logic fifo_pop;
logic fifo_full;
logic fifo_afull;
logic fifo_empty;

logic [TDATA_WIDTH-1:0] color_data_in;
logic end_frame_in;
logic [TDATA_WIDTH-1:0] color_data_out;
logic end_frame_out;

logic [3*COLOR_WIDTH-1:0] grb_color;

assign fifo_data_in = {end_frame_in, color_data_in};
assign end_frame_out = fifo_data_out[TDATA_WIDTH];
assign color_data_out = fifo_data_out[TDATA_WIDTH-1:0];

assign grb_color[3*COLOR_WIDTH-1:2*COLOR_WIDTH] = color_data_out[G_START_INDEX+COLOR_WIDTH-1:G_START_INDEX];
assign grb_color[2*COLOR_WIDTH-1:COLOR_WIDTH] = color_data_out[R_START_INDEX+COLOR_WIDTH-1:R_START_INDEX];
assign grb_color[COLOR_WIDTH-1:0] = color_data_out[B_START_INDEX+COLOR_WIDTH-1:B_START_INDEX];


axis_slave_to_fifo #(
    .TDATA_WIDTH(TDATA_WIDTH)
) axis_slave (
    // Clock and reset
    .aclk(aclk),
    .aresetn(aresetn),

    // AXI-S
    .tdata(tdata),
    .tstrb(tstrb),
    .tvalid(tvalid),
    .tlast(tlast),
    .tready(tready),

    // To FIFO
    .data_out_full(fifo_full),
    .data_out_afull(fifo_afull),
    .data_out(color_data_in),
    .last_data(end_frame_in),
    .data_out_push(fifo_push)
);

oh_fifo_sync #(
    .N(TDATA_WIDTH+1),      //FIFO width
	.DEPTH(FIFO_DEPTH),       //FIFO depth
    .REG(1)
) fifo (
    //basic interface
    .clk(aclk), // clock
    .nreset(aresetn), // active high async reset 
    .clear(1'b0), //clear fifo statemachine (sync)
    //write port
    .wr_din(fifo_data_in), // data to write
    .wr_en(fifo_push), // write fifo
    .wr_full(fifo_full), // fifo full
    .wr_almost_full(fifo_afull), //one entry left
    .wr_prog_full(), // fifo is almost full
    //read port
    .rd_dout(fifo_data_out), // output data (next cycle)
    .rd_en(fifo_pop), // read fifo
    .rd_empty(fifo_empty), // fifo is empty 
    // BIST interface
    .bist_en(1'b0), // bist enable
    .bist_we(1'b0), // write enable global signal
    .bist_wem('b0), // write enable vector
    .bist_addr('b0), // address
    .bist_din('b0), // data input
    .bist_dout('b0), // data input
    // Power/repair (hard macro only)
    .shutdown(1'b0), // shutdown signal
    .vss(1'b0), // ground signal
    .vdd(1'b1), // memory array power
    .vddio(1'b0), // periphery/io power
    .memconfig('b0), // generic memory config
    .memrepair('b0) // repair vector
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
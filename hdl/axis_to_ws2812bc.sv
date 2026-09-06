module axis_to_ws2812bc #(
    // Clock frequency in Hz
    parameter FREQ_HZ = 100000000,

    // AXI-S Data bus format
    parameter TDATA_WIDTH = 24,
    parameter TSTRB_WIDTH = 3,
    parameter R_BYTE_INDEX = 2,
    parameter G_BYTE_INDEX = 1,
    parameter B_BYTE_INDEX = 0,

    // FIFO Params
    parameter FIFO_DEPTH = 1024
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

logic [1:0] serial_fifo_data_in;
logic [1:0] serial_fifo_data_out;
logic serial_fifo_push;
logic serial_fifo_pop;
logic serial_fifo_full;
logic serial_fifo_empty;

logic color_data_serial_in;
logic end_frame_in;
logic color_data_serial_out;
logic end_frame_out;

assign serial_fifo_data_in = {end_frame_in, color_data_serial_in};
assign end_frame_out = serial_fifo_data_out[1];
assign color_data_serial_out = serial_fifo_data_out[0];

axis_slave_ws2812bc #(
    .TDATA_WIDTH(TDATA_WIDTH),
    .TSTRB_WIDTH(TSTRB_WIDTH),
    .R_BYTE_INDEX(R_BYTE_INDEX),
    .G_BYTE_INDEX(G_BYTE_INDEX),
    .B_BYTE_INDEX(B_BYTE_INDEX)
) 
axis_slave (
    // Clock and reset
    .aclk(aclk),
    .aresetn(aresetn),

    // AXI-S
    .tdata(tdata),
    .tstrb(tstrb),
    .tvalid(tvalid),
    .tlast(tlast),
    .tready(tready),

    // Serializer/FIFO
    .serial_data_full(serial_data_full),
    .color_data_serial(color_data_serial_in),
    .end_frame(end_frame_in),
    .serial_data_push(serial_data_push)
);

oh_fifo_sync #(
    .N(2),      //FIFO width
	.DEPTH(FIFO_DEPTH),       //FIFO depth
    .SHAPE("TALL"),     // hard macro shape (square, tall, wide),
    .REG(0)
) 
serial_fifo (
    //basic interface
    .clk(aclk), // clock
    .nreset(aresetn), // active high async reset 
    .clear(1'b0), //clear fifo statemachine (sync)
    //write port
    .wr_din(serial_fifo_data_in), // data to write
    .wr_en(serial_data_push), // write fifo
    .wr_full(serial_data_full), // fifo full
    .wr_almost_full(), //one entry left
    .wr_prog_full(), // fifo is almost full
    //read port
    .rd_dout(serial_fifo_data_out), // output data (next cycle)
    .rd_en(serial_fifo_pop), // read fifo
    .rd_empty(serial_fifo_empty), // fifo is empty 
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

ws2812bc_master #(
    // Clock frequency in Hz
    .FREQ_HZ(FREQ_HZ)
) 
ws_master (
    // Clock and reset
    .clk(aclk),
    .resetn(aresetn),

    // Control signals
    .grb_color(color_data_serial_out),
    .end_frame(end_frame_out),
    .color_empty(serial_fifo_empty),
    .color_pop(serial_fifo_pop),

    // WS2812B/C data
    .Dout(Dout)
);

endmodule
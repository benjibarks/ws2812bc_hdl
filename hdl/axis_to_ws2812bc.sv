module axis_to_ws2812bc #(
    // Clock frequency in Hz
    parameter FREQ_HZ = 100000000,

    // AXI-S Data bus format
    parameter TDATA_WIDTH = 24,
    parameter TSTRB_WIDTH = 3,
    parameter R_BYTE_INDEX = 0,
    parameter G_BYTE_INDEX = 1,
    parameter B_BYTE_INDEX = 2,

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

logic serial_fifo_data_in;
logic serial_fifo_data_out;
logic serial_fifo_push;
logic serial_fifo_pop;
logic serial_fifo_full;
logic serial_fifo_empty;

logic color_data_serial_in;
logic end_frame_in;
logic color_data_serial_out;
logic end_frame_out;

assign serial_fifo_data_in = {end_frame_in, color_data_serial_in};
assign serial_fifo_data_out = {end_frame_out, color_data_serial_out};

axis_slave_ws2812bc axis_slave #(
    .TDATA_WIDTH(TDATA_WIDTH),
    .TSTRB_WIDTH(TSTRB_WIDTH),
    .R_BYTE_INDEX(R_BYTE_INDEX),
    .G_BYTE_INDEX(G_BYTE_INDEX),
    .B_BYTE_INDEX(B_BYTE_INDEX)
) (
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

oh_fifo_sync serial_fifo #(
    .DW(2),      //FIFO width
	.DEPTH(FIFO_DEPTH),       //FIFO depth
) (
    .clk(aclk), // clock
    .nreset(aresetn), // active high async reset 
    .din(serial_fifo_data_in), // data to write
    .wr_en(serial_data_push), // write fifo
    .rd_en(serial_fifo_pop), // read fifo
    .dout(serial_fifo_data_out), // output data (next cycle)
    .full(serial_data_full), // fifo full
    .prog_full(), // fifo is almost full
    .empty(serial_fifo_empty), // fifo is empty  
    .rd_count()     // valid entries in fifo
 );

ws2812bc_master ws_master #(
    // Clock frequency in Hz
    .FREQ_HZ(FREQ_HZ);
) (
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
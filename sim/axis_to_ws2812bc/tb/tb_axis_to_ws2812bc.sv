module tb_axis_to_ws3812bc();

localparam FREQ_HZ = 100000000;
localparam TDATA_WIDTH = 24;
localparam TSTRB_WIDTH = 3;
localparam R_BYTE_INDEX = 0;
localparam G_BYTE_INDEX = 1;
localparam B_BYTE_INDEX = 2;
localparam FIFO_DEPTH = 128;

localparam NUM_LEDS = 8;

logic aclk, areset;
logic [TDATA_WIDTH-1:0] tdata;
logic [TSTRB_WIDTH-1:0] tstrb;
logic tvalid, tlast, tready;

logic [NUM_LEDS:0] Din;

// AXI-S VIP
axi4stream_vip_0 axis_vip (
    .aclk(aclk),
    .aresetn(aresetn),
    .m_axis_tvalid(tvalid),
    .m_axis_tready(tready),
    .m_axis_tdata(tdata),
    .m_axis_tstrb(tstrb),
    .m_axis_tlast(tlast)
);

// LED string
genvar i;
generate 
    for (i = 0; i < NUM_LEDS; i++) begin
        ws2812bc #(
            .NAME($sformatf("LED %d", i))
        ) led (
            .Din(Din[i]),
            .Dout(Din[i+1])
        );
    end
endgenerate

axis_to_ws2812bc #(
    // Clock frequency in Hz
    .FREQ_HZ(FREQ_HZ),

    // AXI-S Data bus format
    .TDATA_WIDTH(TDATA_WIDTH),
    .TSTRB_WIDTH(TSTRB_WIDTH),
    .R_BYTE_INDEX(R_BYTE_INDEX),
    .G_BYTE_INDEX(G_BYTE_INDEX),
    .B_BYTE_INDEX(B_BYTE_INDEX),

    // FIFO Params
    .FIFO_DEPTH(FIFO_DEPTH)
) DUT (
    // Clock and reset
    .aclk(aclk),
    .aresetn(aresetn),

    // AXI-S
    .tdata(tdata),
    .tstrb(tstrb),
    .tvalid(tvalid),
    .tlast(last),
    .tready(tready),

    // WS2812B/C data
    .Dout(Din[0])
);

endmodule
import axi4stream_vip_pkg::*;
import axi4stream_vip_0_pkg::*;

module tb_axis_to_ws3812bc();

localparam FREQ_HZ = 100000000;
localparam TDATA_WIDTH = 24;
localparam TSTRB_WIDTH = 3;
localparam R_BYTE_INDEX = 2;
localparam G_BYTE_INDEX = 1;
localparam B_BYTE_INDEX = 0;
localparam FIFO_DEPTH = 128;

localparam NUM_LEDS = 8;

localparam CLK_PERIOD = (1000000000 / FREQ_HZ);
localparam HALF_PERIOD = CLK_PERIOD / 2;

logic aclk = 1'b0;
logic aresetn = 1'b0;
logic [TDATA_WIDTH-1:0] tdata;
logic [TSTRB_WIDTH-1:0] tstrb;
logic tvalid, tlast, tready;

logic [NUM_LEDS:0] Din;

// Simulate the clock
always begin
    #HALF_PERIOD aclk = ~aclk;
end

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
            .NAME($sformatf("LED %0d", i))
        ) led (
            .Din(Din[i]),
            .Dout(Din[i+1])
        );
    end
endgenerate

axi4stream_vip_0_mst_t  axi4stream_vip_0_mst;
axi4stream_transaction wr_transaction;
initial begin : START_axi4stream_vip_0_MASTER
    axi4stream_vip_0_mst = new("axi4stream_vip_0_mst", tb_axis_to_ws3812bc.axis_vip.inst.IF);
    axi4stream_vip_0_mst.start_master();

    #(20 * CLK_PERIOD);
    aresetn = 1'b1;
    #CLK_PERIOD;
    
    wr_transaction = axi4stream_vip_0_mst.driver.create_transaction("Master VIP write transaction");
    wr_transaction.set_xfer_alignment(XIL_AXI4STREAM_XFER_RANDOM);
    WR_TRANSACTION_FAIL: assert(wr_transaction.randomize());
    axi4stream_vip_0_mst.driver.send(wr_transaction);
end

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
    .tlast(tlast),
    .tready(tready),

    // WS2812B/C data
    .Dout(Din[0])
);

endmodule
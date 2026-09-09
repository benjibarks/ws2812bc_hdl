`timescale 1ns/1ps

import axi4stream_vip_pkg::*;
import axi4stream_vip_0_pkg::*;

module tb_axis_to_ws3812bc();

// Clock parameters
localparam FREQ_HZ = 100000000;
localparam CLK_PERIOD = (1000000000 / FREQ_HZ);
localparam HALF_PERIOD = CLK_PERIOD / 2;

// WS2812B/C timing bounds for model
localparam T0H_MAX = 380; // Time in nanoseconds
localparam T0H_MIN = 220; // Time in nanoseconds
localparam T1H_MAX = 1000; // Time in nanoseconds
localparam T1H_MIN = 580; // Time in nanoseconds
localparam T0L_MAX = 1000; // Time in nanoseconds
localparam T0L_MIN = 580; // Time in nanoseconds
localparam T1L_MAX = 1000; // Time in nanoseconds
localparam T1L_MIN = 580; // Time in nanoseconds
localparam RESET_TIME = 280000; // Time in nanoseconds

// WS2812B/C timing for DUT (currently modeling a fast WS2812C driver)
localparam T0H = 250; // Time in nanoseconds
localparam T1H = 600; // Time in nanoseconds
localparam T0L = 600; // Time in nanoseconds
localparam T1L = 600; // Time in nanoseconds
localparam RESET_TIME_DUT = 280000; // Time in nanoseconds

// LED parameters
localparam NUM_LEDS = 8;
localparam NUM_REFRESH = 4;

// Color data format
localparam TDATA_WIDTH = 24;
localparam COLOR_WIDTH = 8;
localparam R_START_INDEX = 2;
localparam G_START_INDEX = 1;
localparam B_START_INDEX = 0;

// FIFO depth
localparam FIFO_DEPTH = 256;

logic aclk = 1'b0;
logic aresetn = 1'b0;
logic [TDATA_WIDTH-1:0] tdata;
logic tvalid, tlast, tready;

logic [7:0] tdata_3d [NUM_REFRESH-1:0] [NUM_LEDS-1:0] [2:0];
logic [0:23] leddata [NUM_LEDS-1:0];
logic [NUM_LEDS-1:0] leds_done;
integer check_num = 0;

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
    .m_axis_tlast(tlast)
);

// LED string
genvar i;
generate 
    for (i = 0; i < NUM_LEDS; i++) begin
        ws2812bc #(
            .NAME($sformatf("LED %0d", i)),
            .T0H_MAX(T0H_MAX), // Time in nanoseconds
            .T0H_MIN(T0H_MIN), // Time in nanoseconds
            .T1H_MAX(T1H_MAX), // Time in nanoseconds
            .T1H_MIN(T1H_MIN), // Time in nanoseconds
            .T0L_MAX(T0L_MAX), // Time in nanoseconds
            .T0L_MIN(T0L_MIN), // Time in nanoseconds
            .T1L_MAX(T1L_MAX), // Time in nanoseconds
            .T1L_MIN(T1L_MIN), // Time in nanoseconds
            .RESET_TIME(RESET_TIME) // Time in nanoseconds
        ) led (
            .Din(Din[i]),
            .Dout(Din[i+1]),
            
            .done(leds_done[i]),
            .color_out(leddata[i])
        );
    end
endgenerate

always @ (posedge leds_done[NUM_LEDS-1]) begin
    for (int i = 0; i < NUM_LEDS; i++) begin
        assert(tdata_3d[check_num][i][1] == leddata[i][0:7]) 
            else $display("ASSERT FAILED at LED #%0d G: AXI %x != LED %x", i, tdata_3d[check_num][i][1], leddata[i][0:7]);
        assert(tdata_3d[check_num][i][0] == leddata[i][8:15]) 
            else $display("ASSERT FAILED at LED #%0d R: AXI %x != LED %x", i, tdata_3d[check_num][i][0], leddata[i][8:15]);
        assert(tdata_3d[check_num][i][2] == leddata[i][16:23]) 
            else $display("ASSERT FAILED at LED #%0d B: AXI %x != LED %x", i, tdata_3d[check_num][i][2], leddata[i][16:23]);
    end
    check_num++;
end

axi4stream_vip_0_mst_t  axi4stream_vip_0_mst;
axi4stream_transaction wr_transaction;
initial begin : START_axi4stream_vip_0_MASTER
    axi4stream_vip_0_mst = new("axi4stream_vip_0_mst", tb_axis_to_ws3812bc.axis_vip.inst.IF);
    axi4stream_vip_0_mst.set_verbosity(200);
    axi4stream_vip_0_mst.start_master();

    #(20 * CLK_PERIOD);
    aresetn = 1'b1;
    #CLK_PERIOD;
    
    wr_transaction = axi4stream_vip_0_mst.driver.create_transaction("Master VIP write transaction");
    wr_transaction.set_xfer_alignment(XIL_AXI4STREAM_XFER_RANDOM);
    for (int j = 0; j < NUM_REFRESH; j++) begin
        for(int i = 0; i < NUM_LEDS; i++) begin
            WR_TRANSACTION_FAIL: assert(wr_transaction.randomize());
            wr_transaction.get_data(tdata_3d[j][i]);
            wr_transaction.set_delay(0);
            if(i == NUM_LEDS-1) begin
                // set tlast to 1
                wr_transaction.set_last(1);
            end else begin
                // set tlast to 0
                wr_transaction.set_last(0);
            end
            axi4stream_vip_0_mst.driver.send(wr_transaction);
        end
        #1000;
    end
end

axis_to_ws2812bc #(
    // Clock frequency in Hz
    .FREQ_HZ(FREQ_HZ),

    // AXI-S Data bus format
    .TDATA_WIDTH(TDATA_WIDTH),
    .COLOR_WIDTH(COLOR_WIDTH),
    .R_BYTE_INDEX(R_START_INDEX),
    .G_BYTE_INDEX(G_START_INDEX),
    .B_BYTE_INDEX(B_START_INDEX),

    // FIFO Params
    .FIFO_DEPTH(FIFO_DEPTH),

    // WS2812B/C Timing parameters
    .T0H(T0H),// Time in nanoseconds
    .T1H(T1H),// Time in nanoseconds
    .T0L(T0L),// Time in nanoseconds
    .T1L(T1L),// Time in nanoseconds
    .RESET_TIME(RESET_TIME_DUT)// Time in nanoseconds
) DUT (
    // Clock and reset
    .aclk(aclk),
    .aresetn(aresetn),

    // AXI-S
    .tdata(tdata),
    .tvalid(tvalid),
    .tlast(tlast),
    .tready(tready),

    // WS2812B/C data
    .Dout(Din[0])
);

endmodule
module axis_slave_to_fifo #(
    // AXI-S Data bus format
    parameter TDATA_WIDTH = 24,
    parameter TSTRB_WIDTH = TDATA_WIDTH / 8
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

    // To FIFO
    input logic data_out_full,
    input logic data_out_afull,
    output logic [TDATA_WIDTH-1:0] data_out,
    output logic last_data,
    output logic data_out_push
);

typedef enum logic [1:0] {INIT, RECEIVE_DATA, WAIT_FIFO} ws2812_par_states;
ws2812_par_states sm_vec;

integer i = 0;
logic data_out_full_or_afull;
logic tvalid_stored;

assign data_out_full_or_afull = data_out_full | data_out_afull;

// State machine transitions
always @ (posedge aclk) begin
    if (aresetn == 1'b0) begin
        sm_vec <= INIT;
    end else begin
        case (sm_vec)
            INIT:
                sm_vec <= RECEIVE_DATA;

            RECEIVE_DATA:
                if (data_out_afull == 1'b1) begin
                    sm_vec <= WAIT_FIFO;
                end else begin
                    sm_vec <= RECEIVE_DATA;
                end

            WAIT_FIFO:
                if (data_out_full == 1'b0) begin
                    sm_vec <= RECEIVE_DATA;
                end else begin
                    sm_vec <= WAIT_FIFO;
                end

            default:
                sm_vec <= INIT;
        endcase
    end
end

// State machine outputs
always @ (posedge aclk) begin
    if (aresetn == 1'b0) begin
        tready <= 1'b0;
        data_out <= 'b0;
        last_data <= 1'b0;
        data_out_push <= 1'b0;
        tvalid_stored <= 1'b0;
    end else begin
        case (sm_vec)
            INIT:
            begin
                tready <= 1'b1;
            end

            RECEIVE_DATA:
            begin
                tready <= ~data_out_full_or_afull;
                last_data <= tlast;
                for (i = 0; i < TDATA_WIDTH; i++) begin
                    data_out[i] <= tdata[i] & tstrb[i / 8];
                end
                data_out_push <= tvalid & ~data_out_full_or_afull;
                tvalid_stored <= tvalid;
            end

            WAIT_FIFO:
            begin
                tready <= ~data_out_full;
                data_out_push <= tvalid_stored & ~data_out_full;
            end

        endcase
    end
end
    
endmodule
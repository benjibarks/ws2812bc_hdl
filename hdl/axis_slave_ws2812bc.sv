module axis_slave_ws2812bc #(
    // AXI-S Data bus format
    parameter TDATA_WIDTH = 24,
    parameter TSTRB_WIDTH = 3,
    parameter R_BYTE_INDEX = 0,
    parameter G_BYTE_INDEX = 1,
    parameter B_BYTE_INDEX = 2
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

    // Serializer/FIFO
    input logic serial_data_full,
    output logic color_data_serial,
    output logic end_frame,
    output logic serial_data_push
);

localparam G_START_BIT = G_BYTE*8;
localparam R_START_BIT = R_BYTE*8;
localparam B_START_BIT = B_BYTE*8;

localparam color_indices [2:0] = {G_START_BIT, R_START_BIT, B_START_BIT};
localparam color_byte_indices [2:0] = {G_BYTE, R_BYTE, B_BYTE};

enum logic {INIT, IDLE, SERIALIZE_DATA, RECEIVE_DATA, SEND_EOF} axis_states;

axis_states sm_vec;
logic last_word;
logic [TDATA_WIDTH-1:0] current_data;
logic [TSTRB_WIDTH-1:0] current_strb;
unsigned [2:0] bit_ptr;
unsigned [1:0] byte_ptr;

// State machine transitions
always @ (posedge aclk) begin
    if (aresetn == 1'b0) begin
        sm_vec <= IDLE;
    end else begin
        case (sm_vec)
            INIT:
                sm_vec <= IDLE;

            IDLE:
                if (tvalid == 1'b1) begin
                    sm_vec <= RECEIVE_DATA;
                end else begin
                    sm_vec <= IDLE;
                end

            SERIALIZE_DATA:
                if (byte_ptr == 2 && bit_ptr == 7 && serial_data_full == 1'b0) begin
                    if (last_word == 1'b1) begin
                        sm_vec <= SEND_EOF;
                    end else begin
                        sm_vec <= RECEIVE_DATA;
                    end
                end else begin
                    sm_vec <= SERIALIZE_DATA;
                end

            RECEIVE_DATA:
                if (tvalid == 1'b1) begin
                    sm_vec <= SERIALIZE_DATA;
                end else begin
                    sm_vec <= RECEIVE_DATA;
                end

            SEND_EOF:
                if (serial_data_full == 1'b0) begin
                    sm_vec <= IDLE;
                end else begin
                    sm_vec <= SEND_EOF;
                end
        
            default:
                sm_vec <= IDLE;

        endcase
    end
end

// State machine outputs
always @ (posedge aclk) begin
    if (aresetn == 1'b0) begin
        tready <= 1'b0;
        color_data_serial <= 1'b0;
        end_frame <= 1'b0;
        serial_data_push <= 1'b0;

        bit_ptr <= 0;
        byte_ptr <= 0;
    end else begin
        case (sm_vec)
            INIT:
                tready <= 1'b1;

            IDLE:
                if (tvalid == 1'b1) begin
                    current_data <= tdata;
                    current_strb <= tstrb;
                    last_word <= tlast;
                    tready <= 1'b0;

                    bit_ptr <= 0;
                    byte_ptr <= 0;
                end

            SERIALIZE_DATA:
                color_data_serial <= current_data[color_indices[byte_ptr] + bit_ptr]
                                    & current_strb[color_byte_indices[byte_ptr]];
                serial_data_push <= ~serial_data_full;
                if (serial_data_full == 1'b0 && byte_ptr < 2 && bit_ptr < 7) begin
                    if (last_word == 1'b0) begin
                        tready <= 1'b1;
                    end
                end else if (serial_data_full == 1'b0) begin
                    bit_ptr <= bit_ptr + 1;
                    byte_ptr <= byte_ptr + 1;
                end else begin
                    bit_ptr <= bit_ptr;
                    byte_ptr <= byte_ptr;
                end

            RECEIVE_DATA:
                bit_ptr <= 0;
                byte_ptr <= 0;
                serial_data_push <= 1'b0;
                if (tvalid == 1'b1) begin
                    current_data <= tdata;
                    current_strb <= tstrb;
                    last_word <= tlast;
                    tready <= 1'b0;
                end

            SEND_EOF:
                end_frame <= 1'b1;
                color_data_serial <= 1'b0;
                serial_data_push <= ~serial_data_full;
                tready <= 1'b1;
        
            default:
                // Do nothing

        endcase
    end
end
    
endmodule
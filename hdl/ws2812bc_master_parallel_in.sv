module ws2812bc_master_parallel_in #(
    // Clock frequency in Hz
    parameter FREQ_HZ = 100000000,
    parameter DATA_WIDTH = 24
) (
    // Clock and reset
    input logic clk,
    input logic resetn,

    // Control signals
    input logic [DATA_WIDTH-1:0] grb_color,
    input logic end_frame,
    input logic color_empty,
    output logic color_pop,

    // WS2812B/C data
    output logic Dout
);

localparam COUNTER_WIDTH = $clog2(DATA_WIDTH);

typedef enum logic [1:0] {IDLE, LOAD_PARALLEL_DATA, SHIFT_SERIAL_DATA} ws2812_par_states;
ws2812_par_states sm_vec;

logic grb_color_serial;
logic serial_data_valid;
logic load_parallel_data;
logic shift_serial;
logic serializer_busy;
logic end_frame_serial;

logic unsigned [COUNTER_WIDTH-1:0] end_frame_counter;

oh_par2ser #(
    .PW(DATA_WIDTH) // parallel packet width
) par2ser (
    .clk(clk), // sampling clock
    .nreset(resetn), // async active low reset
    .din(grb_color), // parallel data
    .dout(grb_color_serial), // serial output data
    .access_out(serial_data_valid),// output data valid
    .load(load_parallel_data), // load parallel data (priority)
    .shift(shift_serial), // shift data
    .datasize($unsigned(DATA_WIDTH)), // size of data to shift
    .lsbfirst(1'b0), // lsb first order
    .fill(1'b0), // fill bit
    .wait_in(1'b0), // wait input
    .wait_out(serializer_busy) // wait output (wait in | serial wait)
);

ws2812bc_master_serial_in #(
    // Clock frequency in Hz
    .FREQ_HZ(FREQ_HZ)
) ws_master_serial (
    // Clock and reset
    .clk(clk),
    .resetn(resetn),

    // Control signals
    .grb_color(grb_color_serial),
    .end_frame(end_frame_serial),
    .color_empty(~serial_data_valid),
    .color_pop(shift_serial),

    // WS2812B/C data
    .Dout(Dout)
);

// EOF signal counter
always @ (posedge clk) begin
    if (resetn == 1'b0) begin
        end_frame_counter <= 'b0;
    end else begin
        if (end_frame & shift_serial) begin
            if (end_frame_counter == DATA_WIDTH-1) begin
                end_frame_counter <= 'b0;
            end else begin
                end_frame_counter <= end_frame_counter + 1;
            end
        end else begin
            end_frame_counter <= end_frame_counter;
        end
    end
end

// State machine transitions
always @ (posedge clk) begin
    if (resetn == 1'b0) begin
        sm_vec <= IDLE;
    end else begin
        case (sm_vec)
            IDLE:
                if (~color_empty) begin
                    sm_vec <= LOAD_PARALLEL_DATA;
                end else begin
                    sm_vec <= IDLE;
                end

            LOAD_PARALLEL_DATA:
                if (serial_data_valid) begin
                    sm_vec <= SHIFT_SERIAL_DATA;
                end else begin
                    sm_vec <= LOAD_PARALLEL_DATA;
                end

            SHIFT_SERIAL_DATA:
                if (~serializer_busy) begin
                    sm_vec <= IDLE;
                end else begin
                    sm_vec <= SHIFT_SERIAL_DATA;
                end
                
            default:
                sm_vec <= IDLE;            
        endcase
    end
end

// State machine outputs
always @ (posedge clk) begin
    if (resetn == 1'b0) begin
        color_pop <= 1'b0;
        load_parallel_data <= 1'b0;
        end_frame_serial <= 1'b0;
    end else begin
        case (sm_vec)
            IDLE:
            begin
                color_pop <= ~color_empty;
                load_parallel_data <= 1'b0;
                end_frame_serial <= 1'b0;
            end

            LOAD_PARALLEL_DATA:
            begin
                color_pop <= 1'b0;
                load_parallel_data <= ~serializer_busy;
                end_frame_serial <= 1'b0;
            end

            SHIFT_SERIAL_DATA:
            begin
                color_pop <= 1'b0;
                load_parallel_data <= 1'b0;
                end_frame_serial <= end_frame_counter == DATA_WIDTH-1;
            end
                         
        endcase
    end
end
    
endmodule
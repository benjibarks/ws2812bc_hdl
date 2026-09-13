module ws2812bc_master_serial_in #(
    parameter FREQ_HZ = 100000000, // In Hz
    parameter T0H = 300, // Time in nanoseconds
    parameter T1H = 790, // Time in nanoseconds
    parameter T0L = 790, // Time in nanoseconds
    parameter T1L = 790, // Time in nanoseconds
    parameter RESET_TIME = 280000 // Time in nanoseconds
) (
    // Clock and reset
    input logic clk,
    input logic resetn,

    // Control signals
    input logic grb_color,
    input logic end_frame,
    input logic color_empty,
    output logic color_pop,

    // WS2812B/C data
    output logic Dout
);

localparam T0H_CLKS = $rtoi($ceil(($itor(T0H) / 1000000000) * FREQ_HZ));
localparam T0L_CLKS = $rtoi($ceil(($itor(T0L) / 1000000000) * FREQ_HZ));
localparam T1H_CLKS = $rtoi($ceil(($itor(T1H) / 1000000000) * FREQ_HZ));
localparam T1L_CLKS = $rtoi($ceil(($itor(T1L) / 1000000000) * FREQ_HZ));
localparam RESET_CLKS = $rtoi($ceil(($itor(RESET_TIME) / 1000000000) * FREQ_HZ));

localparam COUNTER_WIDTH = $clog2(RESET_CLKS);

typedef enum logic [2:0] {IDLE, SEND_0_HI, SEND_0_LO, SEND_1_HI, SEND_1_LO, SEND_RESET} ws2812_states;

ws2812_states sm_vec;
logic unsigned [COUNTER_WIDTH-1:0] counter;
logic send_eof;

// State machine transitions
always @ (posedge clk) begin
    if (resetn == 1'b0) begin
        sm_vec <= IDLE;
    end else begin
        case (sm_vec)
            IDLE:
                if (send_eof == 1'b1) begin
                    sm_vec <= SEND_RESET;
                end else if (color_empty == 1'b0 && grb_color == 1'b0) begin
                    sm_vec <= SEND_0_HI;
                end else if (color_empty == 1'b0 && grb_color == 1'b1) begin
                    sm_vec <= SEND_1_HI;
                end

            SEND_0_HI:
                if (counter == T0H_CLKS-1) begin
                    sm_vec <= SEND_0_LO;
                end else begin
                    sm_vec <= SEND_0_HI;
                end

            SEND_0_LO:
                if (counter == T0L_CLKS-2) begin // -2 to account for lo time in idle
                    sm_vec <= IDLE;
                end else begin
                    sm_vec <= SEND_0_LO;
                end

            SEND_1_HI:
                if (counter == T1H_CLKS-1) begin
                    sm_vec <= SEND_1_LO;
                end else begin
                    sm_vec <= SEND_1_HI;
                end

            SEND_1_LO:
                if (counter == T1L_CLKS-2) begin // -2 to account for lo time in idle
                    sm_vec <= IDLE;
                end else begin
                    sm_vec <= SEND_1_LO;
                end

            SEND_RESET:
                if (counter == RESET_CLKS-1) begin
                    sm_vec <= IDLE;
                end else begin
                    sm_vec <= SEND_RESET;
                end

            default:
                sm_vec <= IDLE;

        endcase
    end
end

// State machine outputs
always @ (posedge clk) begin
    if (resetn == 1'b0) begin
        Dout <= 1'b0;
        color_pop <= 1'b0;
        counter <= 0;
        send_eof <= 1'b0;
    end else begin
        case (sm_vec)
            IDLE:
            begin
                color_pop <= ~color_empty & ~send_eof;
                Dout <= 1'b0;
                counter <= 0;
                send_eof <= end_frame;
            end

            SEND_0_HI:
            begin
                color_pop <= 1'b0;
                Dout <= 1'b1;
                counter <= counter < T0H_CLKS-1 ? counter + 1 : 0;
            end

            SEND_0_LO:
            begin
                color_pop <= 1'b0;
                Dout <= 1'b0;
                counter <= counter < T0L_CLKS-2 ? counter + 1 : 0; // -2 to account for lo time in idle
            end
                
            SEND_1_HI:
            begin
                color_pop <= 1'b0;
                Dout <= 1'b1;
                counter <= counter < T1H_CLKS-1 ? counter + 1 : 0;
            end

            SEND_1_LO:
            begin
                color_pop <= 1'b0;
                Dout <= 1'b0;
                counter <= counter < T1L_CLKS-2 ? counter + 1 : 0; // -2 to account for lo time in idle
            end

            SEND_RESET:
            begin
                color_pop <= 1'b0;
                Dout <= 1'b0;
                counter <= counter < RESET_CLKS-1 ? counter + 1 : 0;
            end

        endcase
    end
end
    
endmodule
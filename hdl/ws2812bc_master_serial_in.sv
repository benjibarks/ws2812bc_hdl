import ws2812bc_pkg::*;

module ws2812bc_master_serial_in #(
    // Clock frequency in Hz
    parameter FREQ_HZ = 100000000
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

localparam COUNTER_WIDTH = 32;
localparam T0H_CLKS = $rtoi(T0H * FREQ_HZ);
localparam T0L_CLKS = $rtoi(T0L * FREQ_HZ);
localparam T1H_CLKS = $rtoi(T1H * FREQ_HZ);
localparam T1L_CLKS = $rtoi(T1L * FREQ_HZ);
localparam RESET_CLKS = $rtoi(RESET_TIME * FREQ_HZ);

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
                if (counter == T0H_CLKS) begin
                    sm_vec <= SEND_0_LO;
                end else begin
                    sm_vec <= SEND_0_HI;
                end

            SEND_0_LO:
                if (counter == T0L_CLKS) begin
                    sm_vec <= IDLE;
                end else begin
                    sm_vec <= SEND_0_LO;
                end

            SEND_1_HI:
                if (counter == T1H_CLKS) begin
                    sm_vec <= SEND_1_LO;
                end else begin
                    sm_vec <= SEND_1_HI;
                end

            SEND_1_LO:
                if (counter == T1L_CLKS) begin
                    sm_vec <= IDLE;
                end else begin
                    sm_vec <= SEND_1_LO;
                end

            SEND_RESET:
                if (counter == RESET_CLKS) begin
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
                counter <= counter < T0H_CLKS ? counter + 1 : 0;
            end

            SEND_0_LO:
            begin
                color_pop <= 1'b0;
                Dout <= 1'b0;
                counter <= counter < T0L_CLKS ? counter + 1 : 0;
            end
                
            SEND_1_HI:
            begin
                color_pop <= 1'b0;
                Dout <= 1'b1;
                counter <= counter < T1H_CLKS ? counter + 1 : 0;
            end

            SEND_1_LO:
            begin
                color_pop <= 1'b0;
                Dout <= 1'b0;
                counter <= counter < T1L_CLKS ? counter + 1 : 0;
            end

            SEND_RESET:
            begin
                color_pop <= 1'b0;
                Dout <= 1'b0;
                counter <= counter < RESET_CLKS ? counter + 1 : 0;
            end

        endcase
    end
end
    
endmodule
import ws2812bc_pkg::*;

module ws2812bc_master #(
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

enum logic {IDLE, SEND_0_HI, SEND_0_LO, SEND_1_HI, SEND_1_LO, SEND_RESET} ws2812_states;

ws2812_states sm_vec;
unsigned [COUNTER_WIDTH-1:0] counter;

// State machine transitions
always @ (posedge clk) begin
    if (resetn == 1'b0) begin
        sm_vec <= IDLE;
    end else begin
        case (sm_vec)
            IDLE:
                if (color_empty == 1'b0 and end_frame == 1'b1) begin
                    sm_vec <= SEND_RESET;
                end if (color_empty == 1'b0 and grb_color == 1'b0) begin
                    sm_vec <= SEND_0_HI;
                end else if (color_empty == 1'b0 and gb_color == 1'b1) begin
                    sm_vec <= SEND_1_HI;

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
    end else begin
        case (sm_vec)
            IDLE:
                color_pop <= ~color_empty;
                counter <= 0;

            SEND_0_HI:
                Dout <= 1'b1;
                counter <= counter < T0H ? counter + 1 : 0;

            SEND_0_LO:
                Dout <= 1'b0;
                counter <= counter < T0L ? counter + 1 : 0;
                
            SEND_1_HI:
                Dout <= 1'b1;
                counter <= counter < T1H ? counter + 1 : 0;

            SEND_1_LO:
                Dout <= 1'b0;
                counter <= counter < T1L ? counter + 1 : 0;

            SEND_RESET:
                Dout <= 1'b0;
                counter <= counter < RESET_TIME ? counter + 1 : 0;

            default:
                // Do nothing

        endcase
    end
end
    
endmodule
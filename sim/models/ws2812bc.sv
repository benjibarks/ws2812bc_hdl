///////////////////////////////////////////////////////////////////////////////////////////////////
// Description
///////////////////////////////////////////////////////////////////////////////////////////////////
// WS2812B/C addressable LED model. Outputs color information to the simulation console.
// Self-checks for serial data timing parameters
//
`timescale 1ns/1ps

module ws2812bc #(
    parameter NAME ="LED 0",
    parameter T0H_MAX = 380, // Time in nanoseconds
    parameter T0H_MIN = 220, // Time in nanoseconds
    parameter T1H_MAX = 1000, // Time in nanoseconds
    parameter T1H_MIN = 580, // Time in nanoseconds
    parameter T0L_MAX = 1000, // Time in nanoseconds
    parameter T0L_MIN = 580, // Time in nanoseconds
    parameter T1L_MAX = 1000, // Time in nanoseconds
    parameter T1L_MIN = 580, // Time in nanoseconds
    parameter RESET_TIME = 280000 // Time in nanoseconds
) (
    input logic Din,
    output logic Dout,

    output logic done,
    output logic [0:23] color_out
);

integer i = 0;
integer start_time = 0, total_time = 0, max_time = 0;
logic current_val = 1'b0;
logic [0:23] current_color = 'bz;

assign Dout = i == 24 ? Din : 1'b0;
assign done = i == 24;
assign color_out = i == 24 ? current_color : 'bz;

always begin

    if (Din == 0 && i > 0) begin
        start_time = $time;
        total_time = 0;
        max_time = RESET_TIME;
        while (Din == 0 && total_time <= max_time) begin
            #1;
            total_time = $time - start_time;
        end

        if (total_time >= RESET_TIME) begin
            $display("RESET detected on %s!", NAME);
            current_color = 'bz;
            i = 0;
        end
    end else if (Din == 1 && i < 24) begin
        if (i == 0) begin
            $display("%s start ======>", NAME);
        end
        // HI time
        start_time = $time;
        total_time = 0;
        max_time = T0H_MAX > T1H_MAX ? T0H_MAX : T1H_MAX;
        while (Din == 1 && total_time < max_time) begin
            #1;
            total_time = $time - start_time;
        end

        if (total_time >= T0H_MIN && total_time <= T0H_MAX) begin
            current_val = 1'b0;
        end else if (total_time >= T1H_MIN && total_time <= T1H_MAX) begin
            current_val = 1'b1;
        end else begin
            $display("ERROR: Invalid HI time");
            current_val = 1'bX;
            current_color[i] = 1'bX;
        end

        // LO time
        start_time = $time;
        total_time = 0;
        max_time = current_val == 1'b0 ? T0L_MAX : T1L_MAX;
        while (Din == 0 && total_time < max_time) begin
            #1;
            total_time = $time - start_time;
        end

        if (current_val == 1'b0 && total_time >= T0L_MIN && total_time <= T0L_MAX) begin
            current_color[i] = 1'b0;
        end else if (current_val == 1'b1 && total_time >= T1L_MIN && total_time <= T1L_MAX) begin
            current_color[i] = 1'b1;
        end else if (current_val != 1'bX) begin
            $display("ERROR: Invalid LO time");
            current_color[i] = 1'bX;
        end

        if (i == 7) begin
            $display("G = 0x%h", current_color[0:7]);
        end else if (i == 15) begin
            $display("R = 0x%h", current_color[8:15]);
        end else if (i == 23) begin
            $display("B = 0x%h", current_color[16:23]);
            $display("<====== end %s", NAME);
        end
        i++;
    end else begin
        #1;
    end
end
    
endmodule
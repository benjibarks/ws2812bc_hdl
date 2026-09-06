`timescale 1ns/1ps

import ws2812bc_pkg::*;

module ws2812bc #(
    parameter NAME ="LED 0"
) (
    input logic Din,
    output logic Dout
);

localparam timescale = 1000000000;
localparam T0H_MIN = $rtoi(T0H_MIN_SEC * timescale);
localparam T0H_MAX = $rtoi(T0H_MAX_SEC * timescale);
localparam T1H_MIN = $rtoi(T1H_MIN_SEC * timescale);
localparam T1H_MAX = $rtoi(T1H_MAX_SEC * timescale);
localparam T0L_MIN = $rtoi(T0L_MIN_SEC * timescale);
localparam T0L_MAX = $rtoi(T0L_MAX_SEC * timescale);
localparam T1L_MIN = $rtoi(T1L_MIN_SEC * timescale);
localparam T1L_MAX = $rtoi(T1L_MAX_SEC * timescale);
localparam RESET_TIME = $rtoi(RESET_TIME_SEC * timescale);

integer i = 0;
integer starttime = 0, totaltime = 0, maxtime = 0;
logic currentval = 1'b0;
logic [0:23] currentcolor = 'b0;

assign Dout = i == 24 ? Din : 1'b0;

always begin

    if (Din == 0 && i > 0) begin
        starttime = $time;
        totaltime = 0;
        maxtime = RESET_TIME;
        while (Din == 0 && totaltime <= maxtime) begin
            #1;
            totaltime = $time - starttime;
        end

        if (totaltime >= RESET_TIME) begin
            $display("RESET detected on %s!", NAME);
            i = 0;
        end
    end else if (Din == 1 && i < 24) begin
        if (i == 0) begin
            $display("%s start ======>", NAME);
        end
        // HI time
        starttime = $time;
        totaltime = 0;
        maxtime = T0H_MAX > T1H_MAX ? T0H_MAX : T1H_MAX;
        while (Din == 1 && totaltime <= maxtime) begin
            #1;
            totaltime = $time - starttime;
        end

        if (totaltime >= T0H_MIN && totaltime <= T0H_MAX) begin
            currentval = 1'b0;
        end else if (totaltime >= T1H_MIN && totaltime <= T1H_MAX) begin
            currentval = 1'b1;
        end else begin
            $display("ERROR: Invalid HI time");
            currentval = 1'bX;
            currentcolor[i] = 1'bX;
        end

        // LO time
        starttime = $time;
        totaltime = 0;
        maxtime = T0L_MAX > T1L_MAX ? T0L_MAX : T1L_MAX;
        while (Din == 0 && totaltime <= maxtime) begin
            #1;
            totaltime = $time - starttime;
        end

        if (currentval == 1'b0 && totaltime >= T0L_MIN && totaltime <= T0L_MAX) begin
            currentcolor[i] = 1'b0;
        end else if (currentval == 1'b1 && totaltime >= T1L_MIN && totaltime <= T1L_MAX) begin
            currentcolor[i] = 1'b1;
        end else if (currentval != 1'bX) begin
            $display("ERROR: Invalid LO time");
            currentcolor[i] = 1'bX;
        end

        if (i == 7) begin
            $display("G = 0x%h", currentcolor[0:7]);
        end else if (i == 15) begin
            $display("R = 0x%h", currentcolor[8:15]);
        end else if (i == 23) begin
            $display("B = 0x%h", currentcolor[16:23]);
            $display("<====== end %s", NAME);
        end
        i++;
    end else begin
        #1;
    end
end
    
endmodule
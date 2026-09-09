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
integer starttime = 0, totaltime = 0, maxtime = 0;
logic currentval = 1'b0;
logic [0:23] currentcolor = 'bz;

assign Dout = i == 24 ? Din : 1'b0;
assign done = i == 24;
assign color_out = i == 24 ? currentcolor : 'bz;

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
            currentcolor = 'bz;
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
        while (Din == 1 && totaltime < maxtime) begin
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
        maxtime = currentval == 1'b0 ? T0L_MAX : T1L_MAX;
        while (Din == 0 && totaltime < maxtime) begin
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
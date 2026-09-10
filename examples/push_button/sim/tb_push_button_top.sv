`timescale 1ns/1ps

module tb_push_button_top ();

localparam FREQ_HZ = 125000000;
localparam DEBOUNCE_TIME = 0.0000001;
localparam NUM_LEDS = 150;

localparam CLK_PERIOD = 1000000000 / FREQ_HZ;
localparam HALF_PERIOD = CLK_PERIOD / 2;
localparam DEBOUNCE_TIME_NS = DEBOUNCE_TIME * 1000000000;

logic sysclk = 1'b0;
logic reset = 1'b1;
logic push_button_red = 1'b0;
logic push_button_green = 1'b0;
logic push_button_blue = 1'b0;
logic push_button_rainbow = 1'b0;

logic [NUM_LEDS:0] Din;
logic [NUM_LEDS-1:0] leds_done;
logic [0:23] leddata [NUM_LEDS-1:0];
logic all_LEDs_done;

assign all_LEDs_done = &leds_done;

always begin
    #HALF_PERIOD sysclk <= ~sysclk;
end

// LED string
genvar i;
generate 
    for (i = 0; i < NUM_LEDS; i++) begin
        ws2812bc #(
            .NAME($sformatf("LED %0d", i))
        ) led (
            .Din(Din[i]),
            .Dout(Din[i+1]),
            
            .done(leds_done[i]),
            .color_out(leddata[i])
        );
    end
endgenerate

initial begin
    #(20 * CLK_PERIOD);
    reset <= 1'b0;
    #CLK_PERIOD;

    push_button_red <= 1'b1;
    #(DEBOUNCE_TIME_NS + 2*CLK_PERIOD);
    push_button_red <= 1'b0;
    @(negedge all_LEDs_done)

    push_button_green <= 1'b1;
    #(DEBOUNCE_TIME_NS + 2*CLK_PERIOD);
    push_button_green <= 1'b0;
    @(negedge all_LEDs_done)

    push_button_blue <= 1'b1;
    #(DEBOUNCE_TIME_NS + 2*CLK_PERIOD);
    push_button_blue <= 1'b0;
    @(negedge all_LEDs_done)

    push_button_rainbow <= 1'b1;
    #(DEBOUNCE_TIME_NS + 2*CLK_PERIOD);
    push_button_rainbow <= 1'b0;
    @(negedge all_LEDs_done)
    $finish;
end

push_button_top #
(
    .FREQ_HZ(FREQ_HZ),
    .DEBOUNCE_TIME(DEBOUNCE_TIME)
) DUT (
    .sysclk(sysclk),
    .reset(reset),
    .push_button_red(push_button_red),
    .push_button_green(push_button_green),
    .push_button_blue(push_button_blue),
    .push_button_rainbow(push_button_rainbow),
    .Dout(Dout)
);

endmodule
module push_button_top # (
    parameter FREQ_HZ = 125000000,
    parameter DEBOUNCE_TIME = 0.001
) (
    input logic sysclk,
    input logic reset,
    input logic push_button_red,
    input logic push_button_green,
    input logic push_button_blue,
    input logic push_button_rainbow,
    output logic Dout
);

logic push_button_red_debounced;
logic push_button_green_debounced;
logic push_button_blue_debounced;
logic push_button_rainbow_debounced;

logic clk_internal_125;
logic rst_internal_125_n;

oh_debouncer #( 
    .BOUNCE(DEBOUNCE_TIME),      // bounce time (s)
    .FREQUENCY(FREQ_HZ)  // clock frequency (125Mhz)
) debounce_red (
    .clk(clk_internal_125), // clock to synchronize to
    .nreset(rst_internal_125_n), // syncronous active high reset
    .noisy_in(push_button_red), // noisy input signal to filter
    .clean_out(push_button_red_debounced) // clean signal to logic
    );

oh_debouncer #( 
    .BOUNCE(DEBOUNCE_TIME),      // bounce time (s)
    .FREQUENCY(FREQ_HZ)  // clock frequency (125Mhz)
) debounce_green(
    .clk(clk_internal_125), // clock to synchronize to
    .nreset(rst_internal_125_n), // syncronous active high reset
    .noisy_in(push_button_green), // noisy input signal to filter
    .clean_out(push_button_green_debounced) // clean signal to logic
    );

oh_debouncer #( 
    .BOUNCE(DEBOUNCE_TIME),      // bounce time (s)
    .FREQUENCY(FREQ_HZ)  // clock frequency (125Mhz)
) debounce_blue (
    .clk(clk_internal_125), // clock to synchronize to
    .nreset(rst_internal_125_n), // syncronous active high reset
    .noisy_in(push_button_blue), // noisy input signal to filter
    .clean_out(push_button_blue_debounced) // clean signal to logic
    );

oh_debouncer #( 
    .BOUNCE(DEBOUNCE_TIME),      // bounce time (s)
    .FREQUENCY(FREQ_HZ)  // clock frequency (125Mhz)
) debounce_rainbow (
    .clk(clk_internal_125), // clock to synchronize to
    .nreset(rst_internal_125_n), // syncronous active high reset
    .noisy_in(push_button_blue), // noisy input signal to filter
    .clean_out(push_button_blue_debounced) // clean signal to logic
);

push_button_bd_wrapper bd (
    .Dout(Dout),
    .clkout_125(clk_internal_125),
    .rstout_125_n(rst_internal_125_n),
    .push_button_blue(push_button_blue_debounced),
    .push_button_green(push_button_green_debounced),
    .push_button_rainbow(push_button_rainbow_debounced),
    .push_button_red(push_button_red_debounced),
    .reset(reset),
    .sysclk(sysclk)
);
    
endmodule
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

logic [3:0] debouncers_in, debouncers_out;

logic clk_internal_125;
logic rst_internal_125;

assign debouncers_in = {push_button_red, 
                        push_button_blue, 
                        push_button_green, 
                        push_button_rainbow};
assign push_button_red_debounced = debouncers_out[3];
assign push_button_blue_debounced = debouncers_out[2];
assign push_button_green_debounced = debouncers_out[1];
assign push_button_rainbow_debounced = debouncers_out[0];

genvar i;
generate
    for (i = 0; i < 4; i++) begin
        olo_intf_debounce # (
            .ClkFrequency_g(FREQ_HZ),
            .DebounceTime_g(DEBOUNCE_TIME)
        ) debounce (
            // control signals
            .Clk(clk_internal_125),
            .Rst(rst_internal_125),
            // Input clock domain
            .DataAsync(debouncers_in[i]),
            .DataOut(debouncers_out[i])
        );
    end
endgenerate

push_button_bd_wrapper bd (
    .Dout(Dout),
    .clkout_125(clk_internal_125),
    .rstout_125(rst_internal_125),
    .push_button_blue(push_button_blue_debounced),
    .push_button_green(push_button_green_debounced),
    .push_button_rainbow(push_button_rainbow_debounced),
    .push_button_red(push_button_red_debounced),
    .reset(reset),
    .sysclk(sysclk)
);
    
endmodule
# axis_to_ws2812bc Simulation
Simulation for the WS2812B/C driver with an AXI Streaming receiver user interface.

## Testbench
The testbench includes the DUT, a sting of WS2812B/C LED models, and an AXI Streaming Verification IP from AMD. The AXI-S VIP is the driver of the AXI-S interface of the DUT and configured to send 4 (by default) streams of colors to load into the LEDs. The DUT drives the serial interface of the LED "strip" made up of a string of 8 (by default) WS2812B/C LEDs with timing parameters defined in the testbench. When all of the LEDs are driven, the color data of each LED is compared to the AXI-S data sent by the VIP for accuracy. Various parameters are defined and configured by `localparam` lines in the testbench.

## Simulation outputs
Simulation output is printed to the simulation console, including any data mismatches.
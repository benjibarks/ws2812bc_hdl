# LED Pattern Emitter
Source files for the LED color pattern emitter utility.

## Files
- `led_pattern_emitter_master_stream_v1_0_M_AXIS.v`: AXI-S master driver for the LED pattern emitter used in example designs
- `led_pattern_emitter.v`: Emits a color pattern to a WS2812B/C driver using an AXI-S transmitter/master interface

## Dependencies
- `led_pattern_emitter_master_stream_v1_0_M_AXIS.v`
    - None
- `led_pattern_emitter.v`
    - `led_pattern_emitter_master_stream_v1_0_M_AXIS.v`
# HDL
Source code for the WS2812B/C driver.

## Modules
- `ws2812bc_master`: Serial master interface of the WS2812B/C driver
    - `ws2812bc_master_parallel_in.sv`: WS2812B/C master that collects color data on a parallel data bus FIFO interface
    - `ws2812bc_master_serial_in.sv`: WS2812B/C master that collects color data on a serial data bus FIFO interface
- `axi`: All WS2812B/C drivers that implement an AXI interface 
    - `axis_to_ws2812bc.sv`: WS2812B/C driver with AXI Streaming receiver user interface
- `utilities`: Utility modules not a part of any WS2812B/C driver. For example, non-driver source code for example designs
    - `led_pattern_emitter_master_stream_v1_0_M_AXIS.v`: AXI-S master driver for the LED pattern emitter used in example designs
    - `led_pattern_emitter.v`: Emits a color pattern to a WS2812B/C driver using an AXI-S transmitter/master interface

## Dependencies
Note: All Open Logic modules require the set of base packages `../../submodules/open-logic/src/base/vhdl/olo_base_pkg*`

- `axis_to_ws2812bc.sv`
    - `ws2812bc_master/ws2812bc_master_parallel_in.sv`
    - `../submodules/open-logic/src/base/vhdl/olo_base_ram_sdp.vhd`
    - `../submodules/open-logic/src/base/vhdl/olo_base_fifo_sync.vhd`
- `led_pattern_emitter_master_stream_v1_0_M_AXIS.v`
    - None
- `led_pattern_emitter.v`
    - `led_pattern_emitter_master_stream_v1_0_M_AXIS.v`
- `ws2812bc_master_parallel_in.sv`
    - `ws2812bc_master_serial_in.sv`
    - `../submodules/oh/stdlib/rtl/oh_par2ser.v`
- `ws2812bc_master_serial_in.sv`
    - None

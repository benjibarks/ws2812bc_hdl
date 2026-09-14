# AXI
WS2812B/C drivers that implement an AXI interface 

## Files
- `axis_to_ws2812bc.sv`: WS2812B/C driver with AXI Streaming receiver user interface

## Dependencies
- `axis_to_ws2812bc.sv`
    - `../ws2812bc_master/ws2812bc_master_parallel_in.sv`
    - `../../submodules/open-logic/src/base/vhdl/olo_base_ram_sdp.vhd`
    - `../../submodules/open-logic/src/base/vhdl/olo_base_fifo_sync.vhd`
    - `../../submodules/open-logic/src/base/vhdl/olo_base_pkg*`
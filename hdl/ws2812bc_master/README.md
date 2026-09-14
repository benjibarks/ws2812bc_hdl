# WS2812BC Master
Serial master interface of the WS2812B/C driver

## Files
- `ws2812bc_master_parallel_in.sv`: WS2812B/C master that collects color data on a parallel data bus FIFO interface
- `ws2812bc_master_serial_in.sv`: WS2812B/C master that collects color data on a serial data bus FIFO interface

## Dependencies
- `ws2812bc_master_parallel_in.sv`
    - `ws2812bc_master_serial_in.sv`
    - `../../submodules/oh/stdlib/rtl/oh_par2ser.v`
- `ws2812bc_master_serial_in.sv`
    - None

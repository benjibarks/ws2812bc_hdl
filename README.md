# ws2812bc_hdl
WS2812B/C addressable LED driver implemented in HDL for FPGA. User interfaces implemented include:
- AXI Streaming Receiver
- FIFO Reader (Parallel and Serial)

## Requirements
Vivado 2024.1

## Usage
Include the desired HDL files from the `hdl` directory in your design sources. Dependency trees are documented in the readme in that directory.

In Vivado, include the `ip_repos` directory as an IP repository to use the available sources as packaged IPs in the IPI or code.

## Directory Structure
- `examples`: Example designs
- `hdl`: HDL source code
- `ip_repo`: Vivao IP repository
- `sim`: Simulation files
- `submodules`: 3rd party code repsoitories
- `LICENSE`: License file
- `README.md`: You are here

# Simulation
Simulation framework for source code in this repository

# Simulation Tools
- Vivado 2024.1

## Usage
- To run simulation for a module, go to the module's simulation directory and run `make` to see a list of options. Then `make [option]` to run simulation.

## Directories
- `axis_to_ws2812bc`: Simulation for the `axis_to_ws2812bc` module
- `models`: Simulation models for internal and external interfaces. e.g. the WS2812B/C simulation model

## Simulation Directories
Each module simulated will have the following directory structure:

- `scripts`: simulation tool driver scripts
- `tb`: simulation testbench source code
- `vivado_project`: Intentionally left empty, placeholder for the Vivado project created by the makefile
- `makefile`: Used to build and run simulation. Run `make` from the example design directory to see build options
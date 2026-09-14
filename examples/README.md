# Examples
Contains the following example designs:

- `push_button`: Implements the WS2812C driver with AXI Streaming user interface driven by push-button presets.

## Usage
- To build an example design, go to the example design directory and run `make` to see a list of options. Then `make [option]` to build the design project.

## Design directories
Each example design includes the following:

- `constraints`: Design constraints, including pins and timing
- `doc`: Contains any supplemental documentation, like block diagrams and pictures
- `hdl`: Design-specific HDL (i.e. top module)
- `scripts`: Tool driver scripts
- `sim`: Design-specific simulation files (i.e. testbench)
- `vivado_project`: Intentionally left empty, placeholder for the Vivado project created by the makefile
- `makefile`: Used to build the example design. Run `make` from the example design directory to see build options
- `README.md`: A readme specific to the example design
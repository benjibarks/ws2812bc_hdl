add_files -norecurse {
    ../../hdl/axis_to_ws2812bc.sv 
    ../../hdl/ws2812bc_master_parallel_in.sv 
    ../../hdl/ws2812bc_master_serial_in.sv
    ../../submodules/open-logic/src/base/vhdl/olo_base_pkg_array.vhd
    ../../submodules/open-logic/src/base/vhdl/olo_base_pkg_attribute.vhd
    ../../submodules/open-logic/src/base/vhdl/olo_base_pkg_math.vhd
    ../../submodules/open-logic/src/base/vhdl/olo_base_pkg_string.vhd
    ../../submodules/open-logic/src/base/vhdl/olo_base_ram_sdp.vhd
    ../../submodules/open-logic/src/base/vhdl/olo_base_fifo_sync.vhd
    ../../submodules/oh/stdlib/rtl/oh_par2ser.v
}
update_compile_order -fileset sources_1

set_property file_type {VHDL 2008} [get_files  ../../submodules/open-logic/src/base/vhdl/olo_base_pkg_array.vhd]
set_property file_type {VHDL 2008} [get_files  ../../submodules/open-logic/src/base/vhdl/olo_base_pkg_attribute.vhd]
set_property file_type {VHDL 2008} [get_files  ../../submodules/open-logic/src/base/vhdl/olo_base_pkg_math.vhd]
set_property file_type {VHDL 2008} [get_files  ../../submodules/open-logic/src/base/vhdl/olo_base_pkg_string.vhd]
set_property file_type {VHDL 2008} [get_files  ../../submodules/open-logic/src/base/vhdl/olo_base_ram_sdp.vhd]
set_property file_type {VHDL 2008} [get_files  ../../submodules/open-logic/src/base/vhdl/olo_base_fifo_sync.vhd]

set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse {
    ./tb/ws2812tb_pkg.sv 
    ./tb/tb_axis_to_ws2812bc.sv 
    ../models/ws2812bc.sv
}
update_compile_order -fileset sim_1
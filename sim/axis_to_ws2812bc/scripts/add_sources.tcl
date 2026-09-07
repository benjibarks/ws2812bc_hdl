add_files -norecurse {
    ../../hdl/axis_to_ws2812bc.sv 
    ../../hdl/ws2812bc_master_parallel_in.sv 
    ../../hdl/ws2812bc_master_serial_in.sv 
    ../../hdl/axis_slave_to_fifo.sv
    ../../submodules/oh/stdlib/rtl/oh_fifo_sync.v 
    ../../submodules/oh/stdlib/rtl/oh_dpram.v 
    ../../submodules/oh/stdlib/rtl/oh_par2ser.v
}
update_compile_order -fileset sources_1

set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse {
    ./tb/ws2812tb_pkg.sv 
    ./tb/tb_axis_to_ws2812bc.sv 
    ../models/ws2812bc.sv
}
update_compile_order -fileset sim_1
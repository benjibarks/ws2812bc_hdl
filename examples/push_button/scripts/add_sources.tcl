add_files -norecurse {
    ../../submodules/open-logic/src/base/vhdl/olo_base_pkg_array.vhd
    ../../submodules/open-logic/src/base/vhdl/olo_base_pkg_attribute.vhd
    ../../submodules/open-logic/src/base/vhdl/olo_base_pkg_math.vhd
    ../../submodules/open-logic/src/base/vhdl/olo_base_pkg_string.vhd
    ../../submodules/open-logic/src/base/vhdl/olo_base_strobe_gen.vhd
    ../../submodules/open-logic/src/intf/vhdl/olo_intf_sync.vhd
    ../../submodules/open-logic/src/intf/vhdl/olo_intf_debounce.vhd
    ./hdl/push_button_top.sv
}
update_compile_order -fileset sources_1

set_property file_type {VHDL 2008} [get_files  ../../submodules/open-logic/src/base/vhdl/olo_base_pkg_array.vhd]
set_property file_type {VHDL 2008} [get_files  ../../submodules/open-logic/src/base/vhdl/olo_base_pkg_attribute.vhd]
set_property file_type {VHDL 2008} [get_files  ../../submodules/open-logic/src/base/vhdl/olo_base_pkg_math.vhd]
set_property file_type {VHDL 2008} [get_files  ../../submodules/open-logic/src/base/vhdl/olo_base_pkg_string.vhd]
set_property file_type {VHDL 2008} [get_files  ../../submodules/open-logic/src/base/vhdl/olo_base_strobe_gen.vhd]
set_property file_type {VHDL 2008} [get_files  ../../submodules/open-logic/src/intf/vhdl/olo_intf_sync.vhd]
set_property file_type {VHDL 2008} [get_files  ../../submodules/open-logic/src/intf/vhdl/olo_intf_debounce.vhd]

set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse {
    ./sim/tb_push_button_top.sv 
    ../../sim/models/ws2812bc.sv
}
update_compile_order -fileset sim_1

set_property  ip_repo_paths  ../../ip_repo [current_project]
update_ip_catalog
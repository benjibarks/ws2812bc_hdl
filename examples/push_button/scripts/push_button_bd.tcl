
################################################################
# This is a generated script based on design: push_button_bd
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2024.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   if { [string compare $scripts_vivado_version $current_vivado_version] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2042 -severity "ERROR" " This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Sourcing the script failed since it was created with a future version of Vivado."}

   } else {
     catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   }

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source push_button_bd_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg400-1
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name push_button_bd

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:axis_switch:1.1\
user.org:ws2812bc_hdl:led_pattern_emitter:1.0\
user.org:ws2812bc_hdl:axis_to_ws2812c:1.0\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set Dout [ create_bd_port -dir O Dout ]
  set sysclk [ create_bd_port -dir I -type clk -freq_hz 125000000 sysclk ]
  set reset [ create_bd_port -dir I -type rst reset ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $reset
  set push_button_blue [ create_bd_port -dir I push_button_blue ]
  set push_button_green [ create_bd_port -dir I push_button_green ]
  set push_button_red [ create_bd_port -dir I push_button_red ]
  set push_button_rainbow [ create_bd_port -dir I push_button_rainbow ]
  set clkout_125 [ create_bd_port -dir O -type clk clkout_125 ]
  set rstout_125_n [ create_bd_port -dir O -from 0 -to 0 -type rst rstout_125_n ]

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [list \
    CONFIG.CLKOUT1_JITTER {119.348} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {125} \
    CONFIG.MMCM_CLKOUT0_DIVIDE_F {8.000} \
  ] $clk_wiz_0


  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property CONFIG.CONST_VAL {0} $xlconstant_0


  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]

  # Create instance: axis_switch_0, and set properties
  set axis_switch_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_switch:1.1 axis_switch_0 ]
  set_property CONFIG.NUM_SI {4} $axis_switch_0


  # Create instance: led_pattern_emitter_0, and set properties
  set led_pattern_emitter_0 [ create_bd_cell -type ip -vlnv user.org:ws2812bc_hdl:led_pattern_emitter:1.0 led_pattern_emitter_0 ]
  set_property CONFIG.C_NUM_LEDS {150} $led_pattern_emitter_0


  # Create instance: led_pattern_emitter_1, and set properties
  set led_pattern_emitter_1 [ create_bd_cell -type ip -vlnv user.org:ws2812bc_hdl:led_pattern_emitter:1.0 led_pattern_emitter_1 ]
  set_property CONFIG.C_NUM_LEDS {150} $led_pattern_emitter_1


  # Create instance: led_pattern_emitter_2, and set properties
  set led_pattern_emitter_2 [ create_bd_cell -type ip -vlnv user.org:ws2812bc_hdl:led_pattern_emitter:1.0 led_pattern_emitter_2 ]
  set_property -dict [list \
    CONFIG.C_NUM_LEDS {150} \
    CONFIG.C_PATTERN_LEN {1} \
  ] $led_pattern_emitter_2


  # Create instance: led_pattern_emitter_3, and set properties
  set led_pattern_emitter_3 [ create_bd_cell -type ip -vlnv user.org:ws2812bc_hdl:led_pattern_emitter:1.0 led_pattern_emitter_3 ]
  set_property -dict [list \
    CONFIG.C_NUM_LEDS {150} \
    CONFIG.C_PATTERN_LEN {12} \
  ] $led_pattern_emitter_3


  # Create instance: RED_PATTERN, and set properties
  set RED_PATTERN [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 RED_PATTERN ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0xFF0000} \
    CONFIG.CONST_WIDTH {24} \
  ] $RED_PATTERN


  # Create instance: GREEN_PATTERN, and set properties
  set GREEN_PATTERN [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 GREEN_PATTERN ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0x00FF00} \
    CONFIG.CONST_WIDTH {24} \
  ] $GREEN_PATTERN


  # Create instance: BLUE_PATTERN, and set properties
  set BLUE_PATTERN [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 BLUE_PATTERN ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0x0000FF} \
    CONFIG.CONST_WIDTH {24} \
  ] $BLUE_PATTERN


  # Create instance: RAINBOW_PATTERN, and set properties
  set RAINBOW_PATTERN [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 RAINBOW_PATTERN ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0xFF007FFF00FF7F00FF0000FF007FFF00FFFF00FF7F00FF007FFF00FFFF00FF7F00FF0000} \
    CONFIG.CONST_WIDTH {288} \
  ] $RAINBOW_PATTERN


  # Create instance: xlconstant_0_4wide, and set properties
  set xlconstant_0_4wide [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0_4wide ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {4} \
  ] $xlconstant_0_4wide


  # Create instance: axis_to_ws2812c_0, and set properties
  set axis_to_ws2812c_0 [ create_bd_cell -type ip -vlnv user.org:ws2812bc_hdl:axis_to_ws2812c:1.0 axis_to_ws2812c_0 ]
  set_property CONFIG.FREQ_HZ {125000000} $axis_to_ws2812c_0


  # Create interface connections
  connect_bd_intf_net -intf_net axis_switch_0_M00_AXIS [get_bd_intf_pins axis_switch_0/M00_AXIS] [get_bd_intf_pins axis_to_ws2812c_0/S_AXIS]
  connect_bd_intf_net -intf_net led_pattern_emitter_0_M_AXIS [get_bd_intf_pins led_pattern_emitter_0/M_AXIS] [get_bd_intf_pins axis_switch_0/S00_AXIS]
  connect_bd_intf_net -intf_net led_pattern_emitter_1_M_AXIS [get_bd_intf_pins led_pattern_emitter_1/M_AXIS] [get_bd_intf_pins axis_switch_0/S01_AXIS]
  connect_bd_intf_net -intf_net led_pattern_emitter_2_M_AXIS [get_bd_intf_pins led_pattern_emitter_2/M_AXIS] [get_bd_intf_pins axis_switch_0/S02_AXIS]
  connect_bd_intf_net -intf_net led_pattern_emitter_3_M_AXIS [get_bd_intf_pins led_pattern_emitter_3/M_AXIS] [get_bd_intf_pins axis_switch_0/S03_AXIS]

  # Create port connections
  connect_bd_net -net BLUE_PATTERN_dout [get_bd_pins BLUE_PATTERN/dout] [get_bd_pins led_pattern_emitter_2/pattern]
  connect_bd_net -net GREEN_PATTERN_dout [get_bd_pins GREEN_PATTERN/dout] [get_bd_pins led_pattern_emitter_1/pattern]
  connect_bd_net -net RAINBOW_PATTERN_dout [get_bd_pins RAINBOW_PATTERN/dout] [get_bd_pins led_pattern_emitter_3/pattern]
  connect_bd_net -net RED_PATTERN_dout [get_bd_pins RED_PATTERN/dout] [get_bd_pins led_pattern_emitter_0/pattern]
  connect_bd_net -net axis_to_ws2812c_0_Dout [get_bd_pins axis_to_ws2812c_0/Dout] [get_bd_ports Dout]
  connect_bd_net -net clk_in1_0_1 [get_bd_ports sysclk] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins axis_switch_0/aclk] [get_bd_ports clkout_125] [get_bd_pins led_pattern_emitter_0/m_axis_aclk] [get_bd_pins led_pattern_emitter_1/m_axis_aclk] [get_bd_pins led_pattern_emitter_2/m_axis_aclk] [get_bd_pins led_pattern_emitter_3/m_axis_aclk] [get_bd_pins axis_to_ws2812c_0/aclk]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_0/dcm_locked]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins proc_sys_reset_0/interconnect_aresetn] [get_bd_pins axis_switch_0/aresetn] [get_bd_pins axis_to_ws2812c_0/aresetn]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_ports rstout_125_n] [get_bd_pins led_pattern_emitter_0/m_axis_aresetn] [get_bd_pins led_pattern_emitter_1/m_axis_aresetn] [get_bd_pins led_pattern_emitter_2/m_axis_aresetn] [get_bd_pins led_pattern_emitter_3/m_axis_aresetn]
  connect_bd_net -net reset_0_1 [get_bd_ports reset] [get_bd_pins clk_wiz_0/reset] [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net send_0_1 [get_bd_ports push_button_blue] [get_bd_pins led_pattern_emitter_2/send]
  connect_bd_net -net send_1_1 [get_bd_ports push_button_green] [get_bd_pins led_pattern_emitter_1/send]
  connect_bd_net -net send_2_1 [get_bd_ports push_button_red] [get_bd_pins led_pattern_emitter_0/send]
  connect_bd_net -net send_3_1 [get_bd_ports push_button_rainbow] [get_bd_pins led_pattern_emitter_3/send]
  connect_bd_net -net xlconstant_0_4wide_dout [get_bd_pins xlconstant_0_4wide/dout] [get_bd_pins axis_switch_0/s_req_suppress]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconstant_0/dout] [get_bd_pins proc_sys_reset_0/mb_debug_sys_rst]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins xlconstant_1/dout] [get_bd_pins proc_sys_reset_0/aux_reset_in]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


common::send_gid_msg -ssname BD::TCL -id 2053 -severity "WARNING" "This Tcl script was generated from a block design that has not been validated. It is possible that design <$design_name> may result in errors during validation."


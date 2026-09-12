# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  set FREQ_HZ [ipgui::add_param $IPINST -name "FREQ_HZ" -parent ${Page_0}]
  set_property tooltip {Frequency in Hz} ${FREQ_HZ}
  ipgui::add_param $IPINST -name "FIFO_DEPTH" -parent ${Page_0}
  #Adding Group
  set WS2812C_Timing [ipgui::add_group $IPINST -name "WS2812C Timing" -parent ${Page_0}]
  set_property tooltip {Timing parameters of the WS2812C driver (using the exact maximum or minimum values is not recommended)} ${WS2812C_Timing}
  ipgui::add_static_text $IPINST -name "WARNING:" -parent ${WS2812C_Timing} -text {WARNING: Using the exact maximum or minimum values is not recommended}
  set T0H [ipgui::add_param $IPINST -name "T0H" -parent ${WS2812C_Timing}]
  set_property tooltip {T0H time in nanoseconds (using the exact minimum or maximum is not recommended)} ${T0H}
  set T0L [ipgui::add_param $IPINST -name "T0L" -parent ${WS2812C_Timing}]
  set_property tooltip {T0L time in nanoseconds (using the exact minimum or maximum is not recommended)} ${T0L}
  set T1H [ipgui::add_param $IPINST -name "T1H" -parent ${WS2812C_Timing}]
  set_property tooltip {T1H time in nanoseconds (using the exact minimum or maximum is not recommended)} ${T1H}
  set T1L [ipgui::add_param $IPINST -name "T1L" -parent ${WS2812C_Timing}]
  set_property tooltip {T1L time in nanoseconds (using the exact minimum or maximum is not recommended)} ${T1L}
  set RESET_TIME [ipgui::add_param $IPINST -name "RESET_TIME" -parent ${WS2812C_Timing}]
  set_property tooltip {RES time in nanoseconds (using the exact minimum is not recommended)} ${RESET_TIME}

  #Adding Group
  set Data_Bus [ipgui::add_group $IPINST -name "Data Bus" -parent ${Page_0}]
  set_property tooltip {Format of the color data bus} ${Data_Bus}
  set TDATA_WIDTH [ipgui::add_param $IPINST -name "TDATA_WIDTH" -parent ${Data_Bus}]
  set_property tooltip {Width of TDATA} ${TDATA_WIDTH}
  set R_START_INDEX [ipgui::add_param $IPINST -name "R_START_INDEX" -parent ${Data_Bus}]
  set_property tooltip {Start index of 8-bit red on the data bus} ${R_START_INDEX}
  ipgui::add_param $IPINST -name "G_START_INDEX" -parent ${Data_Bus}
  ipgui::add_param $IPINST -name "B_START_INDEX" -parent ${Data_Bus}



}

proc update_PARAM_VALUE.B_START_INDEX { PARAM_VALUE.B_START_INDEX } {
	# Procedure called to update B_START_INDEX when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.B_START_INDEX { PARAM_VALUE.B_START_INDEX } {
	# Procedure called to validate B_START_INDEX
	return true
}

proc update_PARAM_VALUE.COLOR_WIDTH { PARAM_VALUE.COLOR_WIDTH } {
	# Procedure called to update COLOR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.COLOR_WIDTH { PARAM_VALUE.COLOR_WIDTH } {
	# Procedure called to validate COLOR_WIDTH
	return true
}

proc update_PARAM_VALUE.FIFO_DEPTH { PARAM_VALUE.FIFO_DEPTH } {
	# Procedure called to update FIFO_DEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FIFO_DEPTH { PARAM_VALUE.FIFO_DEPTH } {
	# Procedure called to validate FIFO_DEPTH
	return true
}

proc update_PARAM_VALUE.FREQ_HZ { PARAM_VALUE.FREQ_HZ } {
	# Procedure called to update FREQ_HZ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FREQ_HZ { PARAM_VALUE.FREQ_HZ } {
	# Procedure called to validate FREQ_HZ
	return true
}

proc update_PARAM_VALUE.G_START_INDEX { PARAM_VALUE.G_START_INDEX } {
	# Procedure called to update G_START_INDEX when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.G_START_INDEX { PARAM_VALUE.G_START_INDEX } {
	# Procedure called to validate G_START_INDEX
	return true
}

proc update_PARAM_VALUE.RESET_TIME { PARAM_VALUE.RESET_TIME } {
	# Procedure called to update RESET_TIME when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RESET_TIME { PARAM_VALUE.RESET_TIME } {
	# Procedure called to validate RESET_TIME
	return true
}

proc update_PARAM_VALUE.R_START_INDEX { PARAM_VALUE.R_START_INDEX } {
	# Procedure called to update R_START_INDEX when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.R_START_INDEX { PARAM_VALUE.R_START_INDEX } {
	# Procedure called to validate R_START_INDEX
	return true
}

proc update_PARAM_VALUE.T0H { PARAM_VALUE.T0H } {
	# Procedure called to update T0H when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.T0H { PARAM_VALUE.T0H } {
	# Procedure called to validate T0H
	return true
}

proc update_PARAM_VALUE.T0L { PARAM_VALUE.T0L } {
	# Procedure called to update T0L when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.T0L { PARAM_VALUE.T0L } {
	# Procedure called to validate T0L
	return true
}

proc update_PARAM_VALUE.T1H { PARAM_VALUE.T1H } {
	# Procedure called to update T1H when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.T1H { PARAM_VALUE.T1H } {
	# Procedure called to validate T1H
	return true
}

proc update_PARAM_VALUE.T1L { PARAM_VALUE.T1L } {
	# Procedure called to update T1L when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.T1L { PARAM_VALUE.T1L } {
	# Procedure called to validate T1L
	return true
}

proc update_PARAM_VALUE.TDATA_WIDTH { PARAM_VALUE.TDATA_WIDTH } {
	# Procedure called to update TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TDATA_WIDTH { PARAM_VALUE.TDATA_WIDTH } {
	# Procedure called to validate TDATA_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.FREQ_HZ { MODELPARAM_VALUE.FREQ_HZ PARAM_VALUE.FREQ_HZ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FREQ_HZ}] ${MODELPARAM_VALUE.FREQ_HZ}
}

proc update_MODELPARAM_VALUE.TDATA_WIDTH { MODELPARAM_VALUE.TDATA_WIDTH PARAM_VALUE.TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TDATA_WIDTH}] ${MODELPARAM_VALUE.TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.COLOR_WIDTH { MODELPARAM_VALUE.COLOR_WIDTH PARAM_VALUE.COLOR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.COLOR_WIDTH}] ${MODELPARAM_VALUE.COLOR_WIDTH}
}

proc update_MODELPARAM_VALUE.R_START_INDEX { MODELPARAM_VALUE.R_START_INDEX PARAM_VALUE.R_START_INDEX } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.R_START_INDEX}] ${MODELPARAM_VALUE.R_START_INDEX}
}

proc update_MODELPARAM_VALUE.G_START_INDEX { MODELPARAM_VALUE.G_START_INDEX PARAM_VALUE.G_START_INDEX } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.G_START_INDEX}] ${MODELPARAM_VALUE.G_START_INDEX}
}

proc update_MODELPARAM_VALUE.B_START_INDEX { MODELPARAM_VALUE.B_START_INDEX PARAM_VALUE.B_START_INDEX } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.B_START_INDEX}] ${MODELPARAM_VALUE.B_START_INDEX}
}

proc update_MODELPARAM_VALUE.FIFO_DEPTH { MODELPARAM_VALUE.FIFO_DEPTH PARAM_VALUE.FIFO_DEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FIFO_DEPTH}] ${MODELPARAM_VALUE.FIFO_DEPTH}
}

proc update_MODELPARAM_VALUE.T0H { MODELPARAM_VALUE.T0H PARAM_VALUE.T0H } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.T0H}] ${MODELPARAM_VALUE.T0H}
}

proc update_MODELPARAM_VALUE.T1H { MODELPARAM_VALUE.T1H PARAM_VALUE.T1H } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.T1H}] ${MODELPARAM_VALUE.T1H}
}

proc update_MODELPARAM_VALUE.T0L { MODELPARAM_VALUE.T0L PARAM_VALUE.T0L } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.T0L}] ${MODELPARAM_VALUE.T0L}
}

proc update_MODELPARAM_VALUE.T1L { MODELPARAM_VALUE.T1L PARAM_VALUE.T1L } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.T1L}] ${MODELPARAM_VALUE.T1L}
}

proc update_MODELPARAM_VALUE.RESET_TIME { MODELPARAM_VALUE.RESET_TIME PARAM_VALUE.RESET_TIME } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RESET_TIME}] ${MODELPARAM_VALUE.RESET_TIME}
}


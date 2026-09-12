# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  set C_PATTERN_LEN [ipgui::add_param $IPINST -name "C_PATTERN_LEN" -parent ${Page_0}]
  set_property tooltip {Length of pattern to drive to LEDs} ${C_PATTERN_LEN}
  set C_NUM_LEDS [ipgui::add_param $IPINST -name "C_NUM_LEDS" -parent ${Page_0}]
  set_property tooltip {Number of LEDs in the strip} ${C_NUM_LEDS}
  ipgui::add_param $IPINST -name "C_M_AXIS_TDATA_WIDTH" -parent ${Page_0}


}

proc update_PARAM_VALUE.C_NUM_LEDS { PARAM_VALUE.C_NUM_LEDS } {
	# Procedure called to update C_NUM_LEDS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_NUM_LEDS { PARAM_VALUE.C_NUM_LEDS } {
	# Procedure called to validate C_NUM_LEDS
	return true
}

proc update_PARAM_VALUE.C_PATTERN_LEN { PARAM_VALUE.C_PATTERN_LEN } {
	# Procedure called to update C_PATTERN_LEN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_PATTERN_LEN { PARAM_VALUE.C_PATTERN_LEN } {
	# Procedure called to validate C_PATTERN_LEN
	return true
}

proc update_PARAM_VALUE.C_M_AXIS_TDATA_WIDTH { PARAM_VALUE.C_M_AXIS_TDATA_WIDTH } {
	# Procedure called to update C_M_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXIS_TDATA_WIDTH { PARAM_VALUE.C_M_AXIS_TDATA_WIDTH } {
	# Procedure called to validate C_M_AXIS_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M_AXIS_START_COUNT { PARAM_VALUE.C_M_AXIS_START_COUNT } {
	# Procedure called to update C_M_AXIS_START_COUNT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXIS_START_COUNT { PARAM_VALUE.C_M_AXIS_START_COUNT } {
	# Procedure called to validate C_M_AXIS_START_COUNT
	return true
}


proc update_MODELPARAM_VALUE.C_M_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.C_M_AXIS_TDATA_WIDTH PARAM_VALUE.C_M_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_M_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXIS_START_COUNT { MODELPARAM_VALUE.C_M_AXIS_START_COUNT PARAM_VALUE.C_M_AXIS_START_COUNT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXIS_START_COUNT}] ${MODELPARAM_VALUE.C_M_AXIS_START_COUNT}
}

proc update_MODELPARAM_VALUE.C_NUM_LEDS { MODELPARAM_VALUE.C_NUM_LEDS PARAM_VALUE.C_NUM_LEDS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_NUM_LEDS}] ${MODELPARAM_VALUE.C_NUM_LEDS}
}

proc update_MODELPARAM_VALUE.C_PATTERN_LEN { MODELPARAM_VALUE.C_PATTERN_LEN PARAM_VALUE.C_PATTERN_LEN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_PATTERN_LEN}] ${MODELPARAM_VALUE.C_PATTERN_LEN}
}


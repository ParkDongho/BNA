# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  ipgui::add_page $IPINST -name "Page 0"

  ipgui::add_param $IPINST -name "ACTIVATION_RD_BASE_ADDR"
  ipgui::add_param $IPINST -name "WEIGHT_RD_BASE_ADDR"
  ipgui::add_param $IPINST -name "ACTIVATION_WR_BASE_ADDR"
  ipgui::add_param $IPINST -name "ACCUM_ADDR_WIDTH"

}

proc update_PARAM_VALUE.ACCUM_ADDR_WIDTH { PARAM_VALUE.ACCUM_ADDR_WIDTH } {
	# Procedure called to update ACCUM_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ACCUM_ADDR_WIDTH { PARAM_VALUE.ACCUM_ADDR_WIDTH } {
	# Procedure called to validate ACCUM_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.ACCUM_DATA_WIDTH { PARAM_VALUE.ACCUM_DATA_WIDTH } {
	# Procedure called to update ACCUM_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ACCUM_DATA_WIDTH { PARAM_VALUE.ACCUM_DATA_WIDTH } {
	# Procedure called to validate ACCUM_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.ACTIVATION_RD_BASE_ADDR { PARAM_VALUE.ACTIVATION_RD_BASE_ADDR } {
	# Procedure called to update ACTIVATION_RD_BASE_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ACTIVATION_RD_BASE_ADDR { PARAM_VALUE.ACTIVATION_RD_BASE_ADDR } {
	# Procedure called to validate ACTIVATION_RD_BASE_ADDR
	return true
}

proc update_PARAM_VALUE.ACTIVATION_WR_BASE_ADDR { PARAM_VALUE.ACTIVATION_WR_BASE_ADDR } {
	# Procedure called to update ACTIVATION_WR_BASE_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ACTIVATION_WR_BASE_ADDR { PARAM_VALUE.ACTIVATION_WR_BASE_ADDR } {
	# Procedure called to validate ACTIVATION_WR_BASE_ADDR
	return true
}

proc update_PARAM_VALUE.AXI_LITE_WIDTH_AD { PARAM_VALUE.AXI_LITE_WIDTH_AD } {
	# Procedure called to update AXI_LITE_WIDTH_AD when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI_LITE_WIDTH_AD { PARAM_VALUE.AXI_LITE_WIDTH_AD } {
	# Procedure called to validate AXI_LITE_WIDTH_AD
	return true
}

proc update_PARAM_VALUE.AXI_LITE_WIDTH_DA { PARAM_VALUE.AXI_LITE_WIDTH_DA } {
	# Procedure called to update AXI_LITE_WIDTH_DA when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI_LITE_WIDTH_DA { PARAM_VALUE.AXI_LITE_WIDTH_DA } {
	# Procedure called to validate AXI_LITE_WIDTH_DA
	return true
}

proc update_PARAM_VALUE.AXI_LITE_WIDTH_DS { PARAM_VALUE.AXI_LITE_WIDTH_DS } {
	# Procedure called to update AXI_LITE_WIDTH_DS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI_LITE_WIDTH_DS { PARAM_VALUE.AXI_LITE_WIDTH_DS } {
	# Procedure called to validate AXI_LITE_WIDTH_DS
	return true
}

proc update_PARAM_VALUE.AXI_WIDTH_AD { PARAM_VALUE.AXI_WIDTH_AD } {
	# Procedure called to update AXI_WIDTH_AD when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI_WIDTH_AD { PARAM_VALUE.AXI_WIDTH_AD } {
	# Procedure called to validate AXI_WIDTH_AD
	return true
}

proc update_PARAM_VALUE.AXI_WIDTH_DA { PARAM_VALUE.AXI_WIDTH_DA } {
	# Procedure called to update AXI_WIDTH_DA when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI_WIDTH_DA { PARAM_VALUE.AXI_WIDTH_DA } {
	# Procedure called to validate AXI_WIDTH_DA
	return true
}

proc update_PARAM_VALUE.AXI_WIDTH_DS { PARAM_VALUE.AXI_WIDTH_DS } {
	# Procedure called to update AXI_WIDTH_DS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI_WIDTH_DS { PARAM_VALUE.AXI_WIDTH_DS } {
	# Procedure called to validate AXI_WIDTH_DS
	return true
}

proc update_PARAM_VALUE.AXI_WIDTH_ID { PARAM_VALUE.AXI_WIDTH_ID } {
	# Procedure called to update AXI_WIDTH_ID when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI_WIDTH_ID { PARAM_VALUE.AXI_WIDTH_ID } {
	# Procedure called to validate AXI_WIDTH_ID
	return true
}

proc update_PARAM_VALUE.AXI_WIDTH_USER { PARAM_VALUE.AXI_WIDTH_USER } {
	# Procedure called to update AXI_WIDTH_USER when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI_WIDTH_USER { PARAM_VALUE.AXI_WIDTH_USER } {
	# Procedure called to validate AXI_WIDTH_USER
	return true
}

proc update_PARAM_VALUE.BIAS_ROM_ADDR { PARAM_VALUE.BIAS_ROM_ADDR } {
	# Procedure called to update BIAS_ROM_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BIAS_ROM_ADDR { PARAM_VALUE.BIAS_ROM_ADDR } {
	# Procedure called to validate BIAS_ROM_ADDR
	return true
}

proc update_PARAM_VALUE.BUFFER_ADDR_WIDTH { PARAM_VALUE.BUFFER_ADDR_WIDTH } {
	# Procedure called to update BUFFER_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BUFFER_ADDR_WIDTH { PARAM_VALUE.BUFFER_ADDR_WIDTH } {
	# Procedure called to validate BUFFER_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.EXPONENT_WIDTH { PARAM_VALUE.EXPONENT_WIDTH } {
	# Procedure called to update EXPONENT_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.EXPONENT_WIDTH { PARAM_VALUE.EXPONENT_WIDTH } {
	# Procedure called to validate EXPONENT_WIDTH
	return true
}

proc update_PARAM_VALUE.MAC_ACC_WIDTH { PARAM_VALUE.MAC_ACC_WIDTH } {
	# Procedure called to update MAC_ACC_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAC_ACC_WIDTH { PARAM_VALUE.MAC_ACC_WIDTH } {
	# Procedure called to validate MAC_ACC_WIDTH
	return true
}

proc update_PARAM_VALUE.PARAM_ROM_ADDR_WIDTH { PARAM_VALUE.PARAM_ROM_ADDR_WIDTH } {
	# Procedure called to update PARAM_ROM_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PARAM_ROM_ADDR_WIDTH { PARAM_VALUE.PARAM_ROM_ADDR_WIDTH } {
	# Procedure called to validate PARAM_ROM_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.QUNATIZED_MANTISSA_WIDTH { PARAM_VALUE.QUNATIZED_MANTISSA_WIDTH } {
	# Procedure called to update QUNATIZED_MANTISSA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.QUNATIZED_MANTISSA_WIDTH { PARAM_VALUE.QUNATIZED_MANTISSA_WIDTH } {
	# Procedure called to validate QUNATIZED_MANTISSA_WIDTH
	return true
}

proc update_PARAM_VALUE.WEIGHT_RAM_ADDR_WIDTH { PARAM_VALUE.WEIGHT_RAM_ADDR_WIDTH } {
	# Procedure called to update WEIGHT_RAM_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WEIGHT_RAM_ADDR_WIDTH { PARAM_VALUE.WEIGHT_RAM_ADDR_WIDTH } {
	# Procedure called to validate WEIGHT_RAM_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.WEIGHT_RD_BASE_ADDR { PARAM_VALUE.WEIGHT_RD_BASE_ADDR } {
	# Procedure called to update WEIGHT_RD_BASE_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WEIGHT_RD_BASE_ADDR { PARAM_VALUE.WEIGHT_RD_BASE_ADDR } {
	# Procedure called to validate WEIGHT_RD_BASE_ADDR
	return true
}


proc update_MODELPARAM_VALUE.EXPONENT_WIDTH { MODELPARAM_VALUE.EXPONENT_WIDTH PARAM_VALUE.EXPONENT_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.EXPONENT_WIDTH}] ${MODELPARAM_VALUE.EXPONENT_WIDTH}
}

proc update_MODELPARAM_VALUE.WEIGHT_RAM_ADDR_WIDTH { MODELPARAM_VALUE.WEIGHT_RAM_ADDR_WIDTH PARAM_VALUE.WEIGHT_RAM_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WEIGHT_RAM_ADDR_WIDTH}] ${MODELPARAM_VALUE.WEIGHT_RAM_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.MAC_ACC_WIDTH { MODELPARAM_VALUE.MAC_ACC_WIDTH PARAM_VALUE.MAC_ACC_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAC_ACC_WIDTH}] ${MODELPARAM_VALUE.MAC_ACC_WIDTH}
}

proc update_MODELPARAM_VALUE.QUNATIZED_MANTISSA_WIDTH { MODELPARAM_VALUE.QUNATIZED_MANTISSA_WIDTH PARAM_VALUE.QUNATIZED_MANTISSA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.QUNATIZED_MANTISSA_WIDTH}] ${MODELPARAM_VALUE.QUNATIZED_MANTISSA_WIDTH}
}

proc update_MODELPARAM_VALUE.AXI_WIDTH_USER { MODELPARAM_VALUE.AXI_WIDTH_USER PARAM_VALUE.AXI_WIDTH_USER } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXI_WIDTH_USER}] ${MODELPARAM_VALUE.AXI_WIDTH_USER}
}

proc update_MODELPARAM_VALUE.AXI_WIDTH_ID { MODELPARAM_VALUE.AXI_WIDTH_ID PARAM_VALUE.AXI_WIDTH_ID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXI_WIDTH_ID}] ${MODELPARAM_VALUE.AXI_WIDTH_ID}
}

proc update_MODELPARAM_VALUE.AXI_WIDTH_AD { MODELPARAM_VALUE.AXI_WIDTH_AD PARAM_VALUE.AXI_WIDTH_AD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXI_WIDTH_AD}] ${MODELPARAM_VALUE.AXI_WIDTH_AD}
}

proc update_MODELPARAM_VALUE.AXI_WIDTH_DA { MODELPARAM_VALUE.AXI_WIDTH_DA PARAM_VALUE.AXI_WIDTH_DA } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXI_WIDTH_DA}] ${MODELPARAM_VALUE.AXI_WIDTH_DA}
}

proc update_MODELPARAM_VALUE.AXI_WIDTH_DS { MODELPARAM_VALUE.AXI_WIDTH_DS PARAM_VALUE.AXI_WIDTH_DS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXI_WIDTH_DS}] ${MODELPARAM_VALUE.AXI_WIDTH_DS}
}

proc update_MODELPARAM_VALUE.AXI_LITE_WIDTH_AD { MODELPARAM_VALUE.AXI_LITE_WIDTH_AD PARAM_VALUE.AXI_LITE_WIDTH_AD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXI_LITE_WIDTH_AD}] ${MODELPARAM_VALUE.AXI_LITE_WIDTH_AD}
}

proc update_MODELPARAM_VALUE.AXI_LITE_WIDTH_DA { MODELPARAM_VALUE.AXI_LITE_WIDTH_DA PARAM_VALUE.AXI_LITE_WIDTH_DA } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXI_LITE_WIDTH_DA}] ${MODELPARAM_VALUE.AXI_LITE_WIDTH_DA}
}

proc update_MODELPARAM_VALUE.AXI_LITE_WIDTH_DS { MODELPARAM_VALUE.AXI_LITE_WIDTH_DS PARAM_VALUE.AXI_LITE_WIDTH_DS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXI_LITE_WIDTH_DS}] ${MODELPARAM_VALUE.AXI_LITE_WIDTH_DS}
}

proc update_MODELPARAM_VALUE.BIAS_ROM_ADDR { MODELPARAM_VALUE.BIAS_ROM_ADDR PARAM_VALUE.BIAS_ROM_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BIAS_ROM_ADDR}] ${MODELPARAM_VALUE.BIAS_ROM_ADDR}
}

proc update_MODELPARAM_VALUE.BUFFER_ADDR_WIDTH { MODELPARAM_VALUE.BUFFER_ADDR_WIDTH PARAM_VALUE.BUFFER_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BUFFER_ADDR_WIDTH}] ${MODELPARAM_VALUE.BUFFER_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.ACCUM_DATA_WIDTH { MODELPARAM_VALUE.ACCUM_DATA_WIDTH PARAM_VALUE.ACCUM_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ACCUM_DATA_WIDTH}] ${MODELPARAM_VALUE.ACCUM_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.ACCUM_ADDR_WIDTH { MODELPARAM_VALUE.ACCUM_ADDR_WIDTH PARAM_VALUE.ACCUM_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ACCUM_ADDR_WIDTH}] ${MODELPARAM_VALUE.ACCUM_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.PARAM_ROM_ADDR_WIDTH { MODELPARAM_VALUE.PARAM_ROM_ADDR_WIDTH PARAM_VALUE.PARAM_ROM_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PARAM_ROM_ADDR_WIDTH}] ${MODELPARAM_VALUE.PARAM_ROM_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.ACTIVATION_RD_BASE_ADDR { MODELPARAM_VALUE.ACTIVATION_RD_BASE_ADDR PARAM_VALUE.ACTIVATION_RD_BASE_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ACTIVATION_RD_BASE_ADDR}] ${MODELPARAM_VALUE.ACTIVATION_RD_BASE_ADDR}
}

proc update_MODELPARAM_VALUE.WEIGHT_RD_BASE_ADDR { MODELPARAM_VALUE.WEIGHT_RD_BASE_ADDR PARAM_VALUE.WEIGHT_RD_BASE_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WEIGHT_RD_BASE_ADDR}] ${MODELPARAM_VALUE.WEIGHT_RD_BASE_ADDR}
}

proc update_MODELPARAM_VALUE.ACTIVATION_WR_BASE_ADDR { MODELPARAM_VALUE.ACTIVATION_WR_BASE_ADDR PARAM_VALUE.ACTIVATION_WR_BASE_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ACTIVATION_WR_BASE_ADDR}] ${MODELPARAM_VALUE.ACTIVATION_WR_BASE_ADDR}
}


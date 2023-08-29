# Copyright (C) 2023  AGH University of Science and Technology
# MTM UEC2
# Author: Piotr Kaczmarczyk
#
# Description:
# Project detiles required for generate_bitstream.tcl
# Make sure that project_name, top_module and target are correct.
# Provide paths to all the files required for synthesis and implementation.
# Depending on the file type, it should be added in the corresponding section.
# If the project does not use files of some type, leave the corresponding section commented out.

#-----------------------------------------------------#
#                   Project details                   #
#-----------------------------------------------------#
# Project name                                  -- EDIT
set project_name oscilloscope

# Top module name                               -- EDIT
set top_module top_oscilloscope_basys3

# FPGA device
set target xc7a35tcpg236-1

#-----------------------------------------------------#
#                    Design sources                   #
#-----------------------------------------------------#
# Specify .xdc files location                   -- EDIT
set xdc_files {
    constraints/top_vga_basys3.xdc
	constraints/clk_wiz_0.xdc
	constraints/clk_wiz_0_late.xdc
}

# Specify SystemVerilog design files location   -- EDIT
set sv_files {
	../rtl/vga_pkg.sv
	../rtl/vga_timing.sv
	../rtl/draw_bg.sv
	../rtl/top_oscilloscope.sv
	../rtl/adc_control.sv
	../rtl/dft.sv
	../rtl/draw_display.sv
	../rtl/draw_mouse.sv
	../rtl/low_pass.sv
	../rtl/sin_gen.sv
	../rtl/trigger.sv
	../rtl/Binary2Decimal.sv
	../rtl/trigger_rom.sv
	../rtl/clk_divider.sv
	../rtl/user_interface.sv
	../rtl/vga_if.sv
	../rtl/clock_adc.sv
	../rtl/font_gen.sv
    rtl/top_oscilloscope_basys3.sv
}

# Specify Verilog design files location         -- EDIT
 set verilog_files {
	../rtl/delay.v
	../rtl/clk_wiz_0_clk_wiz.v
	../rtl/clk_wiz_0.v
	../rtl/font_rom.v
 }

# Specify VHDL design files location            -- EDIT
 set vhdl_files {
    	../rtl/MouseCtl.vhd
	../rtl/MouseDisplay.vhd
	../rtl/Ps2Interface.vhd
 }

# Specify files for a memory initialization     -- EDIT
# set mem_files {
#    path/to/file.data
# }

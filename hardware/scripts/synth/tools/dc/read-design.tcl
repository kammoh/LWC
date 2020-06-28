#=========================================================================
# read-design.tcl
#=========================================================================
# Author : Christopher Torng
# Date   : May 14, 2018
#

# Check libraries

check_library > $dc_reports_dir/${dc_design_name}.check_library.rpt

# The first "WORK" is a reserved word for Design Compiler. The value for
# the -path option is customizable.

define_design_lib WORK -path ${dc_results_dir}/WORK

# Analyze the RTL source file

set dc_sv_files $::env(VERILOG_FILES)
set dc_vhdl_files $::env(VHDL_FILES)

if {$dc_sv_files ne ""} then {
  if { ![analyze -format sverilog $dc_sv_files] } { exit 1 }
}

if {$dc_vhdl_files ne ""} then {
  if { ![analyze -format vhdl $dc_vhdl_files] } { exit 1 }
}

# Elaborate the design with design parameters from a file, or else just
# elaborate normally

if {[file exists [which setup-design-params.txt]]} {
  elaborate $dc_design_name -file_parameters setup-design-params.txt
  rename_design $dc_design_name* $dc_design_name
} else {
  elaborate $dc_design_name
}

current_design $dc_design_name
link

#-------------------------------------------------------------------------
# Write out useful files
#-------------------------------------------------------------------------

# This ddc can be used as a checkpoint to load up to the current state

write -hierarchy -format ddc \
      -output ${dc_results_dir}/${dc_design_name}.elab.ddc

# This Verilog is useful to double-check the netlist that dc will use for
# mapping

write -hierarchy -format verilog \
      -output ${dc_results_dir}/${dc_design_name}.elab.v



transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vcom -93 -work work {DAC.vho}

vcom -93 -work work {D:/Users/DouNe/Documents/Cours/VHDL/DAC_restored/tb_ram.vhd}

vsim -t 1ps -L altera -L altera_lnsim -L cyclonev -L gate_work -L work -voptargs="+acc"  tb_ram

add wave *
view structure
view signals
run -all

transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {/home/doune/Documents/ENSSAT/vhdl/DAC_restored/control_unit.vhd}
vcom -93 -work work {/home/doune/Documents/ENSSAT/vhdl/DAC_restored/block_v1.vhd}
vcom -93 -work work {/home/doune/Documents/ENSSAT/vhdl/DAC_restored/counter.vhd}
vcom -93 -work work {/home/doune/Documents/ENSSAT/vhdl/DAC_restored/ram_sync.vhd}
vcom -93 -work work {/home/doune/Documents/ENSSAT/vhdl/DAC_restored/ram_async.vhd}
vcom -93 -work work {/home/doune/Documents/ENSSAT/vhdl/DAC_restored/pack_son.vhd}
vcom -93 -work work {/home/doune/Documents/ENSSAT/vhdl/DAC_restored/DEONANOSon.vhd}
vcom -93 -work work {/home/doune/Documents/ENSSAT/vhdl/DAC_restored/DAC.vhd}
vcom -93 -work work {/home/doune/Documents/ENSSAT/vhdl/DAC_restored/ADC2.vhd}

vcom -93 -work work {/home/doune/Documents/ENSSAT/vhdl/DAC_restored/tb_counter.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cyclonev -L rtl_work -L work -voptargs="+acc"  tb_counter

add wave *
view structure
view signals
run 5 us

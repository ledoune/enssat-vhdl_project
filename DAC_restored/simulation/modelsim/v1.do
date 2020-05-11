onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_block_v1/data_in
add wave -noupdate /tb_block_v1/data_out
add wave -noupdate /tb_block_v1/leds
add wave -noupdate /tb_block_v1/v1/ctr_unit/s_sample_start
add wave -noupdate /tb_block_v1/v1/ctr_unit/s_sample_stop
add wave -noupdate /tb_block_v1/v1/ctr_unit/acq_cnt_write_value
add wave -noupdate /tb_block_v1/clk
add wave -noupdate /tb_block_v1/dac_enable
add wave -noupdate /tb_block_v1/data_in
add wave -noupdate /tb_block_v1/v1/s_data
add wave -noupdate /tb_block_v1/data_out
add wave -noupdate /tb_block_v1/leds
add wave -noupdate /tb_block_v1/button_rst
add wave -noupdate /tb_block_v1/button_acq
add wave -noupdate /tb_block_v1/button_trt
add wave -noupdate /tb_block_v1/button_res
add wave -noupdate -divider ctr_unit
add wave -noupdate /tb_block_v1/v1/ctr_unit/acq_ram_write_enable
add wave -noupdate /tb_block_v1/v1/ctr_unit/out_ram_write_enable
add wave -noupdate /tb_block_v1/v1/ctr_unit/cnt_reset_signals
add wave -noupdate /tb_block_v1/v1/ctr_unit/cnt_enable_signals
add wave -noupdate /tb_block_v1/v1/ctr_unit/state
add wave -noupdate /tb_block_v1/v1/ctr_unit/sample_start
add wave -noupdate /tb_block_v1/v1/ctr_unit/sample_stop
add wave -noupdate -divider counters
add wave -noupdate /tb_block_v1/v1/acq_cnt_read/output
add wave -noupdate /tb_block_v1/v1/acq_cnt_write/output
add wave -noupdate /tb_block_v1/v1/out_cnt_read/output
add wave -noupdate /tb_block_v1/v1/out_cnt_write/output
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {163432203390 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 309
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {420 ms}

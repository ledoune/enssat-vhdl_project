onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_block_v1/clk
add wave -noupdate /tb_block_v1/mesure_done
add wave -noupdate /tb_block_v1/dac_enable
add wave -noupdate /tb_block_v1/data_in
add wave -noupdate /tb_block_v1/data_out
add wave -noupdate /tb_block_v1/button_rst
add wave -noupdate /tb_block_v1/button_acq
add wave -noupdate /tb_block_v1/button_trt
add wave -noupdate /tb_block_v1/button_out
add wave -noupdate -divider <NULL>
add wave -noupdate -divider ctr_unit
add wave -noupdate -divider <NULL>
add wave -noupdate /tb_block_v1/v1/ctr_unit/button_rst
add wave -noupdate /tb_block_v1/v1/ctr_unit/button_acq
add wave -noupdate /tb_block_v1/v1/ctr_unit/button_trt
add wave -noupdate /tb_block_v1/v1/ctr_unit/button_out
add wave -noupdate /tb_block_v1/v1/ctr_unit/state
add wave -noupdate -divider acq_cnt_write
add wave -noupdate /tb_block_v1/v1/ctr_unit/acq_cnt_write_reset
add wave -noupdate /tb_block_v1/v1/ctr_unit/acq_cnt_write_enable
add wave -noupdate /tb_block_v1/v1/ctr_unit/acq_cnt_write_led
add wave -noupdate -divider acq_cnt_read
add wave -noupdate /tb_block_v1/v1/ctr_unit/acq_cnt_read_reset
add wave -noupdate /tb_block_v1/v1/ctr_unit/acq_cnt_read_enable
add wave -noupdate /tb_block_v1/v1/ctr_unit/acq_cnt_read_led
add wave -noupdate -divider out_cnt_write
add wave -noupdate /tb_block_v1/v1/ctr_unit/out_cnt_write_reset
add wave -noupdate /tb_block_v1/v1/ctr_unit/out_cnt_write_enable
add wave -noupdate /tb_block_v1/v1/ctr_unit/out_cnt_write_led
add wave -noupdate -divider out_cnt_read
add wave -noupdate /tb_block_v1/v1/ctr_unit/out_cnt_read_reset
add wave -noupdate /tb_block_v1/v1/ctr_unit/out_cnt_read_enable
add wave -noupdate /tb_block_v1/v1/ctr_unit/out_cnt_read_led
add wave -noupdate -divider ram_we
add wave -noupdate /tb_block_v1/v1/ctr_unit/out_ram_write_enable
add wave -noupdate /tb_block_v1/v1/ctr_unit/acq_ram_write_enable
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {166 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 293
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
WaveRestoreZoom {0 ps} {630 ns}

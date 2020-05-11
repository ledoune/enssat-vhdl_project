onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_control_unit/clk
add wave -noupdate /tb_control_unit/button_rst
add wave -noupdate /tb_control_unit/button_acq
add wave -noupdate /tb_control_unit/button_trt
add wave -noupdate /tb_control_unit/button_out
add wave -noupdate /tb_control_unit/ctr_unit/state
add wave -noupdate -divider acq
add wave -noupdate /tb_control_unit/acq_cnt_write_reset
add wave -noupdate /tb_control_unit/acq_cnt_write_enable
add wave -noupdate /tb_control_unit/acq_cnt_write_led
add wave -noupdate -divider trt
add wave -noupdate /tb_control_unit/acq_cnt_read_reset
add wave -noupdate /tb_control_unit/acq_cnt_read_enable
add wave -noupdate /tb_control_unit/acq_cnt_read_led
add wave -noupdate /tb_control_unit/out_cnt_write_reset
add wave -noupdate /tb_control_unit/out_cnt_write_enable
add wave -noupdate /tb_control_unit/out_cnt_write_led
add wave -noupdate -divider res
add wave -noupdate /tb_control_unit/out_cnt_read_reset
add wave -noupdate /tb_control_unit/out_cnt_read_enable
add wave -noupdate /tb_control_unit/out_cnt_read_led
add wave -noupdate -divider {New Divider}
add wave -noupdate /tb_control_unit/acq_ram_write_enable
add wave -noupdate /tb_control_unit/out_ram_write_enable
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {275735 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 305
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

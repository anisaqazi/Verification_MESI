onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/clk
add wave -noupdate /top/rst
add wave -noupdate /top/mesi_if_master0/mbus_cmd
add wave -noupdate /top/mesi_if_master0/mbus_cmd_wire
add wave -noupdate /top/mesi_if_master0/mbus_addr
add wave -noupdate /top/mesi_if_master0/mbus_addr_wire
add wave -noupdate /top/mesi_if_master0/mbus_ack
add wave -noupdate /top/mesi_if_master0/cbus_cmd
add wave -noupdate /top/mesi_if_master0/cbus_addr
add wave -noupdate /top/mesi_if_master0/cbus_ack
add wave -noupdate /top/mesi_if_master0/cbus_ack_wire
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {52 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 287
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
WaveRestoreZoom {0 ps} {879 ps}

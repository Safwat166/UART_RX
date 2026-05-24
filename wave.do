onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {Test bench signals} -color {Cornflower Blue} /UART_RX_TB/clk_tb
add wave -noupdate -expand -group {Test bench signals} -color {Dark Orchid} /UART_RX_TB/rx_in_tb
add wave -noupdate -expand -group {Test bench signals} -color {Cadet Blue} /UART_RX_TB/p_data_tb
add wave -noupdate -expand -group {Test bench signals} -color Coral /UART_RX_TB/data_valid_tb
add wave -noupdate -expand -group {Test bench signals} -color Gold /UART_RX_TB/parity_error_tb
add wave -noupdate -expand -group {Test bench signals} -color Cyan /UART_RX_TB/stop_error_tb
add wave -noupdate -expand -group {Test bench signals} /UART_RX_TB/rst_tb
add wave -noupdate -expand -group {Test bench signals} /UART_RX_TB/par_typ_tb
add wave -noupdate -expand -group {Test bench signals} /UART_RX_TB/par_en_tb
add wave -noupdate -expand -group {Test bench signals} -radix unsigned /UART_RX_TB/prescale_tb
add wave -noupdate -expand -group {DUT internals signals} -color {Slate Blue} /UART_RX_TB/DUT/sampled_bit
add wave -noupdate -expand -group {DUT internals signals} -color White /UART_RX_TB/DUT/strt_glitch
add wave -noupdate -expand -group {DUT internals signals} -color Gold -radix unsigned /UART_RX_TB/DUT/edge_cnt
add wave -noupdate -expand -group {DUT internals signals} -color Gold -radix unsigned /UART_RX_TB/DUT/bit_cnt
add wave -noupdate -expand -group {DUT internals signals} /UART_RX_TB/DUT/dat_samp_en
add wave -noupdate -expand -group {DUT internals signals} /UART_RX_TB/DUT/enable
add wave -noupdate -expand -group {DUT internals signals} /UART_RX_TB/DUT/deser_en
add wave -noupdate -expand -group {DUT internals signals} /UART_RX_TB/DUT/stp_chk_en
add wave -noupdate -expand -group {DUT internals signals} /UART_RX_TB/DUT/strt_chk_en
add wave -noupdate -expand -group {DUT internals signals} /UART_RX_TB/DUT/par_chk_en
add wave -noupdate -expand -group {FSM States} -color Turquoise /UART_RX_TB/DUT/F1/current_state
add wave -noupdate -expand -group {FSM States} -color Turquoise /UART_RX_TB/DUT/F1/next_state
add wave -noupdate -expand -group {Data sampling internal signals} -color {Slate Blue} /UART_RX_TB/DUT/S1/SAMPLED_BIT1
add wave -noupdate -expand -group {Data sampling internal signals} -color {Slate Blue} /UART_RX_TB/DUT/S1/SAMPLED_BIT2
add wave -noupdate -expand -group {Data sampling internal signals} -color {Slate Blue} /UART_RX_TB/DUT/S1/SAMPLED_BIT3
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {947615188 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 188
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {941851241 ps} {961337101 ps}

vlib work
vlog *.*v
vsim -voptargs=+acc work.UART_RX_TB
do wave.do
run -all
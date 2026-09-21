vlib work 
vlog -f files.list 
vsim  -voptargs=+acc work.RiscV_tb
do wave.do
run -all


vlib work 
vlog -f files.list 
vsim  -voptargs=+acc work.RiscV_tb
do wave.do
run -all
#saving signals
dataset save sim waveform.wlf

vlib work 
vlog *.v
vsim -voptargs=+acc RiscV_tb
add wave -position insertpoint  \
sim:/RiscV_tb/dut/clk \
sim:/RiscV_tb/dut/rst \
sim:/RiscV_tb/dut/branch \
sim:/RiscV_tb/dut/jump \
sim:/RiscV_tb/dut/memWrite \
sim:/RiscV_tb/dut/ALUSrc \
sim:/RiscV_tb/dut/RegWrite \
sim:/RiscV_tb/dut/zero \
sim:/RiscV_tb/dut/immSrc \
sim:/RiscV_tb/dut/resultSrc \
sim:/RiscV_tb/dut/ALUControl \
sim:/RiscV_tb/dut/ALU_ctrl \
sim:/RiscV_tb/dut/pc \
sim:/RiscV_tb/dut/pc_4 \
sim:/RiscV_tb/dut/instruction \
sim:/RiscV_tb/dut/RD1 \
sim:/RiscV_tb/dut/RD2 \
sim:/RiscV_tb/dut/WD3 \
sim:/RiscV_tb/dut/source2 \
sim:/RiscV_tb/dut/imm_out \
sim:/RiscV_tb/dut/ALU_out \
sim:/RiscV_tb/dut/mem_out
add wave -position insertpoint  \
sim:/RiscV_tb/dut/instruction_mem/mem 
add wave -position insertpoint  \
sim:/RiscV_tb/dut/reg_file/reg_file 
add wave -position insertpoint  \
sim:/RiscV_tb/dut/Baddr

run -all

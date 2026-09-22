onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider CLK/RST
add wave -noupdate /RiscV_tb/dut/clk
add wave -noupdate /RiscV_tb/dut/rst
add wave -noupdate /RiscV_tb/dut/data_out
add wave -noupdate -divider {decode stage}
add wave -noupdate /RiscV_tb/dut/instruction
add wave -noupdate /RiscV_tb/dut/instrD
add wave -noupdate /RiscV_tb/dut/PCD
add wave -noupdate /RiscV_tb/dut/PCplus4D
add wave -noupdate /RiscV_tb/dut/RD1
add wave -noupdate /RiscV_tb/dut/RD2
add wave -noupdate /RiscV_tb/dut/branch_d
add wave -noupdate /RiscV_tb/dut/jump_d
add wave -noupdate /RiscV_tb/dut/memWrite_d
add wave -noupdate /RiscV_tb/dut/ALUSrc_d
add wave -noupdate /RiscV_tb/dut/RegWrite_d
add wave -noupdate /RiscV_tb/dut/immSrc_d
add wave -noupdate /RiscV_tb/dut/ALUControl_d
add wave -noupdate /RiscV_tb/dut/imm_out
add wave -noupdate -divider {EXCECUTE STAGE}
add wave -noupdate /RiscV_tb/dut/branch_e
add wave -noupdate /RiscV_tb/dut/jump_e
add wave -noupdate /RiscV_tb/dut/memWrite_e
add wave -noupdate /RiscV_tb/dut/ALUSrc_e
add wave -noupdate /RiscV_tb/dut/RegWrite_e
add wave -noupdate /RiscV_tb/dut/branch_neq_e
add wave -noupdate /RiscV_tb/dut/immSrc_e
add wave -noupdate /RiscV_tb/dut/resultSrc_e
add wave -noupdate /RiscV_tb/dut/ALUControl_e
add wave -noupdate /RiscV_tb/dut/RD1E
add wave -noupdate /RiscV_tb/dut/RD2E
add wave -noupdate /RiscV_tb/dut/PCE
add wave -noupdate /RiscV_tb/dut/RdE
add wave -noupdate /RiscV_tb/dut/immextE
add wave -noupdate /RiscV_tb/dut/PCplus4E
add wave -noupdate /RiscV_tb/dut/branch_eq
add wave -noupdate /RiscV_tb/dut/branch_neq
add wave -noupdate /RiscV_tb/dut/zero
add wave -noupdate /RiscV_tb/dut/PCSrc
add wave -noupdate /RiscV_tb/dut/source2
add wave -noupdate /RiscV_tb/dut/source1
add wave -noupdate /RiscV_tb/dut/source2_in
add wave -noupdate /RiscV_tb/dut/ALU_out
add wave -noupdate -divider {MEMORY STAGE}
add wave -noupdate /RiscV_tb/dut/branch_m
add wave -noupdate /RiscV_tb/dut/jump_m
add wave -noupdate /RiscV_tb/dut/memWrite_m
add wave -noupdate /RiscV_tb/dut/ALUSrc_m
add wave -noupdate /RiscV_tb/dut/RegWrite_m
add wave -noupdate /RiscV_tb/dut/immSrc_m
add wave -noupdate /RiscV_tb/dut/resultSrc_m
add wave -noupdate /RiscV_tb/dut/ALUControl_m
add wave -noupdate /RiscV_tb/dut/ALUResultM
add wave -noupdate /RiscV_tb/dut/WriteDataM
add wave -noupdate /RiscV_tb/dut/RdM
add wave -noupdate /RiscV_tb/dut/PCplus4M
add wave -noupdate /RiscV_tb/dut/mem_out
add wave -noupdate -divider {WRITEBACK STAGE}
add wave -noupdate /RiscV_tb/dut/branch_w
add wave -noupdate /RiscV_tb/dut/jump_w
add wave -noupdate /RiscV_tb/dut/memWrite_w
add wave -noupdate /RiscV_tb/dut/ALUSrc_w
add wave -noupdate /RiscV_tb/dut/RegWrite_w
add wave -noupdate /RiscV_tb/dut/resultSrc_d
add wave -noupdate /RiscV_tb/dut/ALU_ctrl
add wave -noupdate /RiscV_tb/dut/pc
add wave -noupdate /RiscV_tb/dut/pc_4
add wave -noupdate /RiscV_tb/dut/WD3
add wave -noupdate /RiscV_tb/dut/target_pc
add wave -noupdate /RiscV_tb/dut/ALUResultW
add wave -noupdate /RiscV_tb/dut/ReadDataW
add wave -noupdate /RiscV_tb/dut/RdW
add wave -noupdate /RiscV_tb/dut/PCplus4W
add wave -noupdate /RiscV_tb/dut/branch2
add wave -noupdate /RiscV_tb/dut/immSrc_w
add wave -noupdate /RiscV_tb/dut/resultSrc_w
add wave -noupdate /RiscV_tb/dut/ALUControl_w
add wave -noupdate -divider {HAZARD CONTROL}
add wave -noupdate /RiscV_tb/dut/stallD
add wave -noupdate /RiscV_tb/dut/stallF
add wave -noupdate /RiscV_tb/dut/flushE
add wave -noupdate /RiscV_tb/dut/flushD
add wave -noupdate /RiscV_tb/dut/forwardAE
add wave -noupdate /RiscV_tb/dut/forwardBE
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 392
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
WaveRestoreZoom {0 ns} {845 ns}

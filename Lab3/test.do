vlog *.sv
vsim -voptargs=+acc work.simtop work.top
add wave -position insertpoint sim:/simtop/cpu/alu/* sim:/simtop/cpu/cu/* sim:/simtop/cpu/register/* sim:/simtop/cpu/decoder/* 
run 1000

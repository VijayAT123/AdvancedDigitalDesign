vlog *.sv
vsim -voptargs=+acc work.simtop
add wave -position insertpoint sim:/simtop/*
run 1000
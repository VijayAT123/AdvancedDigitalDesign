vlog *.sv
vsim -voptargs=+acc work.simtop
add wave -position insertpoint  \
sim:/simtop/clock \
sim:/simtop/reset \
sim:/simtop/SW \
sim:/simtop/gpio_out \
sim:/simtop/HEX \
sim:/simtop/HEX0 \
sim:/simtop/HEX1 \
sim:/simtop/HEX2 \
sim:/simtop/HEX3 \
sim:/simtop/HEX4 \
sim:/simtop/HEX5 \
sim:/simtop/HEX6 \
sim:/simtop/HEX7
run 251660000
vcom -reportprogress 300 -work work {F:/uni/Sem 5/DSD/PROJ1/code.vhd}
vsim work.universal_counter
add wave -position insertpoint  \
sim:/universal_counter/nrst \
sim:/universal_counter/clk \
sim:/universal_counter/mode \
sim:/universal_counter/din \
sim:/universal_counter/dout \
sim:/universal_counter/temp
force -freeze sim:/universal_counter/clk 1 0, 0 {5 ns} -r 10
force din b"01100111" 1ns
force nrst 0 0, 1 15ns
force mode 0 0, 1 25ns, 2 35ns, 4 45ns, 3 65ns, 5 75ns, 6 85ns, 7 100ns
run 110ns
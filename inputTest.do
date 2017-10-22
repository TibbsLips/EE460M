force clk 1 0, 0 5 -repeat 10

force btnU 0 0
force btnL 0 0
force btnR 0 0
force btnD 0 0
force sw0  0 0
force sw1  0 0
run 30 ns

force btnU 1 35
force btnL 0 35
force btnR 0 35
force btnD 0 35
force sw0  0 35
force sw1  0 35
run 30 ns

force btnU 0 65
force btnL 1 65
force btnR 0 65
force btnD 0 65
force sw0  0 65
force sw1  0 65
run 30 ns

force btnU 0 95
force btnL 0 95
force btnR 1 95
force btnD 0 95
force sw0  0 95
force sw1  0 95
run 30 ns

force btnU 0 125
force btnL 0 125
force btnR 0 125
force btnD 1 125
force sw0  0 125
force sw1  0 125
run 30 ns

force btnU 0 155
force btnL 0 155
force btnR 0 155
force btnD 0 155
force sw0  1 155
force sw1  0 155
run 30 ns

force btnU 0 185
force btnL 0 185
force btnR 0 185
force btnD 0 185
force sw0  0 185
force sw1  1 185
run 30 ns

force btnD 1 215
run 500 ns

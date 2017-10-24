module top(buttonU, buttonR, buttonL, buttonD, switch0, switch1, seg_anode, seg_cathodes, native_clk);
	input buttonU, buttonR, buttonL, buttonD, switch0, switch1, native_clk;
	output reg[3:0] seg_anode;
	output reg[6:0] seg_cathodes;
	
	wire [1:0] mode;
	wire [15:0] counter;
	wire [3:0] digit1, digit2, digit3, digit4;
	wire s_clk, f_clk;
	
	clk1kHz fast(native_clk, f_clk);
	clk1Hz  slow(native_clk, s_clk);
	
	controller main(s_clk, buttonU, buttonL, buttonR, buttonD, switch0, switch1, mode, counter);
	binToBCD convert(counter, digit1, digit2, digit3, digit4);
	
	seven_seg_display seg(s_clk, f_clk, mode, digit1, digit2, digit3, digit4, seg_anode, seg_cathodes);

endmodule
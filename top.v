module top(btnU btnR, btnL, btnD, sw0, sw1, anode, cathodes, native_clk);
	input btnD, btnL, btnR, btnU, sw0, sw1,
	output reg[3:0] anode;
	output reg[6:0] cathodes;
	
	wire mode;
	wire [15:0] counter;
	wire [3:0] digit1, digit2, digit3, digit4;
	wire s_clk, f_clk;
	
	clk1kHz fast(native_clk, f_clk);
	clk1Hz  slow(native_clk, s_clk);
	
	controller main(btnU btnR, btnL, btnD, sw0, sw1, mode, counter);
	binToBCD(counter, digit1, digit2, digit3, digit4);
	
	seven_seg_display(s_clk, f_clk, mode, digit1, digit2, digit3, digit4, anode, cathodes);

endmodule
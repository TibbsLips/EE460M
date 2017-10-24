module clk_top(native_clk, f_clk_LED, s_clk_LED);
	input native_clk;
	output wire f_clk_LED, s_clk_LED;
	
	clk1kHz f_clk(native_clk, f_clk_LED);
	clk1Hz  s_clk(native_clk, s_clk_LED);
	
endmodule
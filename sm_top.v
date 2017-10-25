module sm_top(states, up, left, right, down, switch0, switch1, native_clk, s_clk, m_clk_LED, s_clk_stable);
	input up, left, right, down, switch0, switch1, native_clk, s_clk;
	output [2:0] states;
	output m_clk_LED, s_clk_stable;
	
	wire btnUstable;        //make sure to debounce
	wire btnLstable;
	wire btnRstable;
	wire btnDstable;
	wire sw0;
	wire sw1;
	

	clk1kHz fast(native_clk, f_clk);
	debounce du(f_clk,up,btnUstable);
	debounce dl(f_clk,left,btnLstable);
	debounce dr(f_clk,right,btnRstable);
	debounce dd(f_clk,down,btnDstable);
	
	debounce sc(f_clk, s_clk, s_clk_stable);
	
	clk1Hz med(native_clk, m_clk_LED);
	
	
	state_machine sm(m_clk_LED, s_clk_stable, btnUstable, btnLstable, btnRstable, btnDstable, switch0, switch1, states);
	

endmodule
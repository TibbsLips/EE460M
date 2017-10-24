module clk1Hz(clk100Mhz, s_clk);
	input clk100Mhz; //fast clock
	output s_clk; //slow clock

	reg[14:0] counter;
	assign s_clk= counter[14];  //(2^7 / 128) = 1.34seconds

	initial begin
		counter = 0;
	end

	always @ (posedge clk100Mhz)
	begin
		counter <= counter + 1; //increment the counter every 10ns (1/100 Mhz) cycle.
	end

endmodule
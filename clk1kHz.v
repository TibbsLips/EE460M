
module clk1kHz(clk100Mhz, f_clk);
	input clk100Mhz; //fast clock
	output f_clk; //slow clock

	reg[17:0] counter;
	assign f_clk= counter[17];  //(2^7 / 128) = 1.34seconds

	initial begin
		counter = 0;
	end

	always @ (posedge clk100Mhz)
	begin
		counter <= counter + 1; //increment the counter every 10ns (1/100 Mhz) cycle.
	end

endmodule

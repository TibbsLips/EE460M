module clk1Hz(clk100Mhz, s_clk);
	input clk100Mhz; //fast clock
	output reg s_clk; //slow clock

	reg[27:0] counter;

	initial begin
		counter = 0;
	end

	always @ (posedge clk100Mhz)
	begin
		counter <= counter + 1; //increment the counter every 10ns (1/100 Mhz) cycle.
		if(counter < 50000000) begin
			s_clk <= 1'b1;
		end
		else if (counter >= 50000000 && counter < 100000000) begin
			s_clk <= 1'b0;
		end
		else begin
			counter <= 0;
		end
	end

endmodule
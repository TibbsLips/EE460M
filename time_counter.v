module time_counter(update, s_clk, to_add, current_time, sw0, sw1);
	input update;
	input [15:0] to_add;
	input s_clk;
	output reg [15:0] current_time;
	
	
	always @ (posedge update, posedge s_clk) begin
		current_time <= current_time + to_add;
		if(s_clk == 1) begin
			current_time <= current_time - 1;
		end
		if(current_time > 9999) begin
			current_time <= 9999;
		end
		else if (current_time == 0) begin
			current_time <= 0;
		end
		else begin
			current_time <= sw0*10 + sw1*205;
		end
	end

endmodule
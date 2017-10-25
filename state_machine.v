module state_machine(f_clk, s_clk, btnU, btnL, btnR, btnD, sw0, sw1, select);
	input btnU, btnL, btnR, btnD, sw0, sw1;
	input s_clk, f_clk;
	output wire [2:0] select;
	reg [3:0] state;
	reg [3:0] next_state;
	
	assign select = state[2:0];
	
	
	initial begin
		state = 0;
		next_state = 0;
	end
	
	always @ (posedge f_clk) begin
		case(state)
		4'b0000:begin
			if(s_clk == 1 & !(btnU || btnL || btnR || btnD || sw0 || sw1)) begin//only s_clk
				next_state <= 4'b0001;
			end
			else if(btnU == 1 & !(s_clk || btnL || btnR || btnD || sw0 || sw1)) begin//only up button
				next_state <= 4'b0010;
			end
			else if(btnL == 1 & !(btnU || s_clk || btnR || btnD || sw0 || sw1)) begin//only left button
				next_state <= 4'b0011;
			end
			else if(btnR == 1 & !(btnU || btnL || s_clk || btnD || sw0 || sw1)) begin//only right button
				next_state <= 4'b0100;
			end
			else if(btnD == 1 & !(btnU || btnL || btnR || s_clk || sw0 || sw1)) begin//only down button
				next_state <= 4'b0101;
			end
			else if(sw0 == 1  & !(btnU || btnL || btnR || btnD || s_clk || sw1)) begin//only switch 0
				next_state <= 4'b0110;
			end
			else if(sw1 == 1 & !(btnU || btnL || btnR || btnD || sw0 || s_clk)) begin//only switch 1
				next_state <= 4'b0111;
			end
			else begin
				next_state <= 4'b0000;
			end
		end
		4'b0001:begin
			next_state <= 4'b1000;
		end
		4'b0010:begin
			next_state <= 4'b1000;
		end
		4'b0011:begin
			next_state <= 4'b1000;
		end
		4'b0100:begin
			next_state <= 4'b1000;
		end
		4'b0101:begin
			next_state <= 4'b1000;
		end
		4'b0110:begin
			if(sw0 == 1) begin
				next_state <= 4'b0110;
			end 
			else begin
				next_state <= 4'b1000;
			end
		end
		4'b0111:begin
			if(sw1 == 1) begin
				next_state <= 4'b0111;
			end 
			else begin
				next_state <= 4'b1000;
			end
		end
		4'b1000:begin
			if(sw0 == 1 & !(btnU||btnL||btnR||btnD||s_clk)) begin
				next_state <= 4'b0110;
			end 
			else if(sw1 == 1 & !(btnU||btnL||btnR||btnD||s_clk)) begin
				next_state <= 4'b0111;
			end
			else if(btnU||btnL||btnR||btnD||s_clk) begin
				next_state <= 4'b1000;
			end
			else begin
				next_state <= 4'b0000;
			end
		end
		default: begin
			next_state <= 4'b1000;
		end
		endcase
	end
	
	always @(negedge f_clk) begin
		state <= next_state;
	end

endmodule
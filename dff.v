module DFF(d,clk,q,qn);
	input d;
	input clk;
	output reg q;
	output reg qn;

	always@(posedge clk)
	begin
	  q<=d;
	  qn<=~d;
	end
endmodule
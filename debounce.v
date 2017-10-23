module debounce(clk,in,out);
	input clk;
	input in;
	output out;

	wire q1;  //output from flip flop 1
	wire q1n; //qn output from flip flop 1
	wire q2;  //output from flip flop 2
	wire q2n; //qn output from flip flop 2

	DFF firstFlop(in,clk,q1,q1n);
	DFF secondFlop(q1,clk,q2,q2n);

	assign out = q2;

endmodule
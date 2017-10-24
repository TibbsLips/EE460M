module seven_seg_display(s_clk, f_clk, mode, seg1, seg2, seg3, seg4, anode, cathodes);
	input s_clk, f_clk;
	// s_clk at 1Hz
	// f_clk at 50MHz(TBC)
	input [1:0] mode;
	/*modes:
	* 0: off
	* 1: on
	* 2: 0.5 Hz
	* 3: 1 	 Hz
	*/
	input [3:0] seg1, seg2, seg3, seg4; //the numbers that should appear on each display
	
	output wire [3:0] anode; //array to activate each display
	output reg [6:0] cathodes; //arrays to display each number
	
	reg [1:0] sequence_count; //slow clock sequence counter used to blink
	
	reg seq_1Hz[3:0], seq_05Hz[3:0]; //slow clock sequence ROM
	reg anode_seq_output; //on-off-blink sequence output to be fed into AND-gate
	reg [3:0] anode_cycle_output; //display selector output to be fed into AND-gate
	reg [6:0] seg_ROM[3:0];
	
	initial begin
		sequence_count = 2'b00;
		anode_seq_output = 1'b0;
		anode_cycle_output = 4'b0000;
		// 1Hz sequence ROM
		seq_1Hz[0] = 1'b1;
		seq_1Hz[1] = 1'b0;
		seq_1Hz[2] = 1'b1;
		seq_1Hz[3] = 1'b0;
		// 0.5Hz sequence ROM
		seq_05Hz[0] = 1'b1;
		seq_05Hz[1] = 1'b1;
		seq_05Hz[2] = 1'b0;
		seq_05Hz[3] = 1'b0;
		// segment ROM
		seg_ROM[0] = 7'b0000001;
		seg_ROM[1] = 7'b1001111;
		seg_ROM[2] = 7'b0010010;
		seg_ROM[3] = 7'b0000110;
		seg_ROM[4] = 7'b1001100;
		seg_ROM[5] = 7'b0100100;
		seg_ROM[6] = 7'b0100000;
		seg_ROM[7] = 7'b0001111;
		seg_ROM[8] = 7'b0000000;
		seg_ROM[9] = 7'b0001100;
		seg_ROM[10] = 7'b0000000;
		seg_ROM[11] = 7'b0000000;
		seg_ROM[12] = 7'b0000000;
		seg_ROM[13] = 7'b0000000;
		seg_ROM[14] = 7'b0000000;
		seg_ROM[15] = 7'b0000000;
	end
	
	always @ (posedge s_clk) begin
		sequence_count <= sequence_count + 1; //increment sequence (FF array)
	end
	
	always @ (sequence_count, mode) begin
		case(mode)//triggers mux and outputs to AND-gate
			2'b00: begin
				anode_seq_output <= 1'b0;
			end
			2'b01: begin
				anode_seq_output <= 1'b1;
			end
			2'b10: begin
				anode_seq_output <= seq_05Hz[sequence_count];
			end
			2'b11: begin
				anode_seq_output <= seq_1Hz[sequence_count];
			end
		endcase
	end
	
	always @ (posedge f_clk) begin
		// display select
		anode_cycle_output <= anode_cycle_output << 1;
		anode_cycle_output[0] <= anode_cycle_output[3];
		// display number
		case(anode_cycle_output)
		4'b0001: begin
			cathodes <= seg_ROM[seg1];
		end
		4'b0010: begin
			cathodes <= seg_ROM[seg2];
		end
		4'b0100: begin
			cathodes <= seg_ROM[seg3];
		end
		4'b1000: begin
			cathodes <= seg_ROM[seg4];
		end
		default: begin 
			cathodes <= 7'b0000000;
		end		
		endcase
	end
	
	assign anode[0] = anode_seq_output && anode_cycle_output[0];
	assign anode[1] = anode_seq_output && anode_cycle_output[1];
	assign anode[2] = anode_seq_output && anode_cycle_output[2];
	assign anode[3] = anode_seq_output && anode_cycle_output[3];

endmodule
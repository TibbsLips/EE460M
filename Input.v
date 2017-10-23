module inputs(clk,btnU,btnL,btnR,btnD,sw0,sw1,mode,times);
	input clk;
	input btnU;            //add 50
	input btnL;            //add 150
	input btnR;            //add 200
	input btnD;            //add 500
	input sw0;             //reset to 10s
	input sw1;             //reset to 205s

	output reg mode;     //will send final LED status from
	output reg [15:0]times;  //will have the time to display on led
	
	reg [15:0] next_time;


	wire btnUstable;        //make sure to debounce
	wire btnLstable;
	wire btnRstable;
	wire btnDstable;
	wire sw0;
	wire sw1;

	debounce up(clk,btnU,btnUstable);
	debounce left(clk,btnL,btnLstable);
	debounce right(clk,btnR,btnRstable);
	debounce down(clk,btnD,btnDstable);


	initial begin
		next_time = 0;
		times=0;
		mode=0;
	end

	always @ (btnDstable, btnLstable, btnRstable, btnDstable, sw0, sw1) begin
		if(btnUstable==1) begin
			next_time = times+50;
		end

		if(btnLstable==1) begin
			next_time = times+150;
		end

		if(btnRstable==1) begin
			next_time = times+200;
		end
		
		if(btnDstable==1) begin
			next_time = times+500;
		end
		
		if(next_time>=9999) begin
			next_time = 9999;
		end

		if(sw0 == 1) begin
			next_time = 10;
		end

		if(sw1 == 1) begin
			next_time = 205;
		end
		
		times <= next_time;
	
	end
	
	always@(posedge clk) begin
		if(times == 0) begin
			next_times = 0;
		else begin
			next_times = times - 1;
		end
		times <= next_time;
	end
	
	always @ (times) begin
		if(times == 0) begin
			mode = 2'b10;
		end
		else if((times<=200)&&(times>0)) begin
			mode=2'b11; //blink at 1Hz
		end

		else if(times>200) begin
			mode=2'b01; //LED's on
		end
		else begin //should never happen
			mode=2'b00;
		end
	end
	
endmodule

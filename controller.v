module controller(f_clk, s_clk,btnU,btnL,btnR,btnD,sw0,sw1,mode,times);
	input s_clk;
	input f_clk;
	input btnU;            //add 50
	input btnL;            //add 150
	input btnR;            //add 200
	input btnD;            //add 500
	input sw0;             //reset to 10s
	input sw1;             //reset to 205s

	output reg [1:0] mode;     //will send final LED status from
	output reg [15:0]times;  //will have the time to display on led
	
	reg [15:0] to_add;


	wire btnUstable;        //make sure to debounce
	wire btnLstable;
	wire btnRstable;
	wire btnDstable;
	wire sw0;
	wire sw1;

	debounce up(f_clk,btnU,btnUstable);
	debounce left(f_clk,btnL,btnLstable);
	debounce right(f_clk,btnR,btnRstable);
	debounce down(f_clk,btnD,btnDstable);


	initial begin
		to_add = 0;
		times=0;
		mode=0;
	end
	

    
	always @ (posedge btnDstable, posedge btnLstable, posedge btnRstable, posedge btnUstable, posedge sw0, posedge sw1, posedge s_clk) begin
		if(btnUstable==1) begin
			times = times+50;
		end
        else if(btnLstable==1) begin
			times = times+150;
		end

		else if(btnRstable==1) begin
			times = times+200;
		end
		
		else if(btnDstable==1) begin
			times = times+500;
		end
		
		else if(times>=9999) begin
			times = 9999;
		end

		else if(sw0 == 1) begin
			times = 10;
		end

		else if(sw1 == 1) begin
			times = 205;
		end
		
		else if(times == 0) begin
            times = times;
        end
        
        else if (s_clk == 1)begin
            times = times - 1;
        end
        else begin
            times = times;
        end
	
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

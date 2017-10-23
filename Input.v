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
		times=0;
		mode=0;
	end

	always@(posedge clk) begin

	if(btnUstable==1) begin
		if(times+50<=9999)	begin
			times=times+50;
		end
		else begin
			times=9999;
		end
	end

	else if(btnLstable==1)
	begin
	  if(times+150<=9999)
		begin
		  times=times+150;
		end
	  else
		begin
		  times=9999;
		end
	end

	else if(btnRstable==1)
	begin
	  if(times+200<=9999)
		begin
		 times=times+200;
		end
	  else
		begin
		  times=9999;
		end
	end

	else if(btnDstable==1)
	begin
	  if(times+500<=9999)
		begin
		  times=times+500;
		end
	  else
		begin
		  times=9999;
		end
	end

	else if(sw0==1)
	begin
	  times=10;
	end

	else if(sw1==1)
	begin
	  times=205;
	end

	else
	  begin
		times=times;
	  end
	//////////////////////////////////////////////
	////we need to send numbers with BCD to 7-seg
	//////////////////////////////////////////////
	/////end of time update, time to decrement and flash

	if(times==0)
	begin
	  mode=2; //blink at 0.5 Hz
	  times=0;
	end

	else if((times<=200)&&(times>0))
	begin
	  mode=3; //blink at 1Hz
	  if(times%2==1)
		begin
		  times=times-1;
		end
	  else
		begin
		  times=times-2; //This will let the display skip odd numbers
		end
	end

	else if(times>200)
	begin
	  mode=1; //LED's on
	  times=times-1;
	end

	else
	begin
		mode=0;
		times=times;
	end
	end
endmodule

module decToBCD(timer,digit1,digit2,digit3,digit4);
	input [15:0]timer;
	output reg [3:0]digit1;
	output reg [3:0]digit2;
	output reg [3:0]digit3;
	output reg [3:0]digit4;


	////value rolls over when 10-> 10= 1010->goes up to 1001
	always@(timer)
	begin
		digit4=0; //thousands place
		digit3=0; //hundreds place
		digit2=0; //tens place
		digit1=0; //ones place
	end

	for(i=15; i>=0; i=i-1)	begin
		if(digit4 >=5)
			digit4=digit4+3;
		else
			digit4=digit4;

		if(digit3>=5)
			digit3=digit3+3;
		else
			digit3=digit3;

		if(digit2>=5)
			digit2=digit2+3;
		else
			digit2=digit2;

		if(digit1>=5)
			digit1=digit1+3;
		else
			digit1=digit1;

			digit4={digit4[2:0], digit3[3]};
			digit3={digit3[2:0], digit2[3]};
			digit2={digit2[2:0], digit1[3]};
			digit1={digit1[2:0], timer[i]};
		end

endmodule

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
	
	wire [2:0] select;

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

    state_machine sm(f_clk, s_clk, btnUstable, btnLstable, btnRstable, btnDstable, sw0, sw1, select);

	initial begin
		times=0;
		mode=0;
	end
	

    always @ (posedge f_clk) begin
        case(select) 
        0:  begin
                times <= times;
            end
        1:  begin
                if(times == 0) begin
                    times = 0;
                end
                else begin
                    times <= times - 1;  
                end
            end
        2:  begin
                times <= (times + 50) - ((times + 50)/9999)*((times + 50)%9999);
            end
        3:  begin
                times <= (times + 150) - ((times + 150)/9999)*((times + 150)%9999);
            end
        4:  begin
                times <= (times + 200) - ((times + 200)/9999)*((times + 200)%9999);
            end
        5:  begin
                times <= (times + 500) - ((times + 500)/9999)*((times + 500)%9999);
            end
        6:  begin
                times <= 10;
            end
        7:  begin
                times <= 205;
            end
        endcase
    end
	
	always @ (*) begin
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

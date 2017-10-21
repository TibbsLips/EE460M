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



module debounce(clk,in,out);
  input clk;
  input in;
  output out;

  wire q1;  //output from flip flop 1
  wire q1n; //qn output from flip flop 1
  wire q2;  //output from flip flop 2
  wire q2n; //qn output from flip flop 2

  DFF firstFlop(in,clk,q1,q1n);
  DFF secondFlop(out1,clk,q2,q2n);

  assign out= out2;

endmodule


module input(clk,btnU,btnL,btnR,btnD,sw0,sw1,mode,time);
  input btnU;            //add 50
  input btnL;            //add 150
  input btnR;            //add 200
  input btnD;            //add 500
  input sw0;             //reset to 10s
  input sw1;             //reset to 205s

  output reg mode;     //will send final LED status from
  output reg [13:0]time;  //will have the time to display on led


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

  //need states for flashing lights
  //state 0: flashing 0's
  //state 1: flashing because less than 200seconds
  //state 2: flashing because
  //state 3: solid number

  initial
    begin
      state=0; //state0 means no time, flashing
      time=0;
      mode=0;
    end

always@(posedge clk)
  begin

  if(btnUstable==1)
    begin
      if(time+50<=9999)
        begin
          time=time+50;
        end
      else
        begin
          time=9999;
        end
    end

  else if(btnLstable==1)
    begin
      if(time+150<=9999)
        begin
          time=time+150;
        end
      else
        begin
          time=9999;
        end
    end

  else if(btnRstable==1)
    begin
      if(time+200<=9999)
        begin
         time=time+200;
        end
      else
        begin
          time=9999;
        end
    end

  else if(btnDstable==1)
    begin
      if(time+500<=9999)
        begin
          time=time+500;
        end
      else
        begin
          time=9999;
        end
    end

  else if(sw0==1)
    begin
      time=10;
    end

  else if(sw1=1)
    begin
      time=205;
    end

  else
      begin
        time=time;
      end
  //////////////////////////////////////////////
  ////we need to send numbers with BCD to 7-seg
  //////////////////////////////////////////////
  /////end of time update, time to decrement and flash

  if(time==0)
    begin
      mode=2; //blink at 0.5 Hz
      time=0;
    end

  else if((time<=200)&&(time>0))
    begin
      mode=3; //blink at 1Hz
      if(time%2==1)
        begin
          time=time-1;
        end
      else
        begin
          time=time-2; //This will let the display skip odd numbers
        end
    end

  else if(time>200)
    begin
      mode=1; //LED's on
      time=time-1;
    end

  else
    begin
        mode=0;
        time=time;
    end
end
endmodule

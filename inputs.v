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
  DFF secondFlop(q1,clk,q2,q2n);

  assign out= q2;

endmodule


module inputs(f_clk,clk,btnU,btnL,btnR,btnD,sw0,sw1,mode,times);
  input clk;
  input f_clk;
  input btnU;            //add 50
  input btnL;            //add 150
  input btnR;            //add 200
  input btnD;            //add 500
  input sw0;             //reset to 10s
  input sw1;             //reset to 205s

  output reg [1:0]mode;     //will send final LED status from
  output reg [15:0]times;  //will have the time to display on led


  wire btnUstable;        //make sure to debounce
  wire btnLstable;
  wire btnRstable;
  wire btnDstable;
  wire sw0;
  wire sw1;
  reg flag;
  debounce up(clk,btnU,btnUstable);
  debounce left(clk,btnL,btnLstable);
  debounce right(clk,btnR,btnRstable);
  debounce down(clk,btnD,btnDstable);


  initial
    begin
      times=0;
      mode=0;
      flag=0;
    end

always@(posedge clk)// btnUstable,posedge btnLstable,posedge btnRstable,posedge btnDstable, posedge s_clk)//,sw0,sw1)// posedge s_clk)//,posedge clk) didnt have switches, used posedge
  begin
if(flag==0)
    begin
  if(btnUstable==1)
    begin
     flag=1;
      if(times+50<=9999)
        begin
          times=times+50;
        end
      else
        begin
          times=9999;
        end
    end

   else if(btnLstable==1)
    begin
       flag=1;
      if(times+150<=9999)
        begin
          times=times+150;
        end
      else
        begin
          times=9999;
        end
    end

   else if(btnRstable==1)// these were else
    begin
    flag=1;
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
    flag=1;
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
    flag=1;
      times=10;
    end

   else if(sw1==1)
    begin
    flag=1;
      times=205;
    end

  else
      begin //could write a loop here to cycle through time to decrement so we can use the fastclock in sensitivity
      if((~btnUstable)&&(~btnDstable)&&(~btnLstable)&&(~btnRstable))
        begin
            flag=0;
        if(times!=0)
            times=times-1;
           end
         end
   end 
   
 // end

  else begin
  flag=0;
  times=times;
  end 
  end
//  end

//else 
//    begin
//    flag=0;
//    times=times;
//    end
// end  
  //endmodule   
  //////////////////////////////////////////////
  ////we need to send numbers with BCD to 7-seg
  //////////////////////////////////////////////
  /////end of time update, time to decrement and flash
always@(posedge times, posedge clk)
begin
  if(times==0)
    begin
      mode=2; //blink at 0.5 Hz
  //    times=0;
    end

  else if((times<=200)&&(times>0))
    begin
      mode=3; //blink at 1Hz
 //     if(times%2==1)
  //      begin
  //        times=times;
  //      end
 //     else
 //       begin
  //        times=times; //This will let the display skip odd numbers
  //      end
    end

  else if(times>200)
    begin
      mode=1; //LED's on
//      times=times;
//    end

//  else
//    begin
//        mode=0;
//        times=times;
 //   end
end
end
endmodule

module binToBCD(timer,digit1,digit2,digit3,digit4);
input [15:0]timer;
output reg [3:0]digit1;
output reg [3:0]digit2;
output reg [3:0]digit3;
output reg [3:0]digit4;

integer i;


  ////value rolls over when 10-> 10= 1010->goes up to 1001
  always@(timer)
    begin
      digit4=0; //thousands place
      digit3=0; //hundreds place
      digit2=0; //tens place
      digit1=0; //ones place
  

    for(i = 15; i >= 0; i = i-1)
      begin
        if(digit4 >= 5)
          digit4 = digit4+3;
        else
          digit4 = digit4;

        if(digit3 >= 5)
          digit3 = digit3+3;
        else
          digit3 = digit3;

        if(digit2 >= 5)
          digit2 = digit2+3;
        else
          digit2 = digit2;

        if(digit1 >= 5) //was 5 for all of them originally
          digit1 = digit1+3;
        else
          digit1 = digit1;

        digit4={digit4[2:0], digit3[3]};
        digit3={digit3[2:0], digit2[3]};
        digit2={digit2[2:0], digit1[3]};
        digit1={digit1[2:0], timer[i]};
      end
 end
endmodule

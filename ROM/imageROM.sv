module imageROM(
input logic kdata,kclock,

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// VGA In-Out
input logic clk,
input logic rst,
output logic hsync,
output logic vsync,
output logic[3:0] red,
output logic[3:0] green,
output logic[3:0] blue,
output logic[7:0] key,
output logic[3:0] ledg
// Buttons-Switch Inputs

);
///////////////////////////////////////////////////////////////////////////////
///PS2 CODE WORNiNG////
logic keyboardclock ;
logic[2:0] flipflop;
logic[2:0] data;
logic fallingedge_clock , risingedge_clock;
logic[3:0] count;
logic start,stop;
//logic[7:0] key;
logic[3:0] ones_count;
logic parity_error;
logic pressed;

logic key_right;
logic key_left;
logic sw_select;
logic previous_right;
logic previous_left;
logic pixel_clock;
logic x,y;
logic[9:0]line_counter;
logic[9:0]px_clk_counter;
logic[9:0]orio1;
logic[9:0]orio2;
logic imagestartx;
logic imagestarty;
logic[5:0]  romaddr;
logic[63:0]  romdata;
assign romaddr=0;
logic[5:0] i;
assign i=6'b000000;
rom romrom (
  .address(romaddr), // input
  .data  ( romdata )  // output [9:0]
);

assign imagestartx=159;
assign imagestarty=119;


/*always_ff@(posedge clk , posedge rst)
begin 
   if (rst)
		begin
			flipflop[0]<=1'b1;
			flipflop[1]<=1'b1;
			flipflop[2]<=1'b1;
			fallingedge_clock<=flipflop[2]&(~flipflop[1]);
			risingedge_clock<=~flipflop[2]&flipflop[1];
		end
	else
		begin
			flipflop[0]<=kclock;
			flipflop[1]<=flipflop[0];
			flipflop[2]<=flipflop[1];
			fallingedge_clock<=flipflop[2]&(~flipflop[1]);
			risingedge_clock<=~flipflop[2]&flipflop[1];
		end
end

always_ff@(posedge clk , posedge rst)
begin 
	if (rst)
		begin
			data[0]<=1'b1;
			data[1]<=1'b1;
			data[2]<=1'b1;
		end
	else
		begin
			data[0]<=kdata;
			data[1]<=data[0];
			data[2]<=data[1];	
		end
end

logic[3:0] pos;
//logic[3:0] count;

always_ff @(posedge clk, posedge rst) begin
	if(rst) begin
		pos <= '0;
		count <= '0;
	end else begin
		if (fallingedge_clock) begin
			count<=count+1;
			if (count==10) begin 
				count <= 0;
				pos   <= 0;
			end else if (count) begin
				pos <= pos+1;
				key[pos] <= data[2];
			end
		end
	end
end

assign got_it = (count==10);
assign key_right = (key=='h2D);
assign key_left  = (key=='h4B);
assign sw_select = (key=='h1B);
assign ledg[0] = key_right;
assign ledg[1] = key_left;
assign ledg[2] = sw_select;
assign ledg[3] = 1;*/

///////////////////////////////////////////////////////////////////////////////\

//x=lines y=pixels
always_ff@(posedge clk, posedge rst)
begin
	if(rst)
		pixel_clock<=0;
	else 
		pixel_clock<=~pixel_clock;
end

always_ff@(posedge clk, posedge rst)
begin 
   if (rst)
      hsync<=1;
      else if(pixel_clock)begin
        if (px_clk_counter>(640+16-1) && px_clk_counter<(640+16+96)) begin
          hsync<=0;
         end 
         else
         hsync<=1;
         
          end
          
         
end


always_ff@(posedge clk, posedge rst)
begin 
  if(rst)
  begin
      red <= 4'b0000;
      blue<= 4'b0000;
      green<= 4'b0000;
  end
  else if (px_clk_counter>640 && pixel_clock)
      begin
        red <= 4'b0000;
        blue<= 4'b0000;
        green<= 4'b0000;
      end
  else if (px_clk_counter<640 && pixel_clock && line_counter<480)
   begin
     
       if (line_counter>imagestartx && line_counter<imagestartx+47 && px_clk_counter>imagestarty && px_clk_counter<imagestarty+63 && px_clk_counter<580 && px_clk_counter>0 && line_counter>0) 
       begin
		  if(i==63)
		  begin 
			i<=0;
			romaddr<=romaddr+1;
			end
		  if(data[i])
			red <= 4'b1110;
		  else
			red <= 4'b0000;
		  blue<= 4'b0000;
		  green<= 4'b0000;
       end
       
       else if (line_counter>359 && line_counter<459 && px_clk_counter>119 && px_clk_counter<7*32+119+orio2&& px_clk_counter<580 ) 
       begin
          blue <= 4'b1110;
          red<= 4'b0000;
          green<= 4'b0000;
       end
       else
          begin   
             red<= 4'b1111;
             green<= 4'b1111;
             blue<= 4'b1111;
          end  
   end
end        

always_ff@(posedge clk, posedge rst)
begin
   if(rst)
	vsync<=1;
  else if(pixel_clock)
    if (line_counter>(480+11-1) && line_counter<(480+11+2))
	 vsync<=0;
   else
   vsync<=1;
end

always_ff@(posedge clk, posedge rst)
begin
	if(rst)
		px_clk_counter<=0;
    else if(pixel_clock)
      begin
      if(px_clk_counter<800)
        px_clk_counter<=px_clk_counter+1;
      else 
          begin
          px_clk_counter<=0;
          if(line_counter<524)
            line_counter<=line_counter+1;
          else
            line_counter<=0;
          end
      end
end
endmodule
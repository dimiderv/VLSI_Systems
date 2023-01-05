 module VGA(
input logic clk,
input logic rst,
input logic[63:0] readata,
output logic[6:0] readaddress,
output logic hsync,
output logic vsync,
output logic[3:0] red,
output logic[3:0] green,
output logic[3:0] blue,
input logic [2:0] rgb
);

logic pixel_clock;
logic[9:0]line_counter;
logic[9:0]px_clk_counter;
logic[9:0] startingx , startingy;
logic[6:0] dataindex;

assign dataindex = px_clk_counter - startingy;
assign readaddress = line_counter - startingx;
assign startingx = 250;
assign startingy = 250;


always_ff@(posedge clk, posedge rst)
begin
        if(rst)
                pixel_clock<=0;
        else
                pixel_clock<=~pixel_clock;
end

////// dhmiourgia tou px_clk_counter kai tou line_counter
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

/// hsync - vsync

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
		vsync<=1;
   else if(pixel_clock)
		if (line_counter>(480+11-1) && line_counter<(480+11+2))
         vsync<=0;
		else
			vsync<=1;
end

// end



/// xrwmatismos othonhs

always_ff@(posedge clk, posedge rst)
begin
  if(rst) begin
      red <= 4'b0000;
      blue<= 4'b0000;
      green<= 4'b0000;
  end  
  else if (px_clk_counter >640 && pixel_clock) begin
	  red = 4'b0000;
     blue = 4'b0000;
     green = 4'b0000;
  end  
  else if (px_clk_counter<640 && pixel_clock && line_counter<480) begin
      if (line_counter>=startingx && line_counter<startingx+48 && px_clk_counter>=startingy &&   px_clk_counter<startingy+64 ) begin
			if (readata[dataindex]) begin
			if(rgb[0])
				red <= 4'b1111;
			else
				red <= 4'b0000;

			if(rgb[2])
          blue<= 4'b1111;
			 else
				blue <= 4'b0000;
			if(rgb[1])
          green<= 4'b1111;
			 else
				green <= 4'b0000;
			end
			else begin
			  red<= 4'b0000;
			  blue<= 4'b0000;
			  green<= 4'b0000;
			end
      end
      else begin   
          red<= 4'b0000;
          green<= 4'b0000;
          blue<= 4'b0000;
      end 
   end
end       




endmodule
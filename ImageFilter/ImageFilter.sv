module ImageFilter(
input logic clk,
input logic rst,
input logic [63:0] romdata,      // data from rom
output logic [6:0] romaddress,   // address of rom to read
output logic [63:0] ramdata,     // data to write in ram
output logic [6:0] ramaddress,   // address to write in ram
output logic write_enable,       // enable writing to ram
output logic read_request,      // request to read from rom
input logic kernelcross,
input logic erosion
);

logic [0:65]line_buffer2;
logic [0:65]line_buffer1;
logic [0:65]line_buffer0;

always_comb
begin
	line_buffer2[0]=0;
	line_buffer2[65]=0;
	for (int i=1;i<64;i++)
		line_buffer2[i]=romdata[i];
end

always_ff@(posedge clk)
begin
		/* if (rst)
			begin
				line_buffer1<=0;
				line_buffer0<=0;
			end 
		else */
			begin
				line_buffer1<=line_buffer2;
				line_buffer0<=line_buffer1;
			end
end



//erosion
//ramdata(1,1) = pixel(1,0) & pixel(0,1) & pixel (1,1) & pixel (1,2) & pixel (2,1);

//erosion
always_comb 
begin
for(int i=0;i<64;i++)
						ramdata[i] = (line_buffer0[i+1] & line_buffer1[i] & line_buffer1[i+1] & line_buffer1[i+2] & line_buffer2[i+1]);
	/* if (erosion)
		begin
			if (kernelcross)
				begin
					for(int i=0;i<64;i++)
						ramdata[i] = (line_buffer0[i+1] & line_buffer1[i] & line_buffer1[i+1] & line_buffer1[i+2] & line_buffer2[i+1]);
				end
			else 
				begin
					for(int i=0;i<64;i++)
						ramdata[i] = (line_buffer0[i+1] & line_buffer1[i] & line_buffer1[i+2] & line_buffer2[i+1]);
				end
		 end
else
//dilation
//ramdata(1,1) = pixel(1,0) | pixel(0,1) | pixel (1,1) | pixel (1,2) | pixel (2,1);
		begin
			if (kernelcross)
				begin
					for(int i=0;i<64;i++)
						ramdata[i] = (line_buffer0[i+1] | line_buffer1[i] | line_buffer1[i+1] | line_buffer1[i+2] | line_buffer2[i+1]);
				end
			else
				begin
					for(int i=0;i<64;i++)
						ramdata[i] = (line_buffer0[i+1] | line_buffer1[i] | line_buffer1[i+2] | line_buffer2[i+1]);
				end
		end */
end
	


// odhgos dieuthnhshs kai read_request
always_ff@(posedge clk)
begin
	if (rst) begin
		romaddress<=0;
		//read_request<=1;
	end
	else if(romaddress<48) begin
		romaddress<=romaddress+1;
		//read_request<=1;
	end
	//else read_request<=0;
end


//odhgos write_enable
always_ff@(posedge clk)
begin
	if (rst) begin
		write_enable<=0;
	end
	else if (romaddress < 48) write_enable<=1; // an einai diaforo tou defeault  , an den leitourgei etsi tote tha eleksw an to romadress einai apo 0 mexri 48
	else write_enable<=0;
end

// h tha valw to write_enable na to elegxei edw h meta sto top level
		
assign ramaddress = romaddress; // mporei na thelei na ginei me flipflop annti gia assign wste na krataei thn swsth timh ths romadress

endmodule


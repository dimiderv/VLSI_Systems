module edgedetector(
input logic clk,
input logic rst,
input logic [63:0] romdata,      // data from rom
input logic switch1,
output logic [6:0] romaddress,  // address of rom to read
output logic [63:0] ramdata,     // data to write in ram
output logic [6:0] ramaddress,   // address to write in ram
output logic write_enable,       // enable writing to ram
output logic read_request       // request to read from rom

);
logic[65:0] line0;
logic[65:0] line1;
logic[65:0] line2;
logic[65:0] line;

always_ff@(posedge clk)
begin
if (rst)
 begin
   line0<=66'b000000000000000000000000000000000000000000000000000000000000000000;
   line1<=66'b000000000000000000000000000000000000000000000000000000000000000000;
   line2<=romdata;
	
 end 
else 
 begin

 
   line0<=line1;
   line1<=line2;
	line2<=romdata;
 end
end


always_comb 
begin

if(switch1 && romaddress>1)
 begin
  //for (int j=0;j<64;j++)
  ramdata[j]=line0[j+1]&line1[j]&line1[j+1]&line1[j+2]&line2[j+1];
 end
else if(romaddress>1) 
 begin
  //for (int j=0;j<64;j++)
   ramdata[j]=line0[j+1]|line1[j]|line1[j+1]|line1[j+2]|line2[j+1];
 end
end



    
/*// euresh akmwn
always_comb
begin 
	for(int j=1;j<64;j++) 
		ramdata[j] = romdata[j-1] ^ romdata[j];
end
assign ramdata[0] = romdata[0] ;*/

// odhgos dieuthnhshs kai read_request

always_ff@(posedge clk)
begin
	if (rst) begin
		romaddress<=64;
		read_request<=0;
	end
	else if (romaddress==64) begin
			romaddress<=0;
			read_request<=1;
	end
	else if(romaddress<48) begin
		romaddress<=romaddress+1;
		read_request<=1;
	end
	else read_request<=0;
end

//odhgos write_enable

always_ff@(posedge clk)
begin
	if (rst) begin
		write_enable<=0;
		
	end
	else if (romaddress < 48) write_enable<=1; // an einai diaforo tou defeault  , an den leitourgei etsei tote tha eleksw an to romadress einai apo 0 mexri 48
	else write_enable<=0;
end

// h tha valw to write_enable na to elegxei edw h meta sto top level
		
assign ramaddress = romaddress; // mporei na thelei na ginei me flipflop annti gia assign wste na krataei thn swsth timh ths romadress

endmodule
	
				

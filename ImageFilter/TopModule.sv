module VGA_EDGES(
input logic clk,
input logic rst,
input logic switch,
output logic[6:0] romaddresss,
output logic[6:0] ramreadaddressfromvga,
output logic[63:0] ramdataoutout,
output logic[63:0] readataout,
output logic[6:0] ramwriteaddressout,
output logic hsync,
output logic vsync,
output logic[3:0] red,
output logic[3:0] green,
output logic[3:0] blue,
input logic[2:0] rgb,
input logic kernelcross,
input logic erosion
);


logic[63:0] readata;
logic[6:0] readaddress;
// einai ths fpga kanonika

// rom variables
logic[63:0] romdata;
logic[6:0] romaddressone;
logic[6:0] romaddress; 
logic[6:0] vgaaddress; 

logic r_rqst;


// ram variables
logic[63:0] ramdataout;
logic w_en;
logic[6:0] ramwriteaddress;
logic[63:0] raminputdata;


assign readataout= readata;
assign ramdataoutout = ramdataout;
assign ramwriteaddressout = ramwriteaddress;
assign romaddresss= romaddress;


ROM rom(romaddress,romdata);
//EdgeDetector edgedetector(clk, rst, romdata, romaddressone, raminputdata, ramwriteaddress, w_en, r_rqst);
RAM ram(clk, vgaaddress, ramdataout, w_en, ramwriteaddress, raminputdata);
VGA vga(clk, rst, readata, vgaaddress, hsync, vsync, red, green, blue, rgb);
ImageFilter imgfltr(clk, rst, romdata, romaddressone, raminputdata, ramwriteaddress, w_en, r_rqst, kernelcross, erosion);

always_comb
begin
	if (switch) readata= ramdataout;
	else readata = romdata;
end


always_comb
begin
	if(r_rqst) romaddress = romaddressone;
	else romaddress = vgaaddress;
end


endmodule
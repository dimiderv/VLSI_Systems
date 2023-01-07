module dilation_erosion(
input logic clk,
input logic rst,
input logic switch,
input logic switch1,
input logic switch2,
//input logic[6:0] ramreadaddress,

//output logic[9:0] line__counter,pxclock_counter,
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
output logic[63:0] romdatadata);


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
assign romdatadata = romdata;

assign ramwriteaddressout = ramwriteaddress;

assign romaddresss= romaddress;


rom myrom(
romaddress,
romdata
);

dilation_erosion_filter myedgedetector(
clk,
rst,
romdata,
switch,
switch1,
switch2,
romaddressone,
raminputdata,
ramwriteaddress,
w_en,
r_rqst

);

ram myram(
clk,
vgaaddress,
ramdataout,
w_en,
ramwriteaddress,
raminputdata

);

vga myvga(
clk,
rst,
readata,
vgaaddress,
hsync,
vsync,
red,
green,
blue
);




always_comb
begin
	if (switch) readata= ramdataout;
	else readata = romdata;
end


always_comb
begin
	if(r_rqst && switch) romaddress = romaddressone;
	else romaddress = vgaaddress;
end


endmodule
module  triliza (  
 input logic [4:0] xx,
 input logic [4:0] oo,
 output logic error,
 output logic full,
 output logic winX,
 output logic winO,
 output logic noWin
 );
 logic a,b,c,d,e,f,g,h,i,j,k,l,m,n,p,q,aa,bb,cc,dd,ee,ff,gg,hh,ii,qq,ww,rr,yy,tt,uu,pp,zz,vv;
logic x[8:0];
logic o[8:0];
 //winX
 always_comb
  begin
  x[4]=1'b1;
  x[6]=1'b1;
  x[5]=1'b0;
  x[8]=1'b0;
  o[4]=1'b0;
  o[6]=1'b0;
  o[5]=1'b1;
  o[8]=1'b1;
  x[0]=xx[0];
  x[1]=xx[1];
  x[2]=xx[2];
  x[3]=xx[3];
  x[7]=xx[4];
  o[0]=oo[0];
  o[1]=oo[1];
  o[2]=oo[2];
  o[3]=oo[3];
  o[7]=oo[4];
   a=x[0] & x[1] & x[2];
   b=x[3] & x[4] & x[5];
   c=x[6] & x[7] & x[8];
   d=x[0] & x[3] & x[6];
   e=x[1] & x[4] & x[7];
   f=x[2] & x[5] & x[8];
   g=x[0] & x[4] & x[8];
   h=x[2] & x[4] & x[6];
   if (  ((a | b) | (c | d)) | ((e | f) | (g | h)) & ~error )
    winX = 1'b1;
	 else 
	 winX= 1'b0;
 end

//winO
 always_comb
  begin
   i=o[0] & o[1] & o[2];
   j=o[3] & o[4] & o[5];
   k=o[6] & o[7] & o[8];
   l=o[0] & o[3] & o[6];
   m=o[1] & o[4] & o[7];
   n=o[2] & o[5] & o[8];
   p=o[0] & o[4] & o[8];
   q=o[2] & o[4] & o[6];
   if (  ((i | j) | (k | l)) |  ((m | n) | (p | q)) & ~error)
    winO=1'b1;
	 else
	 winO=1'b0;
 end

//NOWin
 always_comb
  begin
   if (~winX & ~winO & ~error)
    noWin=1'b1;
	 else
	 noWin=1'b0;
  end

//error
 always_comb
  begin
   aa=x[0] & o[0] ;
   bb=x[1] & o[1] ;
   cc=x[2] & o[2] ;
   dd=x[3] & o[3] ;
   ee=x[4] & o[4] ;
   ff=x[5] & o[5] ;
   gg=x[6] & o[6] ;
   hh=x[7] & o[7] ;
   ii=x[8] & o[8] ;
   if( (aa|bb|cc) | (dd|ee|ff) | (gg|hh|ii))
    error=1'b1;
	 else
	 error=1'b0;
 end

//full
always_comb
  begin
   qq=x[0] | o[0] ;
   ww=x[1] | o[1] ;
   rr=x[2] | o[2] ;
   tt=x[3] | o[3] ;
   yy=x[4] | o[4] ;
   uu=x[5] | o[5] ;
   pp=x[6] | o[6] ;
   zz=x[7] | o[7] ;
   vv=x[8] | o[8] ;
   if( (qq&ww&rr) & (tt&yy&uu) & (pp&zz&vv))
    full=1'b1;
	 else
	 full=1'b0;
 end

endmodule
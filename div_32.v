module div_32(input [31:0] dividend, divisor, output reg [31:0] remainder, quotient);
reg [31:0] r, q, m, temp;
reg divend_sign, divis_sign;
integer i;
  
always @(*)
begin
  //initialize		
  q = dividend[31] ? ~dividend+1 : dividend;
  m = divisor[31] ? ~divisor+1 : divisor;
  r=0;
  //32 cycles for 32 bits
  for(i = 0; i<32; i = i+1) 
  begin
    //shift left both variables, q's leftmost bit gets carried into r's rightmost after shift
    r = (r << 1);
    r = r | q[31];
    q = q << 1;
    //if r is negative add divisor, if positive subtract
    if(r[31]==1) temp = m;
    else temp = ~m+1;
    //add or subtract is executed accordingly
    r = r+temp;
    //check if r is negative. if positive rightmost bit of q set to 1
    if(r[31]) q = q | 0;
    else q = q | 1;
  end
  // if r negative restore
  if(r[31]) r=r+m;
  quotient <= dividend[31]^divisor[31] ? ~q+1 : q;
  remainder <= dividend[31]^divisor[31] ? ~r+1 : r;
end
endmodule
  
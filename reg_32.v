module reg_32(input clk, reset, enable, input [31:0] D, output reg [31:0] q);
initial q = 0;
always @(negedge clk) begin
  if (reset) begin
    q[31:0] = 32'b0;
  end
  else if (enable) begin
    q[31:0] = D[31:0];
  end
end
endmodule

module MDR_reg_32(input clk, reset, enable, read, input [31:0] busout, Mdatain, output [31:0] MDRout);
wire [31:0] MDRin;
mux_2_1 MDMux (busout, Mdatain, read, MDRin);
reg_32 reg_MDR (clk, reset, enable, MDRin, MDRout);
endmodule

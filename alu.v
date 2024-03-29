`timescale 1ns/10ps
module alu(input IncPC, br_flag, input [31:0] B, Y, input [4:0] opcode, output reg [31:0] HI, LO);
parameter _ld = 5'b00000, _ldi = 5'b00001, _st = 5'b00010, _add  = 5'b00011, _sub = 5'b00100, _and = 5'b00101, _or  = 5'b00110, _shr  = 5'b00111, 
_shra = 5'b01000, _shl = 5'b01001, _ror = 5'b01010, _rol = 5'b01011, _addi = 5'b01100, _andi = 5'b01101, _ori = 5'b01110, _mul = 5'b01111, 
_div = 5'b10000, _neg  = 5'b10001, _not  = 5'b10010, _branch = 5'b10011, _jr = 5'b10100, _jal = 5'b10101, _in = 5'b10110, _out = 5'b10111, 
_mfhi = 5'b11000, _mflo = 5'b11001, _nop = 5'b11010, _halt = 5'b11011;

wire[31:0] or_out, and_out, rol_out, ror_out, shl_out, shr_out, shra_out, not_out, neg_out, HImul_out, LOmul_out, HIdiv_out, LOdiv_out, add_out, sub_out, incPC_out;
wire add_cout, sub_cout;
// Operations 
or_32   OR  (Y, B, or_out);
and_32  AND (Y, B, and_out);
rol_32  ROL (Y, B, rol_out);
ror_32  ROR (Y, B, ror_out);
shl_32  SHL (Y, B, shl_out);
shr_32  SHR (Y, B, shr_out);
shra_32 SHRA(Y, B, shra_out);
not_32  NOT (B, not_out);
neg_32  NEG (B, neg_out);
mul_32  MUL (Y, B, HImul_out, LOmul_out);
div_32  DIV (Y, B, HIdiv_out, LOdiv_out);
add_32  ADD (Y, B, 1'b0, add_out, add_cout);
sub_32  SUB (Y, B, 1'b0, sub_out, sub_cout);
incPC   INC (B, IncPC, incPC_out);

always @(*) begin
  case (IncPC)
    1'b1: begin
			LO <= incPC_out; HI <= 32'd0;
		end
		1'b0: begin
			case (opcode)
				_add, _ld, _ldi, _st, _addi: begin
					LO <= add_out; HI <= 32'd0;
				end
				_sub: begin
					LO <= sub_out; HI <= 32'd0;
				end
				_and, _andi: begin
					LO <= and_out; HI <= 32'd0;
				end
				_or, _ori: begin
					LO <= or_out; HI <= 32'd0;
				end
				_shr: begin
					LO <= shr_out; HI <= 32'd0;
				end
				_shra: begin
					LO <= shra_out; HI <= 32'd0;
				end
				_shl: begin
					LO <= shl_out; HI <= 32'd0;
				end
				_ror: begin
					LO <= ror_out; HI <= 32'd0;
				end
				_rol: begin
					LO <= rol_out; HI <= 32'd0;
				end
				_mul: begin
					LO <= LOmul_out; HI <= HImul_out;
				end
				_div: begin
					LO <= LOdiv_out; HI <= HIdiv_out;
				end
				_neg: begin
					LO <= neg_out; HI <= 32'd0;
				end
				_not: begin
					LO <= not_out; HI <= 32'd0;
				end
				_branch: begin
					if (br_flag == 1) begin
						LO <= add_out; HI <= 32'd0;
					end
					else begin
						LO <= Y; HI <= 32'd0;
					end
				end
				default: begin
					LO <= 32'd0; HI <= 32'd0;
				end
			endcase
		end
	endcase
end
endmodule

`timescale 1ns/10ps
module shr_32_tb;
    reg PCout, Zhighout, Zlowout, MDRout, R5out, R3out, HIout, LOout; 
    reg MARin, Zin, PCin, MDRin, IRin, Yin, HIin, LOin;
    reg IncPC, Read, R1in, R3in, R5in;
    reg [4:0] opcode;
    reg Clock;
    reg flag;
    reg [31:0] Mdatain;



    parameter Default = 4'b0000, Reg_load1a = 4'b0001, Reg_load1b = 4'b0010, Reg_load2a = 4'b0011,
    Reg_load2b = 4'b0100, Reg_load3a = 4'b0101, Reg_load3b = 4'b0110, T0 = 4'b0111,
    T1 = 4'b1000, T2 = 4'b1001, T3 = 4'b1010, T4 = 4'b1011, T5 = 4'b1100;

    reg [3:0] Present_state = Default;

    datapath DUT(Clock, 1'b0, Mdatain, Read, IncPC, {10'd0, R5in, 1'b0, R3in, 1'b0, R1in, 1'b0}, {10'd0, R5out, 1'b0,  R3out, 3'd0}, PCin, Zin, MDRin, MARin, Yin, HIin, LOin, IRin, PCout, Zhighout, Zlowout, HIout, LOout, MDRout, 1'b0, opcode);

    initial begin
        Clock = 0;
		flag = 0;
        forever #10 Clock = ~ Clock;
    end

    always @(posedge Clock) begin
        if (flag == 1) begin
        case (Present_state)
            Default: Present_state = Reg_load1a;
            Reg_load1a: Present_state = Reg_load1b;
            Reg_load1b: Present_state = Reg_load2a;
            Reg_load2a: Present_state = Reg_load2b;
            Reg_load2b: Present_state = Reg_load3a;
            Reg_load3a: Present_state = Reg_load3b;
            Reg_load3b: Present_state = T0;
            T0: Present_state = T1;
            T1: Present_state = T2;
            T2: Present_state = T3;
            T3: Present_state = T4;
            T4: Present_state = T5;
        endcase
        flag = 0;
    end else begin
	flag = 1;
    end
    end

    always @(Present_state) begin
        case (Present_state)
            Default: begin
                PCout <= 0; Zlowout <= 0; Zhighout <= 0; MDRout <= 0; HIout <= 0; LOout <= 0;
                R5out <= 0; R3out <= 0; MARin <= 0; Zin <= 0;
                PCin <= 0; MDRin <= 0; IRin <= 0; Yin <= 0; HIin <= 0; LOin <= 0;
                IncPC <= 0; Read <= 0; opcode <= 5'b00000;
                R1in <= 0; R3in <= 0; R5in <= 0; Mdatain <= 32'h00000000;
            end
            Reg_load1a: begin
                Mdatain <= 32'h00000012;
                Read = 0; MDRin = 0;
                #10 Read <= 1; MDRin <= 1;
                #15 Read <= 0; MDRin <= 0;
            end
            Reg_load1b: begin
                #10 MDRout <= 1; R3in <= 1;
                #15 MDRout <= 0; R3in <= 0;
            end
            Reg_load2a: begin
                Mdatain <= 32'h00000001;
                #10 Read <= 1; MDRin <= 1;
                #15 Read <= 0; MDRin <= 0;
            end
            Reg_load2b: begin
                #10 MDRout <= 1; R5in <= 1;
                #15 MDRout <= 0; R5in <= 0;
            end
            Reg_load3a: begin
                Mdatain <= 32'h00000018;
                #10 Read <= 1; MDRin <= 1;
                #15 Read <= 0; MDRin <= 0;
            end
            Reg_load3b: begin
                #10 MDRout <= 1; R1in <= 1;
                #15 MDRout <= 0; R1in <= 0;
            end
            T0: begin
				PCout <= 1; MARin <= 1; IncPC <= 1;
                #10 PCout <= 0;  MARin <= 0; PCin <= 1;
				#10 PCin <= 0; IncPC <= 0;
            end
            T1: begin
                Mdatain <= 32'h28918000; // opcode for “and R1, R2, R3”
                #10 Read <= 1; MDRin <= 1;
                #15 Read <= 0; MDRin <= 0;
            end
            T2: begin
                #10 MDRout <= 1; IRin <= 1;
                #15 MDRout <= 0; IRin <= 0;
            end
            T3: begin
                #10 R3out <= 1; Yin <= 1;
                #15 R3out <= 0; Yin <= 0;
            end
            T4: begin
                #10 R5out <= 1; opcode <= 5'b00111; Zin <= 1;
                #15 R5out <= 0; Zin <= 0;
            end
            T5: begin
                #10 Zlowout <= 1; R1in <= 1;
                #15 Zlowout <= 0; R1in <= 0;
            end
        endcase
    end
endmodule


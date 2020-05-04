module PCMUX( input  logic [15:0] PC_INCREMENT,
              input  logic [15:0] LEFT_ADDER_OUT,
              input  logic [15:0] BUS_OUT, 
              input  logic [1:0]  select,
              output logic [15:0] OUT
            );

	/* COMBINATIONAL LOGIC INSIDE MODULE */
    always_comb 
    begin
			case (select)
				2'b00:
					OUT = PC_INCREMENT;
				2'b01:
					OUT = LEFT_ADDER_OUT;
				2'b10:
					OUT = BUS_OUT;
				2'b11:
					OUT = 16'h0;
			endcase
    end 


endmodule  //PCMUX


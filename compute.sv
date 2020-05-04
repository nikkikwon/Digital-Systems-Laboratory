module compute (input  logic [2:0]  F, 
                input  logic A_In, B_In,
                output logic A_Out, B_Out, F_A_B);

	/* INTERNAL COMBINATIONAL LOGIC */
    assign A_Out = A_In;
    assign B_Out = B_In;

	//This is the 1-bit ALU
    always_comb
	begin
        unique case (F) // The <unique> keyword here instructs synthesis to fail 
						// if a case appears more than once.
	 	   3'b000   : F_A_B = A_In & B_In ;		// F = 1 <-> OR   operation
		   3'b001   : F_A_B = A_In | B_In ;		// F = 2 <-> XOR  operation
		   3'b010   : F_A_B = A_In ^ B_In ;		// F = 2 <-> XOR  operation
		   3'b011   : F_A_B = 1'b1 ;			// F = 3 <-> set to 1
		   3'b100   : F_A_B = ~(A_In & B_In);	// F = 4 <-> NAND operation
		   3'b101   : F_A_B = ~(A_In | B_In);	// F = 5 <-> NOR  operation
		   3'b110   : F_A_B = ~(A_In ^ B_In);	// F = 6 <-> XNOR operation
		   3'b111   : F_A_B = 1'b0 ;			// F = 7 <-> clear to 0
        endcase
    end
	 
	 
endmodule
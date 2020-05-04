module NZP (input  logic        Clk, Reset, Load,
            input  logic [15:0] BUS,
            output logic        Nout, Zout, Pout
           );


    /* INTERNAL LOGIC DECLARATION */
    logic N = 1'b0; 
    logic Z = 1'b0; 
    logic P = 1'b0;
    
    /* INTERNAL COMBINATIONAL LOGIC */
    always_comb
    begin 
        if(BUS > 0)
		      begin
                P = 1'b1; N = 1'b0; Z = 1'b0;
			   end
        else if(BUS < 0)
            begin
                P = 1'b0; N = 1'b1; Z = 1'b0;
			   end
        else 
            begin
                P = 1'b0; N = 1'b0; Z = 1'b1;
			   end
    end
	 

    /* INTERNAL SEQUENTIAL LOGIC */ 
    always_ff @ (posedge Clk)
    begin
        if (Reset) //Active low, when set to 0 set Data_Out=16'h0
            begin
                Nout <= 1'b0;
                Zout <= 1'b0;
                Pout <= 1'b0;
            end
        else
            begin 
                if (Load)
                    begin
                        Nout <= N;
                        Zout <= Z;
                        Pout <= P;
                    end
                else 
                    begin
                        Nout <= Nout;
                        Zout <= Zout;
                        Pout <= Pout;
                    end
            end
    end

endmodule // NZP
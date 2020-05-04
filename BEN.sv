// BEN (i.e., Branch ENable) register
module BEN  (input  logic Clk,
             input  logic Load,
             input  logic Reset,
             input  logic [2:0] IN,
             input  logic Nout, Zout, Pout,
             output logic BENout
            );
	
 

    always_ff @ (posedge Clk) 
    begin 
        if(Load)
            BENout <= (IN[2] & Nout) + (IN[1] & Zout) + (IN[0] & Pout);
    end 
endmodule // module BEN

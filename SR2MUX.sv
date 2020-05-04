module SR2MUX( input logic [15:0] SR2OUT,       //select = 0
               input logic [15:0] SEXT_5,       //select = 1
               input logic select,
               output logic [15:0] OUT
             );

/* COMBINATIONAL LOGIC INSIDE MODULE */
    always_comb 
    begin
        if (select)
            OUT = SEXT_5;
        else
            OUT = SR2OUT;
    end 


endmodule  //SR2MUX


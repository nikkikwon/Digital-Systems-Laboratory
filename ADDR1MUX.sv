module ADDR1_MUX (input  logic [15:0] PC,
                  input  logic [15:0] SR1,
                  input  logic        select, 
                  output logic [15:0] OUT
                );

/* COMBINATIONAL LOGIC INSIDE MODULE */
    always_comb 
    begin
            if(select)
                OUT=PC;
            else
                OUT=SR1;
    end 

endmodule  //ADDR1MUX
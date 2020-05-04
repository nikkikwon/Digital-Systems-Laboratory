module DRMUX( input logic [2:0] eleven,  //select =0
    
              input logic [1:0] select,
              output logic [2:0] OUT
            );

/* COMBINATIONAL LOGIC INSIDE MODULE */
    always_comb 
    begin
        if (select)
            OUT = 3'b111;
        else
            OUT = eleven;
    end
    


endmodule  //DRMUX


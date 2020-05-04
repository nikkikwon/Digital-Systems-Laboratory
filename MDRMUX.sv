module MDRMUX ( input  logic 		MIO_EN, 
                input  logic [15:0] Data_to_CPU,    //from memory
                input  logic [15:0] Data_from_Bus,  //from 16 bit bus
                output logic [15:0] Data  
                 );


    /* COMBINATIONAL LOGIC INSIDE MODULE */
    always_comb 
    begin
        if (MIO_EN)
            Data = Data_to_CPU;
        else
            Data = Data_from_Bus;
    end 


endmodule  //MDRMUX


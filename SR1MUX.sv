module SR1MUX( input logic [2:0] IR_11_9,       //IR[11:9]select = 1
               input logic [2:0] IR_8_6,       //IR[8:6]select = 0
               input logic select,
               output logic [2:0] OUT
             );

/* COMBINATIONAL LOGIC INSIDE MODULE */
    always_comb 
    begin
        if (select)
            OUT = IR_11_9;
        else
            OUT = IR_8_6;
    end 


endmodule  //SR1MUX

  
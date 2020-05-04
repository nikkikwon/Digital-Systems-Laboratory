module ADDR2_MUX( input logic [15:0] ten,
                 input logic [15:0] eight,
                 input logic [15:0] five,

                 input logic [1:0] select, 
                 output logic [15:0] OUT
               );

/* COMBINATIONAL LOGIC INSIDE MODULE */
    always_comb 
    begin
            case (select)
                2'b00:
                    OUT = ten;
                2'b01:
                    OUT = eight;
                2'b10:
                    OUT = five;
                2'b11:
                    OUT = 16'h0;

            endcase
    end 

endmodule  //ADDR2MUX
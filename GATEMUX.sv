module GATEMUX( input logic [15:0] gateMARMUXin,
                input logic [15:0] gatePCin,
                input logic [15:0] gateMDRin,
                input logic [15:0] gateALUin,
                input logic [3:0] select, 
                output logic [15:0] OUT
              );

    /* COMBINATIONAL LOGIC INSIDE MODULE */
    always_comb 
    begin
            unique case (select)
                4'b0001:
                    OUT = gatePCin;
                4'b0010:
                    OUT = gateMDRin;
                4'b0100:
                    OUT = gateALUin;
                4'b1000:
                    OUT = gateMARMUXin;
                default:
                    OUT = 16'h 0;

            endcase
    end 

endmodule  //GATEMUX
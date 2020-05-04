//[8:0] -> SEXT middle SEXT on the left bottom

module SEXT_9( input logic [8:0] A, 
                output logic [15:0] OUT
              );

/* COMBINATIONAL LOGIC INSIDE MODULE */
    always_comb 
    begin
			OUT[8:0] = A;
            if (A[8])  //SIGN EXTEND 1
                OUT[15:9] = ({7 {1'b1} });
            else        //SIGN EXTEND 0
                OUT[15:9] = ({7 {1'b0} });
    end 
endmodule  //SEXT_9


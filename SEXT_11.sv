//[10:0] -> SEXT top SEXT on the left bottom

module SEXT_11( input logic [10:0] A, 
                output logic [15:0] OUT
              );

/* COMBINATIONAL LOGIC INSIDE MODULE */
    always_comb 
    begin
			OUT[10:0] = A;
            if (A[10])  //SIGN EXTEND 1
                OUT[15:11] = ({5 {1'b1} });
            else        //SIGN EXTEND 0
                OUT[15:11] = ({5 {1'b0} });
    end 
endmodule  //SEXT_11


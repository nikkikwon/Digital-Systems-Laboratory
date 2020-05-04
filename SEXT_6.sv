//[5:0] -> SEXT bottom SEXT on the left bottom

module SEXT_6( input logic [5:0] A, 
                output logic [15:0] OUT
              );

/* COMBINATIONAL LOGIC INSIDE MODULE */
    always_comb 
    begin
			OUT[5:0] = A;
            if (A[5])  //SIGN EXTEND 1
                OUT[15:6] = ({10 {1'b1} });
            else        //SIGN EXTEND 0
                OUT[15:6] = ({10 {1'b0} });
    end 
endmodule  //SEXT_6


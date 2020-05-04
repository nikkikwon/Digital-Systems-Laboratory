module ALU( input  logic [15:0] A, 
            input  logic [15:0] B,
            input  logic [1:0] select,
            output logic [15:0] OUT
          );

    /* COMBINATIONAL LOGIC INSIDE MODULE */
    always_comb 
    begin
      case (select)
            2'b00: // ADD
                  OUT = A + B;
            2'b01: // AND
                  OUT = A & B;
            2'b10: // NOT
                  OUT = ~A;
            2'b11: // PASS_A
                  OUT = A;  

      endcase
    end 

endmodule  //ALU
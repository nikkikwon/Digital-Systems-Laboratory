module REGFILE( input logic Clk, Reset, LD_REG,

                input logic [15:0] BUS, 
                     
                input logic [2:0] DRMUX,
                input logic [2:0] SR1MUX,  
                input logic [2:0] SR2,
               
       
                output logic [15:0] SR1OUT,
                output logic [15:0] SR2OUT
              );

/* INTERNAL LOGIC DECLARATION */
    logic [15:0] R0;
    logic [15:0] R1;
    logic [15:0] R2; 
    logic [15:0] R3;
    logic [15:0] R4; 
    logic [15:0] R5; 
    logic [15:0] R6; 
    logic [15:0] R7; 

/* COMBINATIONAL LOGIC INSIDE MODULE */
    always_comb 
			begin	
				case(SR1MUX)
				   3'b000: 
                        SR1OUT = R0;
					3'b001: 
                        SR1OUT = R1;
					3'b010: 
                        SR1OUT = R2;
					3'b011: 
                        SR1OUT = R3;
					3'b100: 
                        SR1OUT = R4;
					3'b101: 
                        SR1OUT = R5;
					3'b110: 
                        SR1OUT = R6;
					3'b111: 
                        SR1OUT = R7;
					default: ;
				endcase
				
				case(SR2) 
					3'b000: 
                        SR2OUT = R0;
					3'b001: 
                        SR2OUT = R1;
					3'b010: 
                        SR2OUT = R2;
					3'b011: 
                        SR2OUT = R3;
					3'b100: 
                        SR2OUT = R4;
					3'b101: 
                        SR2OUT = R5;
					3'b110: 
                        SR2OUT = R6;
					3'b111: 
                        SR2OUT = R7;
					default: ;
				endcase
			end


/* INTERNAL SEQUENTIAL LOGIC */
    always_ff @ (posedge Clk)
        begin
            if (Reset) //set all registers to zero
                begin 
                    R0 <= 16'h0;
                    R1 <= 16'h0;
                    R2 <= 16'h0;
                    R3 <= 16'h0;
                    R4 <= 16'h0;
                    R5 <= 16'h0;
                    R6 <= 16'h0;
                    R7 <= 16'h0;
                end
            else if (LD_REG)        // LD_REG HIGH : DR <- BUS 
                begin
                    case(DRMUX)
                        3'b000: 
                            R0 <= BUS;
                        3'b001: 
                            R1 <= BUS;
                        3'b010: 
                            R2 <= BUS;
                        3'b011: 
                            R3 <= BUS;
                        3'b100: 
                            R4 <= BUS;
                        3'b101: 
                            R5 <= BUS;
                        3'b110: 
                            R6 <= BUS;
                        3'b111: 
                            R7 <= BUS;
                        default: ;
                    endcase
                end
        end
endmodule  //REGFILE
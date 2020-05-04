// The required memory controller files (Mem2IO.sv & tristate.sv) 
// (You don't need to modify them, but are strongly recommended to understand how they work.)
module  Mem2IO ( 	input logic Clk, Reset,
                    input logic [19:0]  ADDR, 
                    input logic CE, UB, LB, OE, WE,
                    input logic [15:0]  Switches,
                    input logic [15:0] Data_from_CPU, Data_from_SRAM,
                    output logic [15:0] Data_to_CPU, Data_to_SRAM,
                    output logic [3:0]  HEX0, HEX1, HEX2, HEX3 );

    logic [15:0] hex_data;
   
    // Load data from switches when address is xFFFF, and from SRAM otherwise.
    always_comb
    begin 
        Data_to_CPU = 16'd0;
        // WE and OE are active low, but if-condition is true only when evaluated value != 0
        // i.e., if (WE ==1 && OE ==0) means: when WE is disabled and OE is enabled.
        if (WE && ~OE) 		// When OE is active: RAM chips will drive output on the selected address.
            if (ADDR[15:0] == 16'hFFFF) 
                Data_to_CPU = Switches;
            else 
                Data_to_CPU = Data_from_SRAM;
    end

    // Pass data from CPU to SRAM
    assign Data_to_SRAM = Data_from_CPU;

    // Write to LEDs when WE is active and address is xFFFF.
    always_ff @ (posedge Clk) begin 
        if (Reset) 
            hex_data <= 16'd0;
        // WE is active low, so when WE = 0, invert it to 1(=true) for the if-condition
        else if ( ~WE & (ADDR[15:0] == 16'hFFFF) ) 
            hex_data <= Data_from_CPU;
    end
       
    assign HEX0 = hex_data[3:0];
    assign HEX1 = hex_data[7:4];
    assign HEX2 = hex_data[11:8];
    assign HEX3 = hex_data[15:12];

endmodule

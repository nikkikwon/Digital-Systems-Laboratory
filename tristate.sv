// The required memory controller files (Mem2IO.sv & tristate.sv) 
// (You don't need to modify them, but are strongly recommended to understand how they work.)
// Weon: Acts as an interface between Mem2IO and SRAM
module tristate #(parameter N = 16) 
                 (input  logic Clk, 
                  input  logic tristate_output_enable,
                  input  logic [N-1:0] Data_write, // <- Data_to_SRAM
                  output logic [N-1:0] Data_read,  // <- Data_from_SRAM
                  inout  wire  [N-1:0] Data // inout bus to SRAM
                  );
// Weon: wire vs logic vs reg:
//       SystemVerilog is super set of Verilog so it has all the data types which are there in Verilog.
//       logic is a SystemVerilog data type which can be used in place of reg & wire. 
//       Since it is confusing which one to declare as reg or wire in verilog,
//       so they have introduced logic as new data type in SystemVerilog. 
//       Tool will automatically interprets its behavior according to its usage. 


/* Weon: INTERNAL LOGIC DECLARATION */
// Registers are needed between synchronized circuit and asynchronized SRAM 
logic [N-1:0] Data_write_buffer, Data_read_buffer;

/* Weon: INTERNAL COMBINATIONAL LOGIC */
// Drive (write to) Data bus only when tristate_output_enable is active.
assign Data      = tristate_output_enable ? Data_write_buffer : {N{1'bZ}};
assign Data_read = Data_read_buffer; 

/* Weon: INTERNAL SEQUENTIAL LOGIC */
always_ff @(posedge Clk)
begin
	// Always read data from the bus
	Data_read_buffer <= Data;
	// Always updated with the data from Mem2IO which will be written to the bus
	Data_write_buffer <= Data_write;
end



endmodule

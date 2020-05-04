// The top level entity which instantiates sLC3 and test_memory.
module lab6_toplevel( input  logic [15:0] S, // Slider Switches from FPGA 
                                             // used to provide memory address for PC 
                      input  logic Clk, Reset, Run, Continue,
                      output logic [11:0] LED,
                      output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
                      output logic CE, UB, LB, OE, WE,
                      output logic [19:0] ADDR,
							 output logic [15:0] PC_VALUE,
							 output logic [15:0] IR_VALUE,
							 output logic [15:0] MAR_VALUE,
							 output logic [15:0] MDR_VALUE,
                      inout  wire [15:0] Data);

slc3 my_slc(.*);
// Even though test memory is instantiated here, it will be synthesized into 
// a blank module, and will not interfere with the actual SRAM.
// Test memory is to play the role of physical SRAM in simulation.
test_memory my_test_memory(.Reset(~Reset), .I_O(Data), .A(ADDR), .*);



// Week 1 DEMO
// -Simulation of PC loading into MAR and PC incrementing. (1 points)
// -Simulation of MDR loading into IR. (1 points)
// -Correct FETCH operation on the board, 
//  showing IR on the hex displays. 
//  Must use the physical memory (test_programs_image.ram) 
//  instead of the test memory (test_memory.sv). (1 point)






endmodule
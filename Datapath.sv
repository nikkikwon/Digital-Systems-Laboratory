module datapath ( input logic           Clk, Reset,
                  input logic           GateMARMUX, 
                  input logic           GateMDR,
                  input logic           GatePC,
                  input logic           GateALU,
                  input logic           LD_PC, 
                  input logic           LD_IR,
						input logic				 LD_REG,
                  input logic           LD_MDR,
                  input logic           LD_MAR,
                  input logic           LD_BEN,
                  input logic           LD_CC,
                  input logic           MIO_EN,
                  input logic [1:0]     PCselect, ALUKselect,
                  input logic [15:0]    MDR_In, // Weon: Data_to_CPU from MEM2IO
                  input logic           ADDR1MUX,
                  input logic [1:0]     ADDR2MUX,
                  input logic           DRMUXselect,
                  input logic           SR1MUXselect,
                  input logic           SR2MUXselect,
                  output logic [15:0]   IRout, MDRout, MARout, PCout,
                  output logic          BENout	
                );

    /* INTERNAL LOGIC DECLARATION */
    logic [15:0] BUS;
    logic [15:0] PCMUXout;
    logic [15:0] MDRMUXout;
    logic [15:0] ALUout;
    logic [15:0] ADDR1MUXout, ADDR2MUXout;
    logic [15:0] leftaddout;
    logic [15:0] sext11out, sext9out, sext6out, sext5out;
    logic [15:0] SR2MUXout;
	  logic [2:0] SR1MUXout;
    logic [15:0] SR1OUT, SR2OUT;
    logic [2:0]  drmuxout;

    logic        Nout, Zout, Pout;

    /* INTERNAL COMBINATION LOGIC */

    // DECLARE 16-BIT REGISTERS (IR, MDR, MAR, PC)
    reg_16 IR  (.*, .Load(LD_IR),  .Data_In(BUS),       .Data_Out(IRout) ); 
    reg_16 MDR (.*, .Load(LD_MDR), .Data_In(MDRMUXout), .Data_Out(MDRout) );
    reg_16 MAR (.*, .Load(LD_MAR), .Data_In(BUS),       .Data_Out(MARout));
    reg_16 PC  (.*, .Load(LD_PC),  .Data_In(PCMUXout),  .Data_Out(PCout));

    // NZP & BEN(Branch ENable) registers
    BEN BEN0   (.*, 
                .Load(LD_BEN), 
                .IN(IR[11:9]),
                );
                
    NZP NZP0   (.*, .Load(LD_CC));

    //SR1 yet set
    ADDR1_MUX addr1mux (.PC(PCout),
                        .SR1(SR1OUT),
                        .select(ADDR1MUX),
                        .OUT(ADDR1MUXout)
                       );

    ADDR2_MUX addr2mux (.ten(sext11out),
                        .eight(sext9out),
                        .five(sext6out),
                        .select(ADDR2MUX),
                        .OUT(ADDR2MUXout)
                    );

    // ADDER TO THE LEFT 
    ALU leftadder  (.A(ADDR2MUXout), 
                    .B(ADDR1MUXout), 
                    .select(2'b00),
                    .OUT(leftaddout)
                   );

    // ALU TO THE RIGHT
    ALU rightALU (.A(SR1OUT),
                  .B(SR2MUXout),
                  .select(ALUKselect),
                  .OUT(ALUout)
                 );

    

    // DECLARE MUXES 

    // what should I put for the select 
    GATEMUX gatemux(.gateMARMUXin(leftaddout), 
                    .gatePCin(PCout), 
                    .gateMDRin(MDRout), 
                    .gateALUin(ALUout),
                    .select({GateMARMUX, GateALU, GateMDR, GatePC}),  //select not specified.
                    .OUT(BUS));

    PCMUX pcmux(.PC_INCREMENT(PCout+16'b1),  
                .LEFT_ADDER_OUT(leftaddout),
                .BUS_OUT(BUS),
                .select(PCselect),
                .OUT(PCMUXout)
               );  

    MDRMUX mdrmux(.MIO_EN(MIO_EN),
                  .Data_to_CPU(MDR_In),
                  .Data_from_Bus(BUS),
                  .Data(MDRMUXout)
                 );
        

    SR1MUX sr1mux (.IR_11_9(IRout[11:9]),
                   .IR_8_6(IRout[8:6]),
                   .select(SR1MUXselect),
                   .OUT(SR1MUXout)
                  ); 
                
    //select from slc3 not defined yet
    SR2MUX sr2mux( .SR2OUT(SR2OUT),
                   .SEXT_5(sext5out),
                   .select(SR2MUXselect),
                   .OUT(SR2MUXout)
                   );

    DRMUX drmux( .eleven(IRout[11:9]),
                 .select(DRMUXselect),
                 .OUT(drmuxout)
                 );

    /*SEXT*/

    SEXT_11 sext11  (.A(IRout[10:0]), 
                     .OUT(sext11out)  
                    );

    SEXT_9 sext9  (.A(IRout[8:0]), 
                   .OUT(sext9out)  
                  );

    SEXT_6 sext6  (.A(IRout[5:0]), 
                   .OUT(sext6out)  
                  );

    SEXT_5 sext5  (.A(IRout[4:0]), 
                   .OUT(sext5out)  
                  );

    /*REGISTER FILE R0-R7*/

    REGFILE regfile(.*,
                    .LD_REG(LD_REG), 
                    .BUS(BUS),
                    .DRMUX(drmuxout), 
                    .SR1MUX(SR1MUXout),
                    .SR2(IRout[2:0]),
                    .SR1OUT(SR1OUT),
                    .SR2OUT(SR2OUT)
                    );





endmodule //datapath
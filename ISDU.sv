// Control Unit (ISDU.sv) skeleton - you need to fill in the control unit for week 2.
module ISDU (   input logic         Clk, 
                                    Reset,		// <- Reset_ah
                                    Run,		// <- Run_ah
                                    Continue,	// <- Continue_ah
                                    
                input logic[3:0]    Opcode, 
                input logic         IR_5,
                input logic         IR_11,
                input logic         BEN,
                  
                output logic        LD_MAR,
                                    LD_MDR,
                                    LD_IR,
                                    LD_BEN,
                                    LD_CC,
                                    LD_REG,
                                    LD_PC,
                                    LD_LED, // for PAUSE instruction
                                    
                output logic        GatePC,
                                    GateMDR,
                                    GateALU,
                                    GateMARMUX,
                                    
                output logic [1:0]  PCMUX,
                output logic        DRMUX,
                                    SR1MUX,
                                    SR2MUX,
                                    ADDR1MUX,
                output logic [1:0]  ADDR2MUX,
                                    ALUK,
                  
                output logic        Mem_CE,
                                    Mem_UB,
                                    Mem_LB,
                                    Mem_OE,
                                    Mem_WE
                );

    enum logic [4:0] {  Halted,                  // Nikki: total : 24states [3:0] -> [4:0]
                        PauseIR1, 
                        PauseIR2, 
                        S_18, 
                        S_33_1, 
                        S_33_2, 
                        S_35, 
                        S_32, 
                        S_01,
                        S_00,
                        S_22,
                        S_12,
                        S_04,
                        S_21,
                        S_07,
                        S_23,
                        S_16_1,                  // Nikki: involves SRAM 2 states needed. 
                        S_16_2,
                        S_06,
                        S_25_1,                  // Nikki: involves SRAM 2 states needed. 
                        S_25_2,
                        S_27,
                        S_05,
                        S_09    
                        }   State, Next_state;   // Internal state logic
        




    always_ff @ (posedge Clk)
    begin
        if (Reset) 
            State <= Halted;
        else 
            State <= Next_state;
    end
   
    always_comb
    begin 
        // Default next state is staying at current state
        Next_state = State;
        
        // Default controls signal values 
        // (Weon:) that are outputted UNLESS set otherwise at corresponding states.
        LD_MAR = 1'b0;
        LD_MDR = 1'b0;
        LD_IR = 1'b0;
        LD_BEN = 1'b0;
        LD_CC = 1'b0;
        LD_REG = 1'b0;
        LD_PC = 1'b0;
        LD_LED = 1'b0;
         
        GatePC = 1'b0;
        GateMDR = 1'b0;
        GateALU = 1'b0;
        GateMARMUX = 1'b0;
         
        ALUK = 2'b00;
         
        PCMUX = 2'b00;
        DRMUX = 1'b0;
        SR1MUX = 1'b0;
        SR2MUX = 1'b0;
        ADDR1MUX = 1'b0;
        ADDR2MUX = 2'b00;
         
        Mem_OE = 1'b1;
        Mem_WE = 1'b1;
    
        // Assign next state
        unique case (State)
            Halted : 
                if (Run)     //Nikki: if (Reset), State <= Halted   // this until Run = high. Now Run = high
                    Next_state = S_18;                      
            S_18 : 
                Next_state = S_33_1;
            // Any states involving SRAM require more than one clock cycles.
            // The exact number will be discussed in lecture.
            S_33_1 :                        // Nikki: How should we consider R?
                Next_state = S_33_2;
            S_33_2 : 
                Next_state = S_35;
            S_35 : 
                Next_state = S_32;
                // Next_state = PauseIR1;   // PauseIR1 and PauseIR2 are only for Week 1 such that TAs can see 
                                            // the values in IR.
            // added rest of the opcodes
            S_32 : 
                case (Opcode)
                    4'b0001 : //ADD
                        Next_state = S_01;
                    4'b0101 : //AND
                        Next_state = S_05;
                    4'b1001 : //NOT
                        Next_state = S_09;
                    4'b0000 : //BR
                        Next_state = S_00; 
                    4'b1100 : //JMP                
                        Next_state = S_12;
                    4'b0100 : //JSR
                        Next_state = S_04;
                    4'b0110 : //LDR
                        Next_state = S_06;
                    4'b0111 : //STR
                        Next_state = S_07;
                    4'b1101 : //PSE
                        Next_state = PauseIR1;  

                    default : 
                        Next_state = S_18;
                endcase
            // ADD 
            S_01 : 
                Next_state = S_18;
            // AND
            S_05 :                          
                Next_state = S_18;
            // NOT
            S_09 : 
                Next_state = S_18;
            //LDR
            S_06 : 
                Next_state = S_25_1;
            S_25_1 :                        // Nikki: How should we consider R?
                Next_state = S_25_2;
            S_25_2 : 
                Next_state = S_27;
            S_27 : 
                Next_state = S_18;

            //STR
            S_07 : 
                Next_state = S_23;
            S_23 : 
                Next_state = S_16_1;
            S_16_1 :                        // Nikki: How should we consider R?
                Next_state = S_16_2;
            S_16_2 : 
                Next_state = S_18;
                
            //JSR
            S_04 : 
                Next_state = S_21;
            S_21 : 
                Next_state = S_18;

            //JMP
            S_12 : 
                Next_state = S_18;
            
            //BR
            S_00 :  //Nikki: How should we consider the branch?//using input BEN? 
                if (BEN)                        
                    Next_state = S_22;
                else    
                    Next_state = S_18;
            S_22:
                Next_state = S_18;


            PauseIR1 : 
                if (~Continue) // Weon: if Continue is *not* pressed 
                    Next_state = PauseIR1;	// Weon: then stay at PauseIR1 state
                else 
                    Next_state = PauseIR2;
            PauseIR2 : 
                if (Continue) // Weon: if Continue is kept pressed 
                    Next_state = PauseIR2; // Weon: then stay at PauseIR2 state
                else 
                    Next_state = S_18;           
            default : ;

        endcase
        
        // Assign control signals based on current state
        case (State)
            Halted: ;
            S_18 : 
                begin 
                    GatePC = 1'b1;
                    LD_MAR = 1'b1;
                    PCMUX = 2'b00;
                    LD_PC = 1'b1;
                end
            S_33_1 : 
                    Mem_OE = 1'b0;
            S_33_2 : 
                begin 
                    Mem_OE = 1'b0;
                    LD_MDR = 1'b1;
                end
            S_35 : 
                begin 
                    GateMDR = 1'b1;
                    LD_IR = 1'b1;
                end

            PauseIR1: 
				begin
					LD_LED = 1'b1;
				end

			PauseIR2: 
				begin
					LD_LED = 1'b1;
				end

            S_32 : 
                LD_BEN = 1'b1;

            //ADD (DR <- SR1 + (SR2/imm5), setcc)
            S_01 :                      
                begin 
                    SR1MUX = 1'b0;          //Nikki: SR1MUX = SR1MUXselect for MUX, SR1MUX = 0 = choose IR[8:6]
                    SR2MUX = IR_5;          //Nikki: IR_5 = IR[5] determines btw SR2=0 and SEXT(imm5)=1
                    ALUK = 2'b00;           //choose ADD
                    GateALU = 1'b1;
                    DRMUX = 1'b0;           //default = 0, do we still need to set it?
                    LD_REG = 1'b1;          // DR <- result
                    LD_CC = 1'b1;           //Nikki: setCC needed since storing value at the register
                end

            //AND (DR <- SR1 & (SR2/imm5), setcc)
            S_05 : 
                begin
                    SR1MUX = 1'b0;          //Nikki: choose IR[8:6]
                    SR2MUX = IR_5;          //SR2 / SEXT(imm5)
                    ALUK = 2'b01;            //choose AND       
                    GateALU = 1'b1;
                    DRMUX = 1'b0;           //default = 0, do we still need to set it?
                    LD_REG = 1'b1;
                    LD_CC = 1'b1;
                end

            //NOT (DR <- NOT(SR), setcc)
            S_09 : 
                begin
                    SR1MUX = 1'b0;          //Nikki: choose IR[8:6]
                    ALUK = 2'b10;           //choose NOT       
                    GateALU = 1'b1;
                    LD_REG = 1'b1;          // DR <- result
                    LD_CC = 1'b1;
                end
            
            //LDR
            //LDR 1. MAR <- BaseR + off6
            S_06 : 
                begin
                    SR1MUX = 1'b0;          // choose IR[8:6]
                    ADDR1MUX = 1'b0;        // select for ADDR1 = 0, choose SR1
                    ADDR2MUX = 2'b10;       // select for ADDR2 = 10, choose IR[5:0]
                    GateMARMUX = 1'b1;  
                    LD_MAR = 1'b1;
                end

            //LDR 2. MDR <- M[MAR], same as state 33(?)
            S_25_1 :
                begin
                    Mem_OE = 1'b0;          // Active Low
                end
    
            S_25_2 : 
                begin 
                    Mem_OE = 1'b0;      
                    LD_MDR = 1'b1;
                end

            //LDR 3. DR <- MDR, setcc, similar to state 35
            S_27 :
                begin
                    GateMDR = 1'b1;
                    LD_REG = 1'b1;         // DR <- result  
                    LD_CC = 1'b1;    
                    DRMUX = 1'b0;          //default = 0, do we still need to set it?
                end
            //STR
            //STR 1. MAR <- BaseR + off6, same as state 6
            S_07 :
                begin
                    SR1MUX = 1'b0;        // choose IR[8:6]
                    ADDR1MUX = 1'b0;      // select for ADDR1 = 0, choose SR1
                    ADDR2MUX = 2'b10;     // select for ADDR2 = 10, choose IR[5:0]
                    GateMARMUX = 1'b1;  
                    LD_MAR = 1'b1;
                end

            //STR 2. MDR <- SR, SR = IR[11:9]
            S_23 : 
                begin
                    LD_MDR = 1'b1;
                    SR1MUX = 1'b1;       // choose IR[11:9]
                    ALUK = 2'b11;        // Pass A = SR1
                    GateALU = 1'b1;      // A(SR1) -> BUS
                end

            //STR 3. M[MAR] <- MDR
            S_16_1 : 
                begin
                    Mem_WE = 1'b0;       //Active Low
                end
    
            S_16_2 : 
                begin      
                    Mem_WE = 1'b0;
                end

            //JSR
            //JSR 1. R7 <-PC
            S_04 :
                begin
                    GatePC = 1'b1;
                    DRMUX = 1'b1;      //Nikki: DRMUX select 111, R7
                    LD_REG = 1'b1;           
                end
            
            //JSR 2. PC <-PC+off11
            S_21 :
                begin
                    ADDR2MUX = 2'b00;  //choose IR[10:0]
                    ADDR1MUX = 1'b1;   //choose PC 
                    PCMUX = 2'b01;     //choose left adder output
                    LD_PC = 1'b1;          
                end 
            
            //JMP PC <- Base Register
            S_12 :
                begin
                    LD_PC = 1'b1;
                    ADDR1MUX = 1'b0;   //choose SR1out
                    ADDR2MUX = 2'b11;  //choose 0, 0 + SR1OUT(Base R)
                    SR1MUX = 1'b0;     //choose IR[8:6]
                    PCMUX = 2'b01;     //choose adder output = 0 + SR1OUT(Base R)
                end
            
            //BR [BEN], Do we even need this? NEED LOGIC FOR BR, NZP
            S_00 : ;

            S_22 : 
                begin
                    ADDR1MUX = 1'b1;    // choose PC
                    ADDR2MUX = 2'b01;   // choose IR[8:0]
                    PCMUX = 2'b01;      // choose left adder output
                    LD_PC = 1'b1;  
                end     

            default : ;
        endcase
    end 

     // These should always be active
    assign Mem_CE = 1'b0;
    assign Mem_UB = 1'b0;
    assign Mem_LB = 1'b0;
    
endmodule

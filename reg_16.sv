module reg_16 ( input  logic Clk, Reset, Load,
                input  logic [15:0]  Data_In,
                output logic [15:0]  Data_Out);


    /* INTERNAL SEQUENTIAL LOGIC */ 
    always_ff @ (posedge Clk)
    begin
        if (Reset) //Active low, when set to 0 set Data_Out=16'h0
            Data_Out <= 16'h0;
        else 
            if (Load)
                Data_Out <= Data_In;
            else 
                Data_Out <= Data_Out;
    end

endmodule // reg_16
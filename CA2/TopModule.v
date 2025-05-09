module TopModule(
    input clk,
    input reset
);
    wire WE, WE3, ALUSrc;
    wire [2:0] ALUControl, ImmSrc;
    wire [1:0] ResultSrc, PCSrc;
    wire zero; 
    wire [2:0] func3; 
    wire [6:0] func7, opcode;

    DataPath datapath(
        .clk(clk),
        .reset(reset),
        .WE(WE),
        .WE3(WE3),
        .ALUSrc(ALUSrc),
        .ALUControl(ALUControl),
        .ImmSrc(ImmSrc),
        .ResultSrc(ResultSrc),
        .PCSrc(PCSrc),
        .zero(zero),
        .func3(func3),
        .func7(func7),
        .opcode(opcode)
    );
    
endmodule
module TopModule(
    input clk,
    input reset
);
    // Wires to connect Controller and DataPath
    wire [6:0] opcode;
    wire [2:0] func3;
    wire [6:0]func7;
    wire zero;
    wire RegWrite, MemWrite, ALUSrc;
    wire [1:0] ResultSrc, PCSrc;
    wire [2:0] ALUControl, ImmSrc;

    Controller controller(
        .op(opcode),
        .funct3(func3),
        .funct7(func7[5]),
        .Zero(zero),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .ALUSrc(ALUSrc),
        .ALUControl(ALUControl),
        .ImmSrc(ImmSrc),
        .PCSrc(PCSrc)
    );

    DataPath dataPath(
        .clk(clk),
        .reset(reset),
        .MemWrite(MemWrite),
        .RegWrite(RegWrite),
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
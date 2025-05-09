module DataPath(
    input clk,
    input reset,
    input WE,
    input WE3,
    input ALUSrc,
    input [2:0] ALUControl,
    input [2:0] ImmSrc,
    input [1:0] ResultSrc,
    input [1:0] PCSrc,
    output zero,
    output [2:0] func3,
    output [6:0] func7,
    output [6:0] opcode
);
    wire [31:0] instr, PC; 
    wire [31:0] PCNext;
    wire [31:0] PCPlus4; 
    wire [31:0] PCTarget, ImmExt; 
    wire [4:0] A1, A2, A3; 
    wire [31:0] WD3, RD1, RD2;
    wire [31:0] SrcB;
    wire [31:0] ALUResult; 
    wire [31:0] RD;
    wire [31:0] Result;

    assign A1 = instr[19:15];
    assign A2 = instr[24:20];
    assign A3 = instr[11:7];
    assign func3 = instr[14:12];
    assign func7 = instr[31:25];
    assign opcode = instr[6:0];

    InstructionMemory instrMem(
        .PC(PC),
        .instr(instr)
    );
    RegisterPC registerPC(
        .clk(clk),
        .reset(reset),
        .PCNext(PCNext),
        .PC(PC)
    );
    AdderPC adderPC(
        .PC(PC),
        .PCPlus4(PCPlus4)
    );
    AdderPCTarget adderPCTarget(
        .PC(PC),
        .ImmExt(ImmExt),
        .PCTarget(PCTarget)
    );
    RegisterFile registerFile(
        .clk(clk),
        .reset(reset),
        .WE3(WE3),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .WD3(WD3),
        .RD1(RD1),
        .RD2(RD2)
    );
    MuxSrcB muxSrcB(
        .RD2(RD2),
        .ImmExt(ImmExt),
        .ALUSrc(ALUSrc),
        .SrcB(SrcB)
    );
    ALU alu(
        .SrcA(RD1),
        .SrcB(SrcB),
        .ALUControl(ALUControl),
        .zero(zero),
        .ALUResult(ALUResult)
    );
    DataMemory dataMemory(
        .clk(clk),
        .WE(WE),
        .A(ALUResult),
        .WD(RD2),
        .RD(RD)
    );
    Extend extend(
        .instr(instr),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)
    );
    MuxResult muxResult(
        .ResultSrc(ResultSrc),
        .ALUResult(ALUResult),
        .RD(RD),
        .PCPlus4(PCPlus4),
        .ImmExt(ImmExt),
        .Result(Result)
    );
    MuxPC muxPC(
        .PCSrc(PCSrc),
        .PCPlus4(PCPlus4),
        .PCTarget(PCTarget),
        .ALUResult(ALUResult),
        .PCNext(PCNext)
    );
endmodule
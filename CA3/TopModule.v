module TopModule (
    input wire clk,
    input wire reset
);
    wire WE, AdrSrc, PCWrite, IRWrite, tos, pop, push, zero;
    wire [1:0] ALUOp, ALUSrcA, ALUSrcB, ResultSrc;
    wire [7:0] Instr;
    wire stw1, stw2;

    Controller controller_inst (
        .clk(clk),
        .reset(reset),
        .zero(zero),
        .Instr(Instr[7:5]), 
        .WE(WE),
        .AdrSrc(AdrSrc),
        .PCWrite(PCWrite),
        .IRWrite(IRWrite),
        .tos(tos),
        .pop(pop),
        .push(push),
        .ALUOp(ALUOp),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ResultSrc(ResultSrc),
        .stw1(stw1),
        .stw2(stw2)
    );

    Datapath datapath_inst (
        .clk(clk),
        .reset(reset),
        .PCWrite(PCWrite),
        .AdrSrc(AdrSrc),
        .IRWrite(IRWrite),
        .push(push),
        .pop(pop),
        .tos(tos),
        .stw1(stw1),
        .stw2(stw2),
        .WE(WE),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ALUOp(ALUOp),
        .ResultSrc(ResultSrc),
        .Instr(Instr),
        .zero(zero)
    );
endmodule
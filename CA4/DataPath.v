module DataPath(
    input clk,
    input reset,
    //controller inputs
    input MemWriteD,
    input RegWriteDD,
    input ALUSrcD,
    input JumpD,
    input BranchD,
    input ALUSrcD,
    input [2:0] ALUControlD,
    input [2:0] ImmSrcD,
    input [1:0] ResultSrcD,
    input [1:0] PCSrcD,
    input LuiD,

    output zero,
    output [2:0] func3,
    output [6:0] func7,
    output [6:0] opcode
);
    wire [31:0] InstrD, PCD; 
    wire [31:0] PCNext;
    wire [31:0] PCPlus4; 
    wire [31:0] PCTarget, ImmExt; 
    wire [4:0] A1, A2, A3; 
    wire [31:0] WD3, RD1, RD2;
    wire [31:0] SrcBE;
    wire [31:0] ALUResult; 
    wire [31:0] RD;
    wire [31:0] Result;
    wire [31:0] PCF,PCF_next;
    
    assign func3 = InstrD[14:12];
    assign func7 = InstrD[31:25];
    assign opcode = InstrD[6:0];
    assign WD3 = Result;
    wire [31:0] InstrF;

    //fetch stage
   

    MuxPC muxPC(
        .PCSrc(PCSrc),
        .PCPlus4(PCPlus4),
        .PCTarget(PCTargetE),
        .PCNext(PCF_next)
    );
    RegisterPC registerPC(
        .clk(clk),
        .reset(reset),
        .EN(StallF),
        .PCNext(PCF_next),
        .PC(PCF)
    );
    InstructionMemory instrMem(
        .PC(PCF),
        .instr(InstrF)
    );
    AdderPC adderPC(
        .PC(PCF),
        .PCPlus4(PCPlus4F)
    );

    wire [31:0] InstrD;
    wire [31:0] PCD;
    wire [31:0] PCPlus4D;
    Fetch_register fetch_register(
        .clk(clk),
        .EN(/*TODO: comes from hazard unit*/ ),
        .clear(/*TODO: comes from hazard unit*/),
        .InstrF(InstrF),
        .PCF(PCF),
        .PCPlus4F(PCPlus4F),
        .InstrD(InstrD),        
        .PCD(PCD),       
        .PCPlus4D(PCPlus4D)   
    );


    //decode stage
    assign A1 = InstrD[19:15];
    assign A2 = InstrD[24:20];
    assign A3 = InstrD[11:7];
    wire RegWriteW;
    wire [31:0] RD1D,RD2D;
    wire [31:0] ResultW;
    RegisterFile registerFile(
        .clk(clk),
        .reset(reset),
        .WE3(RegWriteW),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .WD3(ResultW),
        .RD1(RD1D),
        .RD2(RD2D)
    );
    wire [31:0] ImmExtD;
    Extend extend(
        .instr(InstrD),
        .ImmSrc(ImmSrcD),
        .ImmExt(ImmExtD)
    );


    wire JalrE, RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE,LuiE;
    wire [1:0] ResultSrcE;
    wire [2:0] ALUControlE;
    wire [31:0] RD1E, RD2E, PCE, ImmExtE, PCPlus4E;
    wire [4:0] Rs1E, Rs2E, RdE;
    // Instantiate Decode_register
    Decode_register decode_register (
        
        .clk(clk),
        .clear(/* TODO: connect to hazard unit  */),
        .JalrD(JalrD), 
        .RegWriteD(RegWriteDD),
        .ResultSrcD(ResultSrcD),
        .MemWriteD(MemWriteD),
        .JumpD(JumpD), 
        .BranchD(BranchD),
        .ALUControlD(ALUControlD),
        .ALUSrcD(ALUSrcD),
        .RD1D(RD1D),
        .RD2D(RD2D),
        .PCD(PCD),
        .Rs1D(A1),
        .Rs2D(A2),
        .RdD(A3),
        .ImmExtD(ImmExtD),
        .PCPlus4D(PCPlus4D),
        .LuiD(LuiD), 
        //output wires
        .JalrE(JalrE),
        .RegWriteE(RegWriteE),
        .ResultSrcE(ResultSrcE),
        .MemWriteE(MemWriteE),
        .JumpE(JumpE),
        .BranchE(BranchE),
        .ALUControlE(ALUControlE),
        .ALUSrcE(ALUSrcE),
        .RD1E(RD1E),
        .RD2E(RD2E),
        .PCE(PCE),
        .Rs1E(Rs1E),
        .Rs2E(Rs2E),
        .RdE(RdE),
        .ImmExtE(ImmExtE),
        .PCPlus4E(PCPlus4E).
        .LuiE(LuiE) 
    );
    
    wire [31:0] Lui_mux_output, ALUResultM,SrcAE; 
    wire [31:0] WriteDataE, PCTargetE;
    wire [31:0] ALUResultE, PCPlus4E;
    wire [4:0] RdE;
    wire RegWriteE, MemWriteE;
    wire [1:0] ResultSrcE;


    Mux2to1 #(.WIDTH(32)) Lui_select (
        .a(32'b0),
        .b(RD1E),
        .sel(LuiE),
        .y(Lui_mux_output)
    );
    wire [31:0] Forwading_A_result;
    Mux4to1 #(.WIDTH(32)) Forwarding_A (
        .a(Lui_mux_output),
        .b(ResultW),
        .c(ALUResultM),
        .d(32'b0),
        .sel(ForwardAE),//TODO hazard unit 
        .y(SrcAE)
    );
    Mux4to1 #(.WIDTH(32)) Forwarding_B (
        .a(RD2E),
        .b(ResultW),
        .c(ALUResultM),
        .d(32'b0),
        .sel(ForwardBE), //TODO hazard unit
        .y(WriteDataE)
    );
    wire [31:0] Jalr_mux_output;
    Mux2to1 #(.WIDTH(32)) Jalr_mux(
        .a(ImmExtE),
        .b(RD1E),
        .sel(JalrE),
        .y(Jalr_mux_output)
    );
    Mux2to1 #(.WIDTH(32)) SrcB_selector (
        .a(WriteDataE),
        .b(Jalr_mux_output),
        .sel(ALUSrcE),
        .y(SrcBE)
    );
    AdderPCTarget adderPCTarget(
        .PC(PCE),
        .ImmExt(Jalr_mux_output),
        .PCTarget(PCTargetE)
    );
    ALU alu(
        .SrcA(SrcAE),
        .SrcB(SrcBE),
        .ALUControl(ALUControlE),
        .zero(zero),
        .ALUResult(ALUResultE)
    );

    //write Back stage
    wire [31:0] ReadDataM, PCPlus4M;
    wire [4:0] RdM;
    wire RegWriteM, MemWriteM;
    wire [1:0] ResultSrcM;
    wire [31:0] WriteDataM;
    Execution_register alu_execution (
        .clk(clk),
        .clear(reset),
        .RegWriteE(RegWriteE),
        .ResultSrcE(ResultSrcE),
        .MemWriteE(MemWriteE),
        .ALUResultE(ALUResultE),
        .WriteDataE(WriteDataE),
        .RdE(RdE),
        .PCPlus4E(PCPlus4E),
        .RegWriteM(RegWriteM),
        .ResultSrcM(ResultSrcM),
        .MemWriteM(MemWriteM),
        .ALUResultM(ALUResultM),
        .WriteDataM(WriteDataM),
        .RdM(RdM),
        .PCPlus4M(PCPlus4M)
    );
    DataMemory dataMemory(
        .clk(clk),
        .WE(MemWriteM),
        .A(ALUResultM),
        .WD(WriteDataM),
        .RD(ReadDataM)
    );


    wire [31:0] ALUResultW, ReadDataW, PCPlus4W;
    wire [4:0] RdW;
    wire  MemWriteW;
    wire [1:0] ResultSrcW;


    //memory stage
    DataMemory_register dataMemory_register (
        .clk(clk),
        .clear(reset),
        .ALUResultM(ALUResultM),
        .ReadDataM(ReadDataM),
        .RdM(RdM),
        .PCPlus4M(PCPlus4M),
        .RegWriteM(RegWriteM),
        .ResultSrcM(ResultSrcM),
        .MemWriteM(MemWriteM),
        .ALUResultW(ALUResultW),
        .ReadDataW(ReadDataW),
        .RdW(RdW),
        .PCPlus4W(PCPlus4W),
        .RegWriteW(RegWriteW),
        .ResultSrcW(ResultSrcW),
        .MemWriteW(MemWriteW)
    );
    MuxResult muxResult(
        .ResultSrc(ResultSrcW),
        .ALUResult(ALUResultW),
        .RD(ReadDataW),
        .PCPlus4(PCPlus4),
        .Result(ResultW)
    );
endmodule
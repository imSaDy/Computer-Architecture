module DataPath(
    input clk,
    input reset,
    //controller inputs
    input MemWriteD,
    input RegWriteD,
    input ALUSrcD,
    input JumpD,
    input BranchD,
    input [2:0] ALUControlD,
    input [2:0] ImmSrcD,
    input [1:0] ResultSrcD,
    input LuiD,
    input JalrD,
    input StallD,StallF,FlushD,FlushE,
    input [1:0] ForwardAE,ForwardBE,
    output zero,
    output [2:0] func3,
    output [6:0] func7,
    output [6:0] opcode,
    output wire [4:0] Rs1D,Rs2D,Rs1E,Rs2E,RdE,RdM,RdW,
    output wire PCSrcE,
    output wire [1:0] ResultSrcE,
    output wire RegWriteM,RegWriteW
);
    wire [31:0] InstrD, PCD; 
    wire [31:0] PCNext;
    wire [31:0] PCPlus4; 
    wire [31:0] PCTarget, ImmExt;  
    wire [31:0] RD1, RD2;
    wire [31:0] SrcBE;
    wire [31:0] ALUResult; 
    wire [31:0] PCF,PCF_next;
    
    assign func3 = InstrD[14:12];
    assign func7 = InstrD[31:25];
    wire  [2:0] func3E;
    assign opcode = InstrD[6:0];
    wire [31:0] WriteDataE, PCTargetE;
    wire [31:0] PCPlus4F;
    wire [31:0] InstrF;
    wire JalrE, RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE,LuiE;
    wire [31:0] RD1D,RD2D;
    wire [31:0] ResultW;
    wire [4:0] RdD;
    assign Rs1D = InstrD [19:15];
    assign Rs2D = InstrD [24:20];
    assign RdD  = InstrD [11:7];
    wire [2:0] ALUControlE;
    wire [31:0] RD1E, RD2E, PCE, ImmExtE, PCPlus4E;
    wire [31:0] Lui_mux_output, ALUResultM,SrcAE; 
    wire [31:0] ALUResultE;
    wire [31:0] ReadDataM, PCPlus4M;
    wire MemWriteM;
    wire [1:0] ResultSrcM;
    wire [31:0] WriteDataM;
    wire [31:0] ALUResultW, ReadDataW, PCPlus4W;
    wire  MemWriteW;
    wire [1:0] ResultSrcW;
    wire [31:0] PCPlus4D;
    wire [31:0] Forwading_A_result;
    wire [31:0] ImmExtD;
    wire [31:0] Jalr_mux_output;
    wire HasBranchCondition;
    //fetch stage
    MuxPC muxPC(
        .PCSrc(PCSrcE),
        .PCPlus4(PCPlus4F),
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

    Fetch_register fetch_register(
        .clk(clk),
        .EN(StallD),
        .clear(FlushD),
        .InstrF(InstrF),
        .PCF(PCF),
        .PCPlus4F(PCPlus4F),
        .InstrD(InstrD),        
        .PCD(PCD),       
        .PCPlus4D(PCPlus4D)   
    );

    //decode stage
    RegisterFile registerFile(
        .clk(clk),
        .reset(reset),
        .WE3(RegWriteW),
        .A1(Rs1D),
        .A2(Rs2D),
        .A3(RdW),
        .WD3(ResultW),
        .RD1(RD1D),
        .RD2(RD2D)
    );
    Extend extend(
        .instr(InstrD),
        .ImmSrc(ImmSrcD),
        .ImmExt(ImmExtD)
    );


    // Instantiate Decode_register
    Decode_register decode_register (
        
        .clk(clk),
        .clear(FlushE),
        .JalrD(JalrD), 
        .RegWriteD(RegWriteD),
        .ResultSrcD(ResultSrcD),
        .MemWriteD(MemWriteD),
        .JumpD(JumpD), 
        .BranchD(BranchD),
        .ALUControlD(ALUControlD),
        .ALUSrcD(ALUSrcD),
        .RD1D(RD1D),
        .RD2D(RD2D),
        .PCD(PCD),
        .Rs1D(Rs1D),
        .Rs2D(Rs2D),
        .RdD(RdD),
        .ImmExtD(ImmExtD),
        .PCPlus4D(PCPlus4D),
        .LuiD(LuiD), 
        .funct3D(func3),
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
        .PCPlus4E(PCPlus4E),
        .LuiE(LuiE),
        .funct3E(func3E)  
    );
    

    Mux2to1 #(.WIDTH(32)) Lui_select (
        .b(32'b0),
        .a(RD1E),
        .sel(LuiE),
        .y(Lui_mux_output)
    );
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
    Mux2to1 #(.WIDTH(32)) Jalr_mux(
        .a(PCE),
        .b(RD1E),
        .sel(JalrE),
        .y(Jalr_mux_output)
    );
    Mux2to1 #(.WIDTH(32)) SrcB_selector (
        .a(WriteDataE),
        .b(ImmExtE),
        .sel(ALUSrcE),
        .y(SrcBE)
    );
    AdderPCTarget adderPCTarget(
        .PC(Jalr_mux_output),
        .ImmExt(ImmExtE),
        .PCTarget(PCTargetE)
    );
    ALU alu(
        .SrcA(SrcAE),
        .SrcB(SrcBE),
        .ALUControl(ALUControlE),
        .zero(zero),
        .ALUResult(ALUResultE)
    );

    Mux2to1 #(.WIDTH(1)) Beq_mux(
        .a(zero),
        .b(~zero),
        .sel(func3E == 3'b001),
        .y(HasBranchCondition)
    );
    wire AcceptBranch;
    assign AcceptBranch = BranchE & HasBranchCondition;  
    assign PCSrcE = JumpE |  AcceptBranch; 

    //write Back stage

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
        .PCPlus4(PCPlus4W),
        .Result(ResultW)
    );
endmodule
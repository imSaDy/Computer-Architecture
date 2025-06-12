module TopModule (
    input clk,
    input reset
);
  // Internal wires for interconnecting modules
  wire MemWriteD, RegWriteD, ALUSrcD, JumpD, BranchD, LuiD, JalrD;
  wire [2:0] ALUControlD, ImmSrcD;
  wire [1:0] ResultSrcD;
  wire [2:0] func3;
  wire [6:0] func7, opcode;
  wire zero;
  wire [4:0] Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW;
  wire PCSrcE;
  wire [1:0] ResultSrcE;
  wire RegWriteM, RegWriteW;
  wire StallF, StallD, FlushD, FlushE;
  wire [1:0] ForwardAE, ForwardBE;
  wire PCSrcD;
  // Controller instance
  Controller controller_inst (
      .op(opcode),
      .funct3(func3),
      .funct7(func7[5]),
      .Zero(zero),
      .RegWriteD(RegWriteD),
      .MemWriteD(MemWriteD),
      .ResultSrc(ResultSrcD),
      .ALUSrcD(ALUSrcD),
      .ALUControlD(ALUControlD),
      .ImmSrcD(ImmSrcD),
      .JalrD(JalrD),
      .PCSrcD(PCSrcD),
      .LuiD(LuiD),
      .JumpD(JumpD),
      .BranchD(BranchD)
  );

  // Hazard Unit instance
  HazardUnit hazard_unit_inst (
      .RegWriteM(RegWriteM),
      .RegWriteW(RegWriteW),
      .ResultSrcE(ResultSrcE),
      .Rs1D(Rs1D),
      .Rs2D(Rs2D),
      .Rs1E(Rs1E),
      .Rs2E(Rs2E),
      .RdE(RdE),
      .RdM(RdM),
      .RdW(RdW),
      .PCSrcE(PCSrcE),
      .StallF(StallF),
      .StallD(StallD),
      .FlushD(FlushD),
      .FlushE(FlushE),
      .ForwardAE(ForwardAE),
      .ForwardBE(ForwardBE)
  );

  // DataPath instance
  DataPath datapath_inst (
      .clk(clk),
      .reset(reset),
      .MemWriteD(MemWriteD),
      .RegWriteD(RegWriteD),
      .ALUSrcD(ALUSrcD),
      .JumpD(JumpD),
      .BranchD(BranchD),
      .ALUControlD(ALUControlD),
      .ImmSrcD(ImmSrcD),
      .ResultSrcD(ResultSrcD),
      .LuiD(LuiD),
      .JalrD(JalrD),
      .StallD(StallD),
      .StallF(StallF),
      .FlushD(FlushD),
      .FlushE(FlushE),
      .ForwardAE(ForwardAE),
      .ForwardBE(ForwardBE),
      .zero(zero),
      .func3(func3),
      .func7(func7),
      .opcode(opcode),
      .Rs1D(Rs1D),
      .Rs2D(Rs2D),
      .Rs1E(Rs1E),
      .Rs2E(Rs2E),
      .RdE(RdE),
      .RdM(RdM),
      .RdW(RdW),
      .PCSrcE(PCSrcE),
      .ResultSrcE(ResultSrcE),
      .RegWriteM(RegWriteM),
      .RegWriteW(RegWriteW)
  );

endmodule

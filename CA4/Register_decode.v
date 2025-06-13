module Decode_register (
    input wire clk,
    input wire clear,
    input wire JalrD,
    input wire RegWriteD,
    input wire [1:0] ResultSrcD,
    input wire MemWriteD,
    input wire JumpD,
    input wire BranchD,
    input wire [2:0] ALUControlD,
    input wire ALUSrcD,
    input wire [31:0] RD1D,
    input wire [31:0] RD2D,
    input wire [31:0] PCD,
    input wire [4:0] Rs1D,
    input wire [4:0] Rs2D,
    input wire [4:0] RdD,
    input wire [31:0] ImmExtD,
    input wire LuiD,
    input wire [31:0] PCPlus4D,
    input wire [2:0] funct3D,
    output reg JalrE,
    output reg RegWriteE,
    output reg [1:0] ResultSrcE,
    output reg MemWriteE,
    output reg JumpE,
    output reg BranchE,
    output reg [2:0] ALUControlE,
    output reg ALUSrcE,
    output reg [31:0] RD1E,
    output reg [31:0] RD2E,
    output reg [31:0] PCE,
    output reg [4:0] Rs1E,
    output reg [4:0] Rs2E,
    output reg [4:0] RdE,
    output reg [31:0] ImmExtE,
    output reg [31:0] PCPlus4E,
    output reg LuiE,
    output reg [2:0] funct3E
);
assign {JalrE, RegWriteE, ResultSrcE, MemWriteE, JumpE, BranchE, ALUControlE, ALUSrcE,
 RD1E, RD2E, PCE, Rs1E, Rs2E, RdE, ImmExtE, PCPlus4E, LuiE, funct3E} = 0;
always @(posedge clk) begin
    if (clear) begin
        JalrE        <= 1'b0;
        RegWriteE    <= 1'b0;
        ResultSrcE   <= 2'b0;
        MemWriteE    <= 1'b0;
        JumpE        <= 1'b0;
        BranchE      <= 1'b0;
        ALUControlE  <= 3'b0;
        ALUSrcE      <= 1'b0;
        RD1E         <= 32'b0;
        RD2E         <= 32'b0;
        PCE         <= 32'b0;
        Rs1E         <= 5'b0;
        Rs2E         <= 5'b0;
        RdE          <= 5'b0;
        ImmExtE      <= 32'b0;
        PCPlus4E     <= 32'b0;
        funct3E      <= 3'b0;
        LuiE         <= 1'b0;
    end else begin
        JalrE        <= JalrD;
        RegWriteE    <= RegWriteD;
        ResultSrcE   <= ResultSrcD;
        MemWriteE    <= MemWriteD;
        JumpE        <= JumpD;
        BranchE      <= BranchD;
        ALUControlE  <= ALUControlD;
        ALUSrcE      <= ALUSrcD;
        RD1E         <= RD1D;
        RD2E         <= RD2D;
        PCE          <= PCD;
        Rs1E         <= Rs1D;
        Rs2E         <= Rs2D;
        RdE          <= RdD;
        ImmExtE      <= ImmExtD;
        PCPlus4E     <= PCPlus4D;
        funct3E      <= funct3D;
        LuiE         <= LuiD;

    end
end

endmodule

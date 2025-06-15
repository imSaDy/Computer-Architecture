module DataMemory_register (
    input wire        clk,
    input wire        clear,
    input wire [31:0] ALUResultM,
    input wire [31:0] ReadDataM,
    input wire [4:0]  RdM,
    input wire [31:0] PCPlus4M,
    input wire        RegWriteM,
    input wire        MemWriteM,
    input wire [1:0]  ResultSrcM,

    output reg [31:0] ALUResultW,
    output reg [31:0] ReadDataW,
    output reg [4:0]  RdW,
    output reg [31:0] PCPlus4W,
    output reg        RegWriteW,
    output reg [1:0]  ResultSrcW,
    output reg        MemWriteW
);

    initial begin
        ALUResultW = 32'b0;
        ReadDataW  = 32'b0;
        RdW        = 5'b0;
        PCPlus4W   = 32'b0;
        RegWriteW  = 1'b0;
        ResultSrcW = 2'b0;
        MemWriteW  = 1'b0;
    end

    always @(posedge clk) begin
        if (clear) begin
            ALUResultW <= 32'b0;
            ReadDataW  <= 32'b0;
            RdW        <= 5'b0;
            PCPlus4W   <= 32'b0;
            RegWriteW  <= 1'b0;
            ResultSrcW <= 2'b0;
            MemWriteW  <= 1'b0;
        end else begin
            ALUResultW <= ALUResultM;
            ReadDataW  <= ReadDataM;
            RdW        <= RdM;
            PCPlus4W   <= PCPlus4M;
            RegWriteW  <= RegWriteM;
            ResultSrcW <= ResultSrcM;
            MemWriteW  <= MemWriteM;
        end
    end

endmodule
module MuxResult(
    input [1:0] ResultSrc,
    input [31:0] ALUResult, 
    input [31:0] RD, 
    input [31:0] PCPlus4,
    output reg [31:0] Result
);
    always @(*) begin
        case (ResultSrc)
            2'b00: Result = ALUResult;
            2'b01: Result = RD;
            2'b10: Result = PCPlus4; 
            default: Result = 32'b0;
        endcase
    end
endmodule
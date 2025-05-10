module MuxPC(
    input [1:0] PCSrc,
    input [31:0] PCPlus4,
    input [31:0] PCTarget,
    input [31:0] ALUResult,
    output reg [31:0] PCNext
);
    always @(*) begin
        case (PCSrc)
            2'b00: PCNext = PCPlus4;
            2'b01: PCNext = PCTarget;
            2'b11: PCNext = ALUResult;
            default: PCNext = 32'b0; 
        endcase
    end
endmodule
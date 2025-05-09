module ALU(
    input [31:0] SrcA,
    input [31:0] SrcB,
    input [2:0] ALUControl,
    output zero,
    output reg [31:0] ALUResult
);
    always @(ALUControl, SrcA, SrcB) begin
        case (ALUControl)
            3'b000: ALUResult = SrcA + SrcB;
            3'b001: ALUResult = SrcA - SrcB; 
            3'b010: ALUResult = SrcA & SrcB;
            3'b011: ALUResult = SrcA | SrcB;
            3'b100: ALUResult = ($signed(SrcA) < $signed(SrcB));
            default: ALUResult = 32'b0;
        endcase
    end

    assign zero = (ALUResult == 0); 
endmodule
module ALU(
    input [7:0] SrcA,
    input [7:0] SrcB,
    input [1:0] ALUControl,
    output zero,
    output reg [7:0] ALUResult
);
    always @(ALUControl, SrcA, SrcB) begin
        case (ALUControl)
            2'b00: ALUResult = SrcA + SrcB;
            2'b01: ALUResult = SrcA - SrcB; 
            2'b10: ALUResult = SrcA & SrcB;
            2'b11: ALUResult = ~ SrcA;
            default: ALUResult = 8'b0;
        endcase
    end

    assign zero = (ALUResult == 0); 
endmodule
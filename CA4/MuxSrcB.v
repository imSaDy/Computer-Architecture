module MuxSrcB(
    input [31:0] RD2,
    input [31:0] ImmExt,
    input ALUSrc,
    output reg [31:0] SrcB
);
    always @(*) begin
        case (ALUSrc)
            1'b0: SrcB = RD2; 
            1'b1: SrcB = ImmExt;
            default: SrcB = 32'b0;
        endcase
    end
endmodule
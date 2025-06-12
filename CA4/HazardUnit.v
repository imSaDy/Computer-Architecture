module HazardUnit(
    input RegWriteM,
    input RegWriteW,
    input [1:0] ResultSrcE, ResultSrcM, ResultSrcW,
    input [4:0] Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW,
    input PCSrcE,
    output StallF, StallD, FlushD, FlushE,
    output [1:0] ForwardAE, ForwardBE
);
    wire lwStall; 
    assign ForwardAE = (Rs1E == RdM && RegWriteM && Rs1E != 0) ? 2'b10 : 
                       (Rs1E == RdW && RegWriteW && Rs1E != 0) ? 2'b01 : 2'b00;
    assign ForwardBE = (Rs2E == RdM && RegWriteM && Rs2E != 0) ? 2'b10 : 
                       (Rs2E == RdW && RegWriteW && Rs2E != 0) ? 2'b01 : 2'b00;                       
    assign lwStall = (ResultSrcE[0] == 1'b1 && (Rs1D == RdE || Rs2D == RdE));
    assign StallF = lwStall;
    assign StallD = lwStall;
    assign FlushD = PCSrcE; 
    assign FlushE = (PCSrcE == 1'b1 || lwStall == 1'b1);
endmodule
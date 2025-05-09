module RegisterFile(
    input clk,
    input reset, 
    input WE, 
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD3,
    output [31:0] RD1, 
    output [31:0] RD2
);
    reg [31:0] register [0:31];
    integer i; 

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1)
                register[i] <= 32'b0; 
        end
        else if (WE)
            register[A3] <= WD3; 
    end

    assign register[0] = 32'b0; 
    assign RD1 = register[A1];
    assign RD2 = register[A2];
endmodule
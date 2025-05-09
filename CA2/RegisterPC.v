module RegisterPC(
    input clk, reset,
    input [31:0] PCNext,
    output reg [31:0] PC
);
    always @(posedge clk, posedge reset) begin
        if (reset)
            PC <= 32'd0; 
        else 
            PC <= PCNext; 
    end
endmodule
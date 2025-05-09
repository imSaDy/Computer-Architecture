module RegisterPC(
    input clk, reset,
    input [31:0] PCInput,
    output reg [31:0] PC
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            PC <= 32'd0; 
        else 
            PC <= PCInput; 
    end
endmodule
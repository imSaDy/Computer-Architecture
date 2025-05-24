module RegisterPC(
    input clk, reset, enable,
    input [4:0] PCNext,
    output reg [4:0] PC
);
    initial begin
        PC = 5'd0;
    end

    always @(posedge clk, posedge reset) begin
        if (reset)
            PC <= 5'd0; 
        else if (enable)
            PC <= PCNext; 
    end
endmodule
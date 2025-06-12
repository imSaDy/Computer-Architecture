module RegisterPC(
    input clk, reset, EN,
    input [31:0] PCNext,
    output reg [31:0] PC
);
    initial begin
        PC = 32'd0;
    end

    always @(posedge clk, negedge reset) begin
        if (!reset)
            PC <= 32'd0; 
        else if (!EN)
            PC <= PCNext; 
    end
endmodule
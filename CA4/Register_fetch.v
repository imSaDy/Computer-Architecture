module Fetch_register (
    input wire clk,
    input wire EN,
    input wire clear,
    input wire [31:0] InstrF,
    input wire [31:0] PCF,
    input wire [31:0] PCPlus4F,
    output reg [31:0] FD,
    output reg [31:0] PCD,
    output reg [31:0] PCPlus4D
);

always @(posedge clk) begin
    if (clear) begin
        FD        <= 32'b0;
        PCD       <= 32'b0;
        PCPlus4D  <= 32'b0;
    end else if (!EN) begin
        FD        <= InstrF;
        PCD       <= PCF;
        PCPlus4D  <= PCPlus4F;
    end
end
endmodule

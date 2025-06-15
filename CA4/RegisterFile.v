module RegisterFile(
    input clk,
    input reset, 
    input WE3, 
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD3,
    output [31:0] RD1, 
    output [31:0] RD2
);
    reg [31:0] register [0:31];
    integer i; 

    initial begin
        register[0] = 32'd0;
    end

    always @(negedge clk, posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1)
                register[i] <= 32'b0; 
        end
        else if (WE3 && (A3 != 5'd0))
            register[A3] <= WD3; 
    end

    assign RD1 = (A1 == 5'd0) ? 32'd0 : register[A1];
    assign RD2 = (A2 == 5'd0) ? 32'd0 : register[A2];
endmodule
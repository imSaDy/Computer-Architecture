module Register #(
    parameter WIDTH = 8  
)(
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [WIDTH-1:0] d_in,
    output reg [WIDTH-1:0] d_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            d_out <= {WIDTH{1'b0}};  
        end else if (enable) begin  
            d_out <= d_in;
        end
    end

endmodule
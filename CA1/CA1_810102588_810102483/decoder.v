module decoder #(parameter SIZE = 4)(
    input [SIZE - 1:0] in,
    output reg [(1 << SIZE) - 1:0] out 
);
    always @(*) begin
        out = {(1 << SIZE){1'b0}}; 
        out[in] = 1'b1;           
    end
endmodule
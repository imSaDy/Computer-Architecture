module Stack #(parameter WIDTH = 8, DEPTH = 128) (
    input wire clk,
    input wire reset,
    input wire push,
    input wire pop,
    input wire tos,
    input wire [WIDTH-1:0] d_in,
    output reg [WIDTH-1:0] d_out
);

    reg [WIDTH-1:0] stack_mem [0:DEPTH-1];
    reg [$clog2(DEPTH):0] sp; // Stack pointer

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sp <= 0;
        end else begin
            if (push && sp < DEPTH) begin
                stack_mem[sp] <= d_in;
                sp <= sp + 1;
            end else if (pop && sp > 0) begin
                sp <= sp - 1;
                d_out <=stack_mem[sp -1];
            end else if (tos) begin 
                d_out <= stack_mem[sp -1];
            end
            
        end
    end
endmodule

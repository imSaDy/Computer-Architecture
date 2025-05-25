module mux2to1 #(parameter WIDTH = 8) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    input  sel,
    output [WIDTH-1:0] y
);
    assign y = sel ? b : a;
endmodule


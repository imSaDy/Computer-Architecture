module Adder #(parameter SIZE = 8) (a, b, sum);
    input [SIZE - 1:0] a, b;
    output [SIZE - 1:0] sum;
    assign sum = a + b;
endmodule
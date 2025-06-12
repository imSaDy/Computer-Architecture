module mux #(parameter SIZE = 1, parameter NUM_INPUTS = 2)(
    input [SIZE * NUM_INPUTS - 1:0] inputs, 
    input [$clog2(NUM_INPUTS) - 1:0] sel,
    output [SIZE - 1:0] out
);
    assign out = inputs[SIZE * sel +: SIZE]; 
endmodule
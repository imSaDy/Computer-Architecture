`timescale 1ns/1ns

module TopModule_tb;
    reg clk;
    reg reset;

    TopModule uut (
        .clk(clk),
        .reset(reset)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;
        #10;
        reset = 0;

        #1000;
        $stop;
    end

endmodule
`timescale 1ns / 1ns

module Topmodule_tb;
    reg clk;
    reg reset;
    TopModule uut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;
    initial begin
        clk = 0;
        #40000;
        $stop;
    end
    initial begin
        $monitor("Time: %0t | Reset: %b | Opcode: %b | Func3: %b | Func7: %b | Zero: %b", 
                 $time, reset, uut.opcode, uut.func3, uut.func7, uut.zero);
    end

endmodule
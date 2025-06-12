`timescale 1ns / 1ns
module Topmodule_tb();
    reg clk;
    reg load_memory;
    reg reset;
    reg start;
    reg run;
    wire done;
    wire fail;
    wire [1:0] move;
    wire end_iteration;
    wire rd, wr, Din, Dout; 
    wire [3:0] memory_x_input, memory_y_input;
    topmodule uut (
        .clk(clk),
        .load_memory(load_memory),
        .reset(reset),
        .start(start),
        .run(run),
        .done(done),
        .fail(fail),
        .move(move),
        .end_iteration(end_iteration),
        .rd(rd), 
        .wr(wr),
        .Din(Din), 
        .Dout(Dout),
        .memory_x_input(memory_x_input),
        .memory_y_input(memory_y_input)
    );
    memory2 mem_inst (
        .clk(clk),
        .rd(rd),
        .wr(wr),
        .data_in(Din),
        .col(memory_x_input[3:0]),
        .row(memory_y_input[3:0]),
        .data_out(Dout),
        .rst(reset)
    );
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    initial begin
        $dumpfile("Topmodule_tb.vcd");
        $dumpvars(0, Topmodule_tb);
        load_memory = 0;
        reset = 0;
        start = 0;
        run = 0;
        #10 reset = 1;
        #10 reset = 0;
        #10 load_memory = 1;
        #10 load_memory = 0;
        #10 start = 1;
        #10 start = 0;
        wait(done);
        #20 run = 1;
        #10 run=0;
        @(posedge end_iteration)
        #20 $stop;
    end
    initial begin
        $monitor("Time: %0t | reset: %b | start: %b | run: %b | done: %b | fail: %b | move: %b | end: %b", 
                 $time, reset, start, run, done, fail, move,end_iteration);
    end

endmodule
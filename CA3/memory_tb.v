// filepath: /home/wren/D/1S4/CA/CA/CA3/memory_tb.v
`timescale 1ns/1ns

module memory_tb;

    reg clk;
    reg WE;
    reg [4:0] A;
    reg [7:0] WD;
    wire [7:0] RD;

    // Instantiate the Memory module
    Memory uut (
        .clk(clk),
        .WE(WE),
        .A(A),
        .WD(WD),
        .RD(RD)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period
    end

    initial begin
        // Initialize inputs
        WE = 0;
        A = 0;
        WD = 0;

        // Wait for memory initialization
        #10;

        // Test 1: Read from address 0 (should reflect initial value from DataMemory.mem)
        A = 0;
        WE = 0;
        #10;
        $display("Read Addr 0: RD = %b", RD);

        // Test 2: Write 8'b10101010 to address 5
        A = 5;
        WD = 8'b10101010;
        WE = 1;
        #10;

        // Test 3: Read back from address 5
        WE = 0;
        #10;
        $display("Read Addr 5: RD = %b (should be 10101010)", RD);

        // Test 4: Write 8'b11110000 to address 10
        A = 10;
        WD = 8'b11110000;
        WE = 1;
        #10;

        // Test 5: Read back from address 10
        WE = 0;
        #10;
        $display("Read Addr 10: RD = %b (should be 11110000)", RD);

        // Test 6: Read from an unwritten address (e.g., 20)
        A = 20;
        WE = 0;
        #10;
        $display("Read Addr 20: RD = %b (should be initial value)", RD);

        $stop;
    end

endmodule
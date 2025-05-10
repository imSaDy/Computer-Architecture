`timescale 1ns / 1ps

module InstructionMemory_tb;

    // Inputs
    reg [31:0] address;

    // Outputs
    wire [31:0] instruction;

    // Instantiate the Unit Under Test (UUT)
    InstructionMemory uut (
        .PC(address),
        .instr(instruction)
    );

    initial begin
        // Initialize Inputs
        address = 0;

        // Wait for global reset
        #10;

        // Test case 1
        address = 32'h00000000;
        #10;
        $display("Address: %h, Instruction: %h", address, instruction);

        // Test case 2
        address = 32'h00000004;
        #10;
        $display("Address: %h, Instruction: %h", address, instruction);

        // Test case 3
        address = 32'h00000008;
        #10;
        $display("Address: %h, Instruction: %h", address, instruction);

        // Test case 4
        address = 32'h0000000C;
        #10;
        $display("Address: %h, Instruction: %h", address, instruction);

        // Finish simulation
        $stop;
    end

endmodule
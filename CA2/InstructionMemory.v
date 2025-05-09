module InstructionMemory(
    input [31:0] PC,
    output [31:0] instr
);
    reg [7:0] instrMemory [0:$pow(2, 16) - 1];
    wire [31:0] address;

    initial begin
        $readmem("InstructionMemory.mem", instrMemory); 
    end

    assign address = {PC[31:2], 2'b00}; 
    assign instr = {instrMemory[address + 3], instrMemory[address + 2], instrMemory[address + 1], instrMemory[address]};
endmodule
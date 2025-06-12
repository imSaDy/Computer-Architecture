module InstructionMemory(
    input [31:0] PC,
    output [31:0] instr
);
reg [7:0] instrMemory [0:65536];
    wire [31:0] address;

    initial begin
        $readmemh("InstructionMemory.mem", instrMemory); 
    end

    assign address = {PC[31:2], 2'b00}; 
    assign instr = {instrMemory[address], 
                    instrMemory[address + 1], 
                    instrMemory[address + 2], 
                    instrMemory[address + 3]};
endmodule
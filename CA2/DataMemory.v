module DataMemory(
    input clk,
    input WE,
    input [31:0] A,
    input [31:0] WD,
    output reg [31:0] RD 
);
    reg [7:0] dataMemory [0:$pow(2, 16) - 1];
    reg [31:0] address;

    assign address = {A[31:2], 2'b00};

    initial begin
        $readmem("DataMemory.mem", dataMemory); 
    end

    always @(posedge clk) begin
        if (WE)
            {dataMemory[address + 3], dataMemory[address + 2], dataMemory[address + 1], dataMemory[address]} = WD; 
    end
    always @(*) begin
        RD = {dataMemory[address + 3], dataMemory[address + 2], dataMemory[address + 1], dataMemory[address]}; 
    end
endmodule
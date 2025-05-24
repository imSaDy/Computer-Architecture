module Memory(
    input clk,
    input WE,
    input [4:0] A,
    input [7:0] WD,
    output reg [7:0] RD 
);
    reg [7:0] dataMemory [0:32];
    wire [4:0] address;

    assign address = {A[4:2], 2'b00};

    initial begin
        $readmemh("DataMemory.mem", dataMemory); 
    end

    always @(posedge clk) begin
        if (WE)
            {dataMemory[address], 
             dataMemory[address + 1],
             dataMemory[address + 2], 
             dataMemory[address + 3]} = WD; 
    end
    always @(*) begin
        RD = {dataMemory[address], 
              dataMemory[address + 1], 
              dataMemory[address + 2], 
              dataMemory[address + 3]}; 
    end
endmodule
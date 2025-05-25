module Memory(
    input clk,
    input WE,
    input [4:0] A,
    input [7:0] WD,
    output reg [7:0] RD 
);
    reg [7:0] dataMemory [0:31];


    initial begin
        $readmemb("DataMemory.mem", dataMemory); 
    end

    always @(posedge clk) begin
        if (WE)
            dataMemory[A] <= WD; 
    end
    always @(*) begin
        RD = dataMemory[A]; 
    end
endmodule
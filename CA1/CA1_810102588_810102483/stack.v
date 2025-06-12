module stack (clk, rst, push, pop, data_in, data_out, empty);
    input clk, rst, push, pop;
    input [1:0] data_in;
    output [1:0] data_out;
    output empty;

    reg [1:0] memory [0:255];
    reg [7:0] top_pointer;

    always @(posedge clk or posedge rst) begin
        if (rst)
            top_pointer <= 0;
        else begin
            if (push) begin
                memory[top_pointer] <= data_in;
                top_pointer <= top_pointer + 1;
            end 
            else if (pop && !empty) 
                top_pointer <= top_pointer - 1;
        end
    end

    assign data_out = (top_pointer > 0) ? memory[top_pointer - 1] : 1'bz;
    assign empty = (top_pointer == 0);
endmodule

module queue (clk, rst, enqueue, dequeue, data_in, data_out, empty, full, size);
    input clk, rst, enqueue, dequeue;
    input [1:0] data_in;
    output [1:0] data_out;
    output empty, full;
    output reg [7:0] size;
    
    reg [1:0] mem [255:0];
    reg [7:0] head, tail;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 0;
            tail <= 0;
            size <= 0;
        end else begin
            if (enqueue && !full) begin
                mem[tail] <= data_in;
                tail <= tail + 1;
                size <= size + 1;
            end

            if (dequeue && !empty) begin
                head <= head + 1;
                size <= size - 1;
            end
        end
    end
    assign empty = (size == 0);
    assign full = (size == 256);
    assign data_out = (empty ? 2'b00 : mem[head]);
endmodule

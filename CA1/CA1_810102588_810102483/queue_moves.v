module queue_logger (clk,dequeue,queue_data);
    input clk,dequeue;
    input [1:0] queue_data;
    integer logfile;

    initial begin
        logfile = $fopen("moves.txt", "w");
    end

    always @(posedge clk) begin
        
        if (dequeue) begin
            if (queue_data==2'b00)begin
                $fwrite(logfile, "U");
            end
            if (queue_data==2'b01)begin
                $fwrite(logfile, "R");
            end
            if (queue_data==2'b10)begin
                $fwrite(logfile, "L");
            end
            if (queue_data==2'b11)begin
                $fwrite(logfile, "D");
            end
        end
    end

endmodule

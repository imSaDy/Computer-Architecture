module memory2 (clk, rd, wr, data_in, row, col, data_out, rst);
    input clk, rd, wr, data_in, rst; 
    input [3:0] row, col;
    output wire data_out; 

    reg [15:0] grid [0:15]; 

    initial begin 
        $readmemb( "memory.txt" ,grid);
    end

    always @(posedge clk, posedge rst) begin
        if (rst)
            $readmemb( "memory.txt" ,grid); 
        else if (wr)
            grid[row][15 - col] = data_in;
    end

    assign data_out = (rd ? grid[row][15 - col] : 1'bz); 
endmodule
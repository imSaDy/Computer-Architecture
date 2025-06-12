module Counter #(parameter SIZE = 8)(clk, rst, cnt_en, ld_en, ld, out);
    input  clk, rst, cnt_en, ld_en;
    input  [SIZE - 1:0] ld;
    output reg [SIZE - 1:0] out;

    always @(posedge clk or posedge rst) begin
        if (rst)
            out <= 0;
        else if (ld_en) 
            out <= ld;
        else if (cnt_en) 
            out <= out + 1;
        
    end

endmodule


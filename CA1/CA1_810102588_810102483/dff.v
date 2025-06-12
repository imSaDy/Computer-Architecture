module dff (
    input clk,             
    input en,              
    input  data_in,   
    output reg data_out,
    input rst  
);
    always @(posedge clk) begin
        if (rst) begin
            data_out <= 0;
        end else if (en) begin
            data_out <= data_in;  
        end
    end
endmodule
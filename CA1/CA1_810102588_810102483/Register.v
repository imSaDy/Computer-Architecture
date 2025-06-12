module Register #(parameter SIZE = 4)(clk, rst, enable, data_in, data_out);
    input  clk, rst, enable;
    input [SIZE - 1:0] data_in;
    output wire [SIZE - 1:0] data_out;
    genvar i;
    generate
        for (i = 0; i < SIZE; i = i + 1) begin : dff_array
            dff dff_inst (
                .clk(clk),
                .rst(rst),
                .en(enable),
                .data_in(data_in[i]),
                .data_out(data_out[i])
            );
        end
    endgenerate

endmodule

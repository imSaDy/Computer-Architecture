module Datapath (
    input wire clk,
    input wire reset,
    input wire [31:0] instruction,
    input wire [31:0] read_data,
    output wire [31:0] pc,
    output wire [31:0] alu_result,
    output wire [31:0] write_data,
    output wire mem_write
);

    // Internal signals
    wire [31:0] pc_next, pc_plus4, pc_branch;
    wire [31:0] sign_imm, src_a, src_b, result;
    wire [4:0] write_reg;
    wire zero, branch, alu_src, reg_write, mem_to_reg;

    // Program Counter
    reg [31:0] pc_reg;
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc_reg <= 32'b0;
        else
            pc_reg <= pc_next;
    end
    assign pc = pc_reg;

    // PC Increment
    assign pc_plus4 = pc_reg + 4;

    // Instruction Decode
    wire [5:0] opcode = instruction[31:26];
    wire [4:0] rs = instruction[25:21];
    wire [4:0] rt = instruction[20:16];
    wire [4:0] rd = instruction[15:11];
    wire [15:0] imm = instruction[15:0];

    // Control Unit (simplified for demonstration)
    ControlUnit control_unit (
        .opcode(opcode),
        .branch(branch),
        .alu_src(alu_src),
        .reg_write(reg_write),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg)
    );

    // Sign Extend
    assign sign_imm = {{16{imm[15]}}, imm};

    // Register File
    RegisterFile reg_file (
        .clk(clk),
        .reg_write(reg_write),
        .rs(rs),
        .rt(rt),
        .rd(write_reg),
        .write_data(result),
        .read_data1(src_a),
        .read_data2(write_data)
    );

    // ALU
    assign src_b = alu_src ? sign_imm : write_data;
    ALU alu (
        .src_a(src_a),
        .src_b(src_b),
        .alu_control(3'b010), // Example: ADD operation
        .result(alu_result),
        .zero(zero)
    );

    // Branch Address Calculation
    assign pc_branch = pc_plus4 + (sign_imm << 2);

    // PC Selection
    assign pc_next = branch & zero ? pc_branch : pc_plus4;

    // Write Back
    assign result = mem_to_reg ? read_data : alu_result;
    assign write_reg = reg_write ? rd : rt;

endmodule
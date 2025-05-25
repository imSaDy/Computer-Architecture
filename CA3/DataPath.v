module Datapath(
    input clk,
    input reset,
    input PCWrite,
    input AdrSrc,
    input IRWrite,
    input push,
    input pop,
    input tos,
    input stw1,stw2,
    input WE,
    input [1:0] ALUSrcA,ALUSrcB,
    input wire [1:0] ALUOp,
    input [1:0] ResultSrc,
    output wire [7:0] Instr,
    output wire zero

    );
    wire [4:0] PC, PCNext;
    wire [7:0] SrcA, SrcB, ALUResult, RD;
    
    wire [4:0] Adr;
    wire [7:0] stack_reg_out1, stack_reg_out2;
    wire [7:0] Result;

    RegisterPC registerPC_inst(
        .clk(clk),
        .reset(reset),
        .enable(PCWrite),  
        .PCNext(PCNext),
        .PC(PC)
    );

    wire [4:0] mux_out;
    mux2to1 #(.WIDTH(5)) mux_memory_adress(
        .a(PC),
        .b(Instr[4:0]),
        .sel(AdrSrc),
        .y(Adr)
    );

    Memory data_instruction_memory(
        .clk(clk),
        .WE(WE),
        .A(Adr),
        .WD(stack_reg_out2),
        .RD(RD)
    );

    wire [4:0] OldPC;
    Register #(.WIDTH(8)) reg_instruction(
        .clk(clk),
        .reset(reset),
        .enable(IRWrite), 
        .d_in(RD),
        .d_out(Instr)
    );

    Register #(.WIDTH(5)) reg_oldPC(
        .clk(clk),
        .reset(reset),
        .enable(IRWrite), 
        .d_in(PC),
        .d_out(OldPC)
    );

    wire [7:0] Data;
    Register #(.WIDTH(8)) data_register(
        .clk(clk),
        .reset(reset),
        .enable(1'b1), 
        .d_in(RD),
        .d_out(Data)
    );

    wire [7:0] stack_data_in, stack_data_out;
    Stack #(.WIDTH(8), .DEPTH(128)) stack_inst(
        .clk(clk),
        .reset(reset),
        .push(push),
        .pop(pop),
        .tos(tos),
        .d_in(Result),
        .d_out(stack_data_out)
    );

    Register #(.WIDTH(8)) reg_stack1(
        .clk(clk),
        .reset(reset),
        .enable(stw1), 
        .d_in(stack_data_out),
        .d_out(stack_reg_out1)  
    );

    Register #(.WIDTH(8)) reg_stack2(
        .clk(clk),
        .reset(reset),
        .enable(stw2), 
        .d_in(stack_data_out),
        .d_out(stack_reg_out2)
    );

    mux4to1 #(.WIDTH(8)) SrcA_Mux(
        .in0({3'b000, PC}), 
        .in1({3'b000, OldPC}), 
        .in2(stack_reg_out1), 
        .in3(8'b0), 
        .sel(ALUSrcA), 
        .out(SrcA)
    );

    mux4to1 #(.WIDTH(8)) SrcB_Mux(
        .in0(stack_reg_out2),
        .in1(8'b0),
        .in2({3'b000, Instr[4:0]}),
        .in3(8'd1),
        .sel(ALUSrcB),
        .out(SrcB)
    );

    ALU alu_inst(
        .SrcA(SrcA),
        .SrcB(SrcB),
        .ALUControl(ALUOp),
        .zero(zero),
        .ALUResult(ALUResult)
    );

    wire [7:0] ALUOut;
    Register #(.WIDTH(8)) reg_alu_result(
        .clk(clk),
        .reset(reset),
        .enable(1'b1), 
        .d_in(ALUResult),
        .d_out(ALUOut)
    );

    mux4to1 #(.WIDTH(8)) ALU_Result_Mux(
        .in0(ALUOut),
        .in1(ALUResult),
        .in2(Data),
        .in3({3'b000, Instr[4:0]}),
        .sel(ResultSrc),
        .out(Result)
    );
endmodule
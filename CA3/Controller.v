module Controller (
    input wire clk,
    input wire reset,
    input zero,
    input [2:0] Instr,
    output reg WE,
    output reg AdrSrc,
    output reg PCWrite,
    output reg IRWrite,
    output reg tos,
    output reg pop,
    output reg push,
    output reg [1:0] ALUOp,
    output reg [1:0] ALUSrcA,
    output reg [1:0] ALUSrcB,
    output reg [1:0] ResultSrc,
    output reg stw1,stw2

);
    reg [4:0] ns,ps;

    parameter [4:0]
        FETCH              = 5'd0,
        POP_FIRST          = 5'd1,
        POP_SECOND         = 5'd2,
        R_WRITE_STACK2     = 5'd3,
        R_ALURESULT        = 5'd4,
        PUSH_RESULT        = 5'd5,
        WRITE_STACK1       = 5'd6,
        NOT_ALU_RESULT     = 5'd7,
        POP_WRITE_STACK2   = 5'd8,
        WRITE_MEMORY       = 5'd9,
        JUMP_PC_WRITE      = 5'd10,
        JUMPZ_TOS          = 5'd11,
        JUMPZ_STACK1       = 5'd12,
        JUMPZ_ALU_RESULT   = 5'd13,
        PUSH_GET_DATA      = 5'd14,
        PUSH_PUSH_DATA     = 5'd15;
    parameter [2:0]
        ADD  = 3'b000,
        SUB  = 3'b001,
        AND  = 3'b010,
        NOT  = 3'b011,
        PUSH = 3'b100,
        POP  = 3'b101,
        JMP  = 3'b110,
        JZ   = 3'b111;

    always @(posedge clk or posedge reset) begin
        if (reset)
            ps <= FETCH;
        else
            ps <= ns;
    end
    always @(ps) begin
        ns = FETCH;

        case (ps)
            FETCH: begin
                case (Instr)
                    ADD, SUB, AND, NOT, POP: ns <= POP_FIRST;
                    JMP:                     ns <= JUMP_PC_WRITE;
                    JZ:                      ns <= JUMPZ_TOS;
                    PUSH:                    ns <= PUSH_GET_DATA;
                endcase
            end

            POP_FIRST: begin
                case (Instr)
                    ADD, SUB, AND: ns <= POP_SECOND;
                    NOT:           ns <= WRITE_STACK1;
                    POP:           ns <= POP_WRITE_STACK2;
                endcase
            end

            POP_SECOND:       ns <= R_WRITE_STACK2;
            R_WRITE_STACK2:   ns <= R_ALURESULT;
            R_ALURESULT:      ns <= PUSH_RESULT;
            WRITE_STACK1:     ns <= NOT_ALU_RESULT;
            NOT_ALU_RESULT:   ns <= PUSH_RESULT;
            POP_WRITE_STACK2: ns <= WRITE_MEMORY;
            JUMPZ_TOS:        ns <= JUMPZ_STACK1;
            JUMPZ_STACK1:     ns <= JUMPZ_ALU_RESULT;
            PUSH_GET_DATA:    ns <= PUSH_PUSH_DATA;

            PUSH_PUSH_DATA,
            JUMPZ_ALU_RESULT,
            WRITE_MEMORY,
            PUSH_RESULT,
            JUMP_PC_WRITE:    ns <= FETCH;
        endcase
    end
    always @(ps, zero) begin
        {WE, AdrSrc, PCWrite, IRWrite, tos, pop, push, ALUOp, ALUSrcA, ALUSrcB, stw1, stw2} = 14'b0;

        case (ps)
            FETCH: begin
                {AdrSrc, IRWrite, PCWrite} = 3'b111;
                ALUSrcA    = 2'b00;
                ALUSrcB    = 2'b01;
                ALUOp      = 2'b00;
                ResultSrc  = 2'b01;
            end

            POP_FIRST: pop = 1'b1;

            POP_SECOND: begin
                pop  = 1'b1;
                stw1 = 1'b1;
            end

            R_WRITE_STACK2: stw2 = 1'b1;

            R_ALURESULT: begin
                ALUSrcA = 2'b10;
                ALUSrcB = 2'b00;
                case (Instr)
                    ADD: ALUOp = 2'b00;
                    SUB: ALUOp = 2'b01;
                    AND: ALUOp = 2'b10;
                endcase
            end

            PUSH_RESULT: begin
                push      = 1'b1;
                ResultSrc = 2'b00;
            end

            WRITE_STACK1: stw1 = 1'b1;

            NOT_ALU_RESULT: begin
                ALUSrcA = 2'b10;
                ALUOp   = 2'b11;
            end

            POP_WRITE_STACK2: stw2 = 1'b1;

            WRITE_MEMORY: begin
                AdrSrc = 1'b1;
                WE     = 1'b1;
            end

            JUMP_PC_WRITE: begin
                ResultSrc = 2'b11;
                PCWrite   = 1'b1;
            end

            JUMPZ_TOS: tos = 1'b1;

            JUMPZ_STACK1: stw1 = 1'b1;

            JUMPZ_ALU_RESULT: begin
                ALUOp     = 2'b01;
                ALUSrcB   = 2'b01;
                ALUSrcA   = 2'b10;
                ResultSrc = 2'b11;
                PCWrite   = (zero ? 1'b1 : 1'b0);
            end

            PUSH_GET_DATA: AdrSrc = 1'b1;

            PUSH_PUSH_DATA: begin
                ResultSrc = 2'b10;
                push      = 1'b1;
            end
        endcase
    end

endmodule


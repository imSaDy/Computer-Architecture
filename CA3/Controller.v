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
        DECODE             = 5'd1,
        SAVE_DATA_FOR_PUSH = 5'd2,
        PUSH_DATA_IN_STACK = 5'd3,
        SAVE_POP_DATA      = 5'd4,
        POP_STACK_SAVE_MEM = 5'd5,
        JUMP               = 5'd6,
        SAVE_TOP_STACK     = 5'd7,
        CHECK_TOP_ZERO     = 5'd8;

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
    always @(ps, zero) begin
        ns = FETCH;

        case (ps)
            FETCH: ns = DECODE;

            DECODE: begin
                case (Instr)
                    // ADD, SUB, AND, NOT, POP: ns = POP_FIRST;
                    // JMP:                     ns = JUMP_PC_WRITE;
                    // JZ:                      ns = JUMPZ_TOS;
                    JZ:                      ns = SAVE_TOP_STACK;
                    JMP:                     ns = JUMP;
                    PUSH:                    ns = SAVE_DATA_FOR_PUSH;
                    POP:                     ns = SAVE_POP_DATA;
                endcase
            end

            SAVE_DATA_FOR_PUSH:    ns = PUSH_DATA_IN_STACK;
            SAVE_POP_DATA:         ns = POP_STACK_SAVE_MEM;
            SAVE_TOP_STACK:        ns = CHECK_TOP_ZERO;
            CHECK_TOP_ZERO:        ns = zero ? JUMP : FETCH;

            JUMP,
            POP_STACK_SAVE_MEM,
            PUSH_DATA_IN_STACK:    ns = FETCH;
        endcase
    end
    always @(ps, zero) begin
        {WE, AdrSrc, PCWrite, IRWrite, tos, pop, push, ALUOp, ALUSrcA, ALUSrcB, stw1, stw2} = 14'b0;

        case (ps)
            FETCH: begin
                {AdrSrc, IRWrite, PCWrite} = 3'b011;
                ALUSrcA    = 2'b00;
                ALUSrcB    = 2'b11;
                ALUOp      = 2'b00;
                ResultSrc  = 2'b01;
            end

            SAVE_DATA_FOR_PUSH: AdrSrc = 1'b1;

            PUSH_DATA_IN_STACK: begin 
                push      = 1'b1;
                ResultSrc = 2'b10;            
            end

            SAVE_POP_DATA: stw2 = 1'b1;

            POP_STACK_SAVE_MEM: begin
                pop    = 1'b1;
                WE     = 1'b1;
                AdrSrc = 1'b1;
            end

            JUMP: begin
                ResultSrc = 2'b11;
                PCWrite   = 1'b1;
            end

            SAVE_TOP_STACK: stw1 = 1'b1;

            CHECK_TOP_ZERO: begin
                ALUSrcA     = 2'b10;
                ALUSrcB     = 2'b01;
                ALUOp  = 2'b00;
            end
        endcase
    end

endmodule


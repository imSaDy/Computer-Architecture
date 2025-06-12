module Controller (
    input[6:0] op,
    input[2:0] funct3,
    input funct7,
    input Zero,
    output reg RegWriteD,
    output reg MemWriteD,
    output reg [1:0] ResultSrc,
    output reg ALUSrcD,
    output reg [2:0] ALUControlD,
    output reg [2:0] ImmSrcD,
    output reg JalrD,
    output reg PCSrcD,
    output reg LuiD,
    output reg JumpD,
    output reg BranchD
    
);
    parameter [6:0]  Rtype = 7'b0110011,
                    Itype = 7'b0010011,
                    Lw = 7'b0000011,
                    Sw = 7'b0100011,
                    Btype = 7'b1100011,
                    Jalr = 7'b1100111,
                    LUI= 7'b0110111,
                    Jal = 7'd111;
    reg [1:0] ALUOp;
    wire branch_zero_type;
    assign branch_zero_type= (funct3==3'b001)? ~Zero : Zero;
    assign PCSrcD = (BranchD & branch_zero_type)| JumpD;
    //Main Decoder
    always @(op) begin
        {PCSrcD,RegWriteD,MemWriteD,ResultSrc,ALUSrcD,ImmSrcD,BranchD,JumpD,JalrD,LuiD} = 16'b0;
        case (op)
            Rtype: begin // R-type
                ALUOp = 2'b10;
                RegWriteD = 1'b1;
                MemWriteD = 1'b0;
                ResultSrc = 2'b00;
                ALUSrcD = 1'b0;
                ImmSrcD = 3'b000;//ImmSrcD should be xxx
                BranchD = 1'b0;
                JumpD= 1'b0;

            end
            Itype: begin // I-type load
                ALUOp = 2'b10;
                RegWriteD = 1'b1;
                MemWriteD = 1'b0;
                ResultSrc = 2'b00;
                ALUSrcD = 1'b1;
                ImmSrcD = 3'b000;
                BranchD = 1'b0;
                JumpD= 1'b0;
            end
            // Add more cases for other opcodes as needed
            Lw: begin // lw type
                ALUOp = 2'b00;
                RegWriteD = 1'b1;
                MemWriteD = 1'b0;
                ResultSrc = 2'b01;
                ALUSrcD = 1'b1;
                ImmSrcD = 3'b000;
                BranchD = 1'b0;
                JumpD= 1'b0;
            end
            Sw: begin // sw type
                ALUOp = 2'b00;
                RegWriteD = 1'b0;
                MemWriteD = 1'b1;
                ResultSrc = 2'b00;//result src should be xx
                ALUSrcD = 1'b1;
                ImmSrcD = 3'b001;
                BranchD = 1'b0;
                JumpD= 1'b0;
            end
            Btype: begin // branch
                ALUOp = 2'b01;
                RegWriteD = 1'b0;
                MemWriteD = 1'b0;
                ResultSrc = 2'b00;//result src should be xx
                ALUSrcD = 1'b0;
                ImmSrcD = 3'b010;
                BranchD = 1'b1;
                JumpD= 1'b0;
            end
            Jalr: begin // jalr
                ALUOp = 2'b10;
                RegWriteD = 1'b0;
                MemWriteD = 1'b0;
                ResultSrc = 2'b00;
                ALUSrcD = 1'b1;
                ImmSrcD = 3'b000;
                BranchD = 1'b0;
                JumpD = 1'b1;
                JalrD = 1'b1;
            end
            LUI: begin // lui
                ALUOp = 2'b00; //aluop is xx
                RegWriteD = 1'b1;
                MemWriteD = 1'b0;
                ResultSrc = 2'b11;
                ALUSrcD = 1'b0;
                ImmSrcD = 3'b100;
                BranchD = 1'b0;
                JumpD= 1'b0;
                LuiD = 1'b1;
            end
            Jal: begin // Jal
                ALUOp = 2'b00; //aluop is xx
                RegWriteD = 1'b1;
                MemWriteD = 1'b0;
                ResultSrc = 2'b10;
                ALUSrcD = 1'b0;
                ImmSrcD = 3'b011;
                BranchD = 1'b0;
                JumpD= 1'b1;
            end
        endcase
    end

    //ALUDeocder
    parameter [2:0] 
                    ALU_ADD = 3'b000,
                    ALU_SUB = 3'b001,
                    ALU_AND = 3'b010,
                    ALU_OR  = 3'b011,
                    ALU_SLT = 3'b101;
                    
    always @(ALUOp, funct3, funct7,op) begin
        case (ALUOp)
            2'b00: ALUControlD = ALU_ADD;
            2'b01: ALUControlD = ALU_SUB; // beq
            2'b10: begin // R-type and I-type
                case (funct3)
                    3'b000: ALUControlD = ((((op==Rtype)&funct7==1'b0) | (op==Itype))  | (op==Jalr)) ? ALU_ADD : ALU_SUB; // add or sub
                    3'b010: ALUControlD = ALU_SLT; 
                    3'b110: ALUControlD = ALU_OR;
                    3'b111: ALUControlD = ALU_AND;
                endcase
            end
        endcase
    end




    
endmodule
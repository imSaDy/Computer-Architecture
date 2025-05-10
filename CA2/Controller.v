module Controller (
    input[6:0] op,
    input[2:0] funct3,
    input funct7,
    input Zero,
    output reg RegWrite,
    output reg MemWrite,
    output reg [1:0] ResultSrc,
    output reg ALUSrc,
    output reg [2:0] ALUControl,
    output reg [2:0] ImmSrc,

    output reg [1:0]PCSrc

);
    reg Branch, Jump;
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
    assign PCSrc[0] = (Branch & branch_zero_type)| Jump;
    //Main Decoder
    always @(op) begin
        {PCSrc,RegWrite,MemWrite,ResultSrc,ALUSrc,ImmSrc,Branch,Jump,PCSrc[1]} = 15'b0;
        case (op)
            Rtype: begin // R-type
                ALUOp = 2'b10;
                RegWrite = 1'b1;
                MemWrite = 1'b0;
                ResultSrc = 2'b00;
                ALUSrc = 1'b0;
                ImmSrc = 3'b000;//ImmSrc should be xxx
                Branch = 1'b0;
                Jump= 1'b0;

            end
            Itype: begin // I-type load
                ALUOp = 2'b10;
                RegWrite = 1'b1;
                MemWrite = 1'b0;
                ResultSrc = 2'b00;
                ALUSrc = 1'b1;
                ImmSrc = 3'b000;
                Branch = 1'b0;
                Jump= 1'b0;
            end
            // Add more cases for other opcodes as needed
            Lw: begin // lw type
                ALUOp = 2'b00;
                RegWrite = 1'b1;
                MemWrite = 1'b0;
                ResultSrc = 2'b01;
                ALUSrc = 1'b1;
                ImmSrc = 3'b000;
                Branch = 1'b0;
                Jump= 1'b0;
            end
            Sw: begin // sw type
                ALUOp = 2'b00;
                RegWrite = 1'b0;
                MemWrite = 1'b1;
                ResultSrc = 2'b00;//result src should be xx
                ALUSrc = 1'b1;
                ImmSrc = 3'b001;
                Branch = 1'b0;
                Jump= 1'b0;
            end
            Btype: begin // branch
                ALUOp = 2'b01;
                RegWrite = 1'b0;
                MemWrite = 1'b0;
                ResultSrc = 2'b00;//result src should be xx
                ALUSrc = 1'b0;
                ImmSrc = 3'b010;
                Branch = 1'b1;
                Jump= 1'b0;
            end
            Jalr: begin // jalr
                ALUOp = 2'b10;
                RegWrite = 1'b0;
                MemWrite = 1'b0;
                ResultSrc = 2'b00;
                ALUSrc = 1'b1;
                ImmSrc = 3'b000;
                Branch = 1'b0;
                Jump = 1'b1;
                PCSrc[1]=1'b1;
            end
            LUI: begin // lui
                ALUOp = 2'b00; //aluop is xx
                RegWrite = 1'b1;
                MemWrite = 1'b0;
                ResultSrc = 2'b11;
                ALUSrc = 1'b0;
                ImmSrc = 3'b011;
                Branch = 1'b0;
                Jump= 1'b0;
            end
            Jal: begin // Jal
                ALUOp = 2'b00; //aluop is xx
                RegWrite = 1'b1;
                MemWrite = 1'b0;
                ResultSrc = 2'b10;
                ALUSrc = 1'b0;
                ImmSrc = 3'b011;
                Branch = 1'b0;
                Jump= 1'b1;
            end
        endcase
    end

    //ALUDeocder
    parameter [2:0] 
                    ALU_ADD = 3'b000,
                    ALU_SUB = 3'b001,
                    ALU_SLT = 3'b101,
                    ALU_OR  = 3'b011,
                    ALU_AND = 3'b010;
    always @(ALUOp, funct3, funct7,op) begin
        case (ALUOp)
            2'b00: ALUControl = ALU_ADD;
            2'b01: ALUControl = ALU_SUB; // beq
            2'b10: begin // R-type and I-type
                case (funct3)
                    3'b000: ALUControl = ((((op==Rtype) | (op==Itype))&funct7==1'b0 ) | op==Jalr) ? ALU_ADD : ALU_SUB; // add or sub
                    3'b010: ALUControl = ALU_SLT; 
                    3'b110: ALUControl = ALU_OR;
                    3'b111: ALUControl = ALU_AND;
                endcase
            end
        endcase
    end




    
endmodule
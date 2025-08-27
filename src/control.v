module control(
    input [6:0] opcode,
    output reg RegWrite,
    output reg MemtoReg,
    output reg MemWrite,
    output reg ALUSrc,
    output reg Branch,
    output reg [1:0] ALUOp
);
    // Opcodes das instruções do RISC-V
    parameter R_TYPE = 7'b0110011;
    parameter I_TYPE_ALU = 7'b0010011;
    parameter LW = 7'b0000011;
    parameter SW = 7'b0100011;
    parameter BEQ = 7'b1100011;

    always @(*) begin
        // OAC: Define um estado padrão para os sinais
        RegWrite = 1'b0;
        MemtoReg = 1'b0;
        MemWrite = 1'b0;
        ALUSrc = 1'b0;
        Branch = 1'b0;
        ALUOp = 2'b00; // Padrão: não importa/soma

        case (opcode)
            R_TYPE: begin
                RegWrite = 1'b1;
                ALUSrc = 1'b0; // Usa segundo registrador
                ALUOp = 2'b10; // ULA decide pela func3/func7
            end
            I_TYPE_ALU: begin // addi, andi, ori
                RegWrite = 1'b1;
                ALUSrc = 1'b1; // Usa imediato
                ALUOp = 2'b00; // ULA faz soma (para addi)
            end
            LW: begin
                RegWrite = 1'b1;
                MemtoReg = 1'b1; // Resultado vem da memória
                ALUSrc = 1'b1; // Usa imediato para calcular endereço
                ALUOp = 2'b00; // ULA faz soma (endereço + offset)
            end
            SW: begin
                MemWrite = 1'b1;
                ALUSrc = 1'b1; // Usa imediato para calcular endereço
                ALUOp = 2'b00; // ULA faz soma (endereço + offset)
            end
            BEQ: begin
                Branch = 1'b1;
                ALUOp = 2'b01; // ULA faz subtração para comparar
            end
            default: begin
                RegWrite = 1'b0;
                MemtoReg = 1'b0;
                MemWrite = 1'b0;
                ALUSrc = 1'b0;
                Branch = 1'b0;
                ALUOp = 2'b00;
            end
        endcase
    end
endmodule

// Módulo: alu_control
// Descrição: Gera o sinal de controle específico para a ALU.
//
// Referências:
// - Patterson, D. A., & Hennessy, J. L. (2017). Computer Organization and Design RISC-V Edition:
//   The Hardware Software Interface. Morgan Kaufmann. (Figura 4.19)

module alu_control(
    input  [1:0]  ALUOp,        // Sinal da unidade de controle principal
    input  [2:0]  funct3,       // Campo funct3 da instrução
    input         funct7_5,     // Bit 5 do funct7 (ou bit 30 da instrução)
    output reg [3:0]  ALUControl    // Sinal de controle de 4 bits para a ALU
);

    // Códigos de operação da ALU
    parameter ALU_ADD = 4'b0010;
    parameter ALU_SUB = 4'b0110;
    parameter ALU_XOR = 4'b0100;
    parameter ALU_SRL = 4'b0101;

    always @(*) begin
        case (ALUOp)
            2'b00: // lw, sw, addi -> Adição
                ALUControl = ALU_ADD;
            2'b01: // beq -> Subtração
                ALUControl = ALU_SUB;
            2'b10: // Tipo R
                case (funct3)
                    3'b000: // ADD ou SUB
                        if (funct7_5 == 1'b0)
                            ALUControl = ALU_ADD; // ADD (não é do grupo 12, mas comum)
                        else
                            ALUControl = ALU_SUB; // SUB
                    3'b100: // XOR
                        ALUControl = ALU_XOR;
                    3'b101: // SRL ou SRA
                        if (funct7_5 == 1'b0)
                            ALUControl = ALU_SRL; // SRL
                        else
                            ALUControl = 4'bxxxx; // SRA (não implementado)
                    default:
                        ALUControl = 4'bxxxx; // Combinação não suportada
                endcase
            default:
                ALUControl = 4'bxxxx; // ALUOp inválido
        endcase
    end

endmodule


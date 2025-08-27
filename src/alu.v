
// Módulo: alu
// Descrição: Unidade Lógica e Aritmética para o processador RISC-V.
//
// Referências:
// - Patterson, D. A., & Hennessy, J. L. (2017). Computer Organization and Design RISC-V Edition:
//   The Hardware Software Interface. Morgan Kaufmann. (Figura 4.18)

module alu(
    input  [31:0] a,            // Operando A
    input  [31:0] b,            // Operando B
    input  [3:0]  ALUControl,   // Sinal de controle da operação da ALU
    output [31:0] result,       // Resultado da operação
    output        zero          // Flag que indica se o resultado é zero
);

    reg [31:0] result_reg;

    // Definição dos códigos de operação da ALU
    parameter ALU_ADD = 4'b0010;
    parameter ALU_SUB = 4'b0110;
    parameter ALU_XOR = 4'b0100;
    parameter ALU_SRL = 4'b0101;
    // Outras operações podem ser adicionadas aqui (AND, OR, SLL, etc.)

    always @(*) begin
        case (ALUControl)
            ALU_ADD: result_reg = a + b;
            ALU_SUB: result_reg = a - b;
            ALU_XOR: result_reg = a ^ b;
            ALU_SRL: result_reg = a >> b[4:0]; // O valor do deslocamento são os 5 bits menos significativos de b
            default:  result_reg = 32'hxxxxxxxx; // Operação não definida
        endcase
    end

    assign result = result_reg;
    assign zero = (result_reg == 32'b0); // O flag 'zero' é ativado se o resultado for 0

endmodule


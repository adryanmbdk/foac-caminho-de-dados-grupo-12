
// Módulo: instruction_memory
// Descrição: Memória para armazenar as instruções do programa.
//
// Referências:
// - Patterson, D. A., & Hennessy, J. L. (2017). Computer Organization and Design RISC-V Edition:
//   The Hardware Software Interface. Morgan Kaufmann. (Figura 4.3)

module instruction_memory(
    input  [31:0] addr,         // Endereço da instrução (PC)
    output [31:0] inst          // Instrução lida da memória
);

    // Memória de instruções. 256 posições de 32 bits (1024 bytes).
    // O tamanho pode ser ajustado conforme necessário.
    reg [31:0] mem[255:0];

    // Lê a instrução do endereço fornecido pelo PC.
    // O endereço do PC é em bytes, então dividimos por 4 para obter o índice da palavra.
    assign inst = mem[addr[9:2]];

    // Inicialização da memória de instruções a partir de um arquivo.
    // O arquivo "instruction_mem.bin" deve conter o programa em binário,
    // uma instrução por linha.
    initial begin
        $readmemb("input/instruction_mem.bin", mem);
    end

endmodule


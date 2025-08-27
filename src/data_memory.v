
// Módulo: data_memory
// Descrição: Memória de dados para o processador RISC-V.
//
// Referências:
// - Patterson, D. A., & Hennessy, J. L. (2017). Computer Organization and Design RISC-V Edition:
//   The Hardware Software Interface. Morgan Kaufmann. (Figura 4.20)

module data_memory(
    input         clk,          // Clock
    input         MemWrite,     // Sinal de habilitação de escrita na memória
    input         MemRead,      // Sinal de habilitação de leitura da memória
    input  [31:0] addr,         // Endereço para leitura ou escrita (saída da ALU)
    input  [31:0] write_data,   // Dados a serem escritos na memória
    output [31:0] read_data     // Dados lidos da memória
);

    // Memória de dados. 256 posições de 32 bits (1024 bytes).
    reg [31:0] mem[255:0];
    integer i; // Variável de loop movida para o escopo do módulo

    // Leitura da memória. A leitura é assíncrona.
    // O endereço é em bytes, então usamos addr[9:2] para endereçar a palavra.
    assign read_data = MemRead ? mem[addr[9:2]] : 32'hxxxxxxxx;

    // Escrita na memória. A escrita é síncrona na borda de subida do clock.
    always @(posedge clk) begin
        if (MemWrite) begin
            mem[addr[9:2]] <= write_data;
        end
    end

    // Inicialização da memória de dados a partir de um arquivo.
    // O arquivo "data_mem.hex" contém o estado inicial da memória.
    initial begin
        $readmemh("input/data_mem.hex", mem);
        // Se o arquivo não existir, inicializar com zeros por padrão.
        for (i = 0; i < 256; i = i + 1) begin
            if (mem[i] === 32'bx) begin
                mem[i] = 32'b0;
            end
        end
    end

endmodule


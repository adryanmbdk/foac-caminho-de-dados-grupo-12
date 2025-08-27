
// Módulo: reg_file
// Descrição: Banco de 32 registradores de 32 bits para o processador RISC-V.
//
// Referências:
// - Patterson, D. A., & Hennessy, J. L. (2017). Computer Organization and Design RISC-V Edition:
//   The Hardware Software Interface. Morgan Kaufmann. (Figura 4.17)

module reg_file(
    input         clk,          // Clock
    input         rst,          // Reset
    input         RegWrite,     // Sinal de habilitação de escrita no registrador
    input  [4:0]  rs1_addr,     // Endereço do primeiro registrador de leitura (rs1)
    input  [4:0]  rs2_addr,     // Endereço do segundo registrador de leitura (rs2)
    input  [4:0]  rd_addr,      // Endereço do registrador de escrita (rd)
    input  [31:0] rd_data,      // Dados a serem escritos no registrador de destino
    output [31:0] rs1_data,     // Dados lidos de rs1
    output [31:0] rs2_data      // Dados lidos de rs2
);

    // Banco de 32 registradores de 32 bits
    reg [31:0] registers[31:0];
    integer i; // Variável de loop movida para o escopo do módulo

    // Leitura assíncrona dos registradores rs1 e rs2
    // O registrador x0 (endereço 0) sempre retorna 0
    assign rs1_data = (rs1_addr == 5'b0) ? 32'b0 : registers[rs1_addr];
    assign rs2_data = (rs2_addr == 5'b0) ? 32'b0 : registers[rs2_addr];

    // Escrita síncrona no registrador rd na borda de subida do clock
    always @(posedge clk) begin
        if (RegWrite && (rd_addr != 5'b0)) begin
            registers[rd_addr] <= rd_data;
        end
    end

    // Inicialização dos registradores em caso de reset
    always @(posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'b0;
            end
        end
    end

endmodule


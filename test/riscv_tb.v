
// Módulo: riscv_tb
// Descrição: Testbench para o processador RISC-V.

`timescale 1ns / 1ps

module riscv_tb;

    // --- Sinais do Testbench ---
    reg clk;
    reg rst;
    integer i; // Variável de loop movida para o escopo do módulo
    integer file_handle; // Handle para arquivo de texto

    // --- Instanciação do DUT (Design Under Test) ---
    riscv dut (
        .clk(clk),
        .rst(rst)
    );

    // --- Geração de Clock ---
    // Clock com período de 10ns (frequência de 100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // --- Função para salvar estado dos registradores em arquivo ---
    task save_registers_to_file;
        input [255:0] filename;
        begin
            file_handle = $fopen(filename, "w");
            if (file_handle == 0) begin
                $display("Erro: Não foi possível abrir o arquivo %s", filename);
            end else begin
            
            $fdisplay(file_handle, "=== Estado dos Registradores RISC-V ===");
            $fdisplay(file_handle, "");
            
            for (i = 0; i < 32; i = i + 1) begin
                $fdisplay(file_handle, "x[%2d] = %d", i, dut.rf.registers[i]);
            end
            
            $fclose(file_handle);
            end
        end
    endtask

    // --- Simulação e Verificação ---
    initial begin
        // 1. Aplicar o reset
        rst = 1;
        #20; // Manter o reset por 20ns
        
        // 2. Mostrar estado inicial dos registradores 
        $display("=== ESTADO INICIAL DOS REGISTRADORES ===");
        $display("");
        for (i = 0; i < 32; i = i + 1) begin
            $display("x[%2d] = %d", i, dut.rf.registers[i]);
        end
        $display("");
        
        // 3. Salvar estado inicial em arquivo
        save_registers_to_file("output/registers_initial.txt");
        
        // 4. Continuar simulação
        rst = 0;

        // 5. Esperar um número de ciclos para o programa terminar.
        // O número de ciclos depende do programa de teste.
        // Vamos assumir que o programa de teste tem menos de 20 instruções.
        // 20 instruções * 1 ciclo/instrução * 10ns/ciclo = 200ns
        #200;

        // 6. Exibir o estado final dos registradores
        $display("=== ESTADO FINAL DOS REGISTRADORES ===");
        $display("");
        for (i = 0; i < 32; i = i + 1) begin
            $display("x[%2d] = %d", i, dut.rf.registers[i]);
        end
        $display("");

        // 7. Salvar estado final em arquivo
        save_registers_to_file("output/registers_final.txt");

        // 8. Terminar a simulação
        $finish;
    end

endmodule
module riscv(
    input clk,
    input rst
);

    // =================================================================
    // Sinais (Fios) que conectam os módulos
    // =================================================================
    wire [31:0] pc, instr, imm_ext;
    wire [31:0] read_data1, read_data2, alu_result, mem_read_data;
    wire [31:0] pc_plus_4, pc_branch;
    wire        zero_flag;

    // Sinais de Controle
    wire        reg_write, mem_to_reg, mem_write, alu_src, branch;
    wire [1:0]  alu_op;

    // =================================================================
    // Estágio 1: Busca da Instrução (Instruction Fetch - IF)
    // =================================================================

    // MUX para decidir o próximo valor do PC. Controlado pelo sinal PCSrc.
    // PCSrc = 0 -> Próximo PC é PC + 4
    // PCSrc = 1 -> Próximo PC é o endereço do desvio (branch)
    wire        PCSrc = branch & zero_flag;
    wire [31:0] next_pc = PCSrc ? pc_branch : pc_plus_4;
    


    // Registrador do Program Counter (PC). Atualiza no pulso de clock.
    reg [31:0] pc_reg;
    assign pc = pc_reg;
    always @(posedge clk or posedge rst) begin
        if (rst)
            pc_reg <= 32'h0;
        else
            pc_reg <= next_pc;
    end

    // Somador para calcular PC + 4
    assign pc_plus_4 = pc + 32'd4;

    // Memória de Instruções
    instruction_memory imem(
        .addr(pc),
        .inst(instr)
    );


    // =================================================================
    // Estágio 2: Decodificação da Instrução (Instruction Decode - ID)
    // =================================================================

    // Unidade de Controle Principal (decodifica o opcode)
    control main_control(
        .opcode(instr[6:0]),
        .RegWrite(reg_write),
        .MemtoReg(mem_to_reg),
        .MemWrite(mem_write),
        .ALUSrc(alu_src),
        .Branch(branch),
        .ALUOp(alu_op)
    );

    // Banco de Registradores
    reg_file rf(
        .clk(clk),
        .rst(rst),
        .RegWrite(reg_write),
        .rs1_addr(instr[19:15]),
        .rs2_addr(instr[24:20]),
        .rd_addr(instr[11:7]),
        .rd_data(mem_to_reg ? mem_read_data : alu_result), // MUX aqui decide o que escrever de volta
        .rs1_data(read_data1),
        .rs2_data(read_data2)
    );

    // Gerador de Imediatos
    imm_gen ig(
        .inst(instr),
        .imm(imm_ext)
    );


    // =================================================================
    // Estágio 3: Execução (Execute - EX)
    // =================================================================

    // MUX que escolhe o segundo operando da ULA
    // ALUSrc = 0 -> Operando vem do banco de registradores (read_data2)
    // ALUSrc = 1 -> Operando é o imediato estendido
    wire [31:0] alu_operand_b = alu_src ? imm_ext : read_data2;

    // Controle da ULA
    wire [3:0] alu_control_op;
    alu_control ac(
        .ALUOp(alu_op),
        .funct3(instr[14:12]),
        .funct7_5(instr[30]),
        .ALUControl(alu_control_op)
    );

    // Unidade Lógica e Aritmética (ULA)
    alu main_alu(
        .a(read_data1),
        .b(alu_operand_b),
        .ALUControl(alu_control_op),
        .result(alu_result),
        .zero(zero_flag)
    );

    // Somador para calcular o endereço do desvio (PC + imediato)
    assign pc_branch = pc + imm_ext;


    // =================================================================
    // Estágio 4: Acesso à Memória (Memory - MEM)
    // =================================================================

    data_memory dmem(
        .clk(clk),
        .MemWrite(mem_write),
        .MemRead(1'b1), // Sempre habilitar leitura para lw
        .addr(alu_result),
        .write_data(read_data2),
        .read_data(mem_read_data)
    );

endmodule
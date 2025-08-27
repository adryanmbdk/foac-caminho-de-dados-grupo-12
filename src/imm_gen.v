
// Módulo: imm_gen
// Descrição: Gera o valor imediato de 32 bits a partir da instrução de 32 bits.
//
// Referências:
// - Patterson, D. A., & Hennessy, J. L. (2017). Computer Organization and Design RISC-V Edition:
//   The Hardware Software Interface. Morgan Kaufmann. (Figura 4.15)
// - The RISC-V Instruction Set Manual, Volume I: Unprivileged ISA

module imm_gen(
    input  [31:0] inst,         // Instrução de 32 bits
    output [31:0] imm           // Valor imediato de 32 bits com extensão de sinal
);

    // O valor imediato é selecionado com base no opcode da instrução.
    // Para simplificar, assumimos que a unidade de controle já decodificou
    // e sabe qual tipo de imediato usar. No entanto, uma implementação mais
    // completa decodificaria o opcode aqui. Para este trabalho, vamos
    // nos basear nos formatos I, S e B, que são os relevantes para o grupo 12.

    // Formato I (usado por lw, addi, srl)
    // imm[11:0] = inst[31:20]
    wire [31:0] i_imm = {{20{inst[31]}}, inst[31:20]};

    // Formato S (usado por sw)
    // imm[11:5] = inst[31:25], imm[4:0] = inst[11:7]
    wire [31:0] s_imm = {{20{inst[31]}}, inst[31:25], inst[11:7]};

    // Formato B (usado por beq)
    // imm[12|10:5] = inst[31|30:25], imm[4:1|11] = inst[11:8|7]
    wire [31:0] b_imm = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};

    // A seleção final do imediato dependeria de um sinal da unidade de controle.
    // Por enquanto, vamos deixar a lógica de seleção para o módulo principal,
    // que terá acesso aos sinais de controle. Para este módulo, vamos
    // gerar todos os possíveis formatos e o módulo superior seleciona.
    // No nosso caso, o sinal ALUSrc vai definir se usamos o imediato ou não,
    // e o tipo de instrução (decodificado no controle) qual imediato usar.
    // Uma abordagem comum é ter um sinal de controle `ImmSel`.

    // Para este projeto, vamos assumir que a unidade de controle nos diz qual usar.
    // Vamos simplificar e deixar a seleção para o datapath.
    // No datapath, faremos a seleção com base no tipo de instrução.
    // Aqui, vamos apenas prover uma saída 'imm'. O datapath fará a multiplexação.
    // Para este exemplo, vamos usar o formato I por padrão, mas a lógica
    // de multiplexação no `riscv.v` será mais complexa.

    // A forma correta seria ter um seletor, como abaixo:
    /*
    reg [31:0] imm_out;
    always @(*) begin
        case (ImmSel) // ImmSel viria da unidade de controle
            `I_TYPE: imm_out = i_imm;
            `S_TYPE: imm_out = s_imm;
            `B_TYPE: imm_out = b_imm;
            default:  imm_out = 32'hxxxxxxxx; // Indefinido
        endcase
    end
    assign imm = imm_out;
    */

    // Como o `ALUSrc` que vem do controle vai selecionar entre `rs2_data` e o
    // `imediato`, e o tipo de imediato depende da instrução, vamos ter que
    // ter um mux para o próprio imediato no datapath.
    // Por simplicidade aqui, vamos apenas expor um dos imediatos.
    // A lógica de seleção será implementada no módulo 'riscv.v'.
    // A melhor abordagem é ter um sinal de controle para selecionar o tipo de imediato.
    // Vamos deixar a lógica de seleção para o módulo riscv.v, que já tem
    // os sinais de controle.

    // Neste módulo, vamos gerar o imediato para cada tipo e o módulo `riscv` seleciona.
    // Para simplificar, vou deixar a lógica de seleção para o datapath principal (`riscv.v`)
    // e este módulo apenas extrai os bits. Vamos ter 3 saídas, uma para cada tipo.

    // Reestruturando para ter saídas separadas:
    // Isso é mais limpo, mas requer mais fios.
    /*
    module imm_gen(
        input  [31:0] inst,
        output [31:0] i_imm,
        output [31:0] s_imm,
        output [31:0] b_imm
    );
    ...
    endmodule
    */
    // Ou, como no livro, um único módulo que gera o imediato correto
    // com base em um sinal de controle. Vamos seguir a segunda abordagem
    // e adicionar um seletor aqui, mas o seletor será controlado por
    // sinais que vêm da unidade de controle. Para o grupo 12, precisamos
    // dos tipos I, S e B.

    // A unidade de controle irá gerar um sinal para selecionar qual
    // formato de imediato usar. No entanto, para não complicar a unidade de controle,
    // vamos decodificar o opcode diretamente aqui para selecionar o formato.

    reg [31:0] imm_temp;
    always @(*) begin
        case (inst[6:0]) // opcode
            7'b0010011: // addi, srlI (srai é diferenciado por funct7)
                imm_temp = i_imm;
            7'b0100011: // sw
                imm_temp = s_imm;
            7'b1100011: // beq
                imm_temp = b_imm;
            7'b0000011: // lw
                imm_temp = i_imm;
            default:
                imm_temp = 32'hxxxxxxxx; // Tipo de instrução não suportado
        endcase
    end

    assign imm = imm_temp;

endmodule



# Caminho de Dados RISC-V - Grupo 12
Instruções implementado para o Grupo 12 é:

| Tipo        | Instrução | Descrição                               |
|-------------|-----------|-------------------------------------------|
| I-Type      | `lw`      | Load Word                                 |
| S-Type      | `sw`      | Store Word                                |
| R-Type      | `sub`     | Subtração                                 |
| R-Type      | `xor`     | OU Exclusivo (XOR)                        |
| I-Type      | `addi`    | Adição com Imediato                       |
| R-Type      | `srl`     | Shift Right Logical                       |
| B-Type      | `beq`     | Branch on Equal                           |

## Estrutura do Projeto

O projeto está organizado nos seguintes diretórios:

- `src/`: Contém todos os arquivos-fonte Verilog dos módulos do processador.
  - `riscv.v`: Módulo de topo que conecta todos os componentes.
  - `control.v`: Unidade de controle principal.
  - `alu_control.v`: Controle secundário para a ALU.
  - `alu.v`: Unidade Lógica e Aritmética.
  - `reg_file.v`: Banco de registradores.
  - `imm_gen.v`: Gerador de imediatos.
  - `data_memory.v`: Memória de dados.
  - `instruction_memory.v`: Memória de instruções.
- `test/`: Contém o testbench para simulação.
  - `riscv_tb.v`: Testbench que instancia o processador e verifica a saída.
- `input/`: Contém os arquivos de entrada para a simulação.
  - `test_program.asm`: Código de teste em Assembly.
  - `instruction_mem.bin`: Código de teste "compilado" em binário.
  - `registers_init.txt`: Estado inicial dos registradores RISC-V.
  - `data_mem.hex`: Estado inicial da memória de dados.
- `output/`: Contém os arquivos gerados pela simulação.
  - `registers_initial.txt`: Estado inicial dos registradores após reset.
  - `registers_final.txt`: Estado final dos registradores após execução do programa.
- `doc/`: Diretório para a documentação do projeto (formato SBC).

## Como Executar a Simulação

Utilizando o Icarus Verilog:

1.  **Compile os arquivos Verilog:**
    ```sh
    iverilog -o riscv_sim src/*.v test/riscv_tb.v
    ```

2.  **Execute a simulação:**
    Execute o arquivo compilado.

    ```sh
    vvp riscv_sim
    ```

3.  **Verifique a saída:**
    O testbench irá imprimir o estado inicial e final dos 32 registradores no terminal. Além disso, os estados serão salvos em arquivos de texto na pasta `output/`.

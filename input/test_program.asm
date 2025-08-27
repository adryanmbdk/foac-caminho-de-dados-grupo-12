
addi x5, x0, 10
addi x6, x0, 5
addi x2, x0, 1
sw x5, 0(x0)
lw x7, 0(x0)
sub x8, x7, x6
xor x9, x8, x6
srl x10, x5, x2
beq x8, x6, FIM
addi x11, x0, 99

FIM:
addi x12, x0, 7
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
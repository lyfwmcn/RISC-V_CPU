# 指令格式
## R 型指令
* funct7 + Rs2 + Rs1 + funct3 + Rd + opcode
* opcode = 0110011

| instr | funct3 | funct7[5] |
| :---: | :----: | :-------: |
|  add  |  000   |     0     |
|  sub  |  000   |     1     |
|  sll  |  001   |     0     |
|  slt  |  010   |     0     |
| sltu  |  011   |     0     |
|  xor  |  100   |     0     |
|  srl  |  101   |     0     |
|  sra  |  101   |     1     |
|  or   |  110   |     0     |
|  and  |  111   |     0     |
## I 型指令
#### 算术型指令
* imm[11:0] + Rs1 + funct3 + Rd + opcode
* opcode = 0010011

| instr | funct3 |
| :---: | :----: |
| addi  |  000   |
| slli  |  001   |
| slti  |  010   |
| sltiu |  011   |
| xori  |  100   |
| srli  |  101   |
| srai  |  101   |
|  ori  |  110   |
| andi  |  111   |
* srli 和 srai 由 imm[11] 区分
* srli: imm[11] = 0
* srai: imm[11] = 1
#### Load 型指令
* opcode = 0000011

| instr | funct3 |
| :---: | :----: |
|  lb   |  000   |
|  lh   |  001   |
|  lw   |  010   |
|  lbu  |  100   |
|  lhu  |  101   |
#### 跳转指令
* opcode = 1100111

| instr | funct3 |
| :---: | :----: |
| jalr  |  000   |
#### 环境调用指令
* opcode = 1110011
* ecall 和 ebreak 靠 imm[0] 区分
* ecall: imm[0] = 0
* ebreak: imm[0] = 1
## U 型指令
* imm[31:12] + Rd + opcode

| instr | opcode |
| :---: | :----: |
|  lui  |0110111 |
| auipc |0010111 |
## S 型指令
* imm[11:5] + Rs2 + Rs1 + funct3 + imm[4:0] + opcode
* opcode = 0100011

| instr | funct3 |
| :---: | :----: |
|  sb   |  000   |
|  sh   |  001   |
|  sw   |  010   |
## B 型指令
* imm[12] + imm[10:5] + Rs1 + Rs2 + funct3 + imm[4:1] + imm[11] + opcode
* opcode = 1100011

| instr | funct3 |
| :---: | :----: |
|  beq  |  000   |
|  bne  |  001   |
|  blt  |  100   |
|  bge  |  101   |
| bltu  |  110   |
| bgeu  |  111   |
## J 型指令
* opcode = 1101111
* imm[20] + imm[10:1] + imm[11] + imm[19:12] + Rd + opcode

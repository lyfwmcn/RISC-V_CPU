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
* srli 和 srai 由 imm[10] 区分
* srli: imm[10] = 0
* srai: imm[10] = 1
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
* imm[12] + imm[10:5] + Rs2 + Rs1 + funct3 + imm[4:1] + imm[11] + opcode
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
# 元件说明
## ALU
* 根据 ALUCtr 选择运算模式输出 BusA 和 BusB 的运算结果和标志信息
* sll, srl, sra 模式 BusB[31:5] 必须为 0

| mode | ALUCtr |
| :--: | :----: |
| add  |  0000  |
| sub  |  1000  |
| sll  |  0001  |
| slt  |  0010  |
| sltu |  0011  |
| xor  |  0100  |
| srl  |  0101  |
| sra  |  1101  |
|  or  |  0110  |
| and  |  0111  |
## BU
* 根据控制信号和标志信息生成 PCCtr, imm, Jump
* PCCtr 由 BranchCtr 决定

| BranchCtr | PCCtrNotChanged |
| :-------: | :-------------: |
|    000    |       beq       |
|    001    |       bne       |
|    010    |        1        |
|    100    |       blt       |
|    101    |       bge       |
|    110    |       bltu      |
|    111    |       bgeu      |

| PCCtr | newimm | Jump |
| :---: | :----: | :--: |
|  00   |   0    |  0   |
|  01   |   0    |  0   |
|  10   |  imm   |  1   |
|  11   |  BusW  |  1   |
## IDU
* 根据 Instr 输出各种控制信号
* R：检查 funct3, funct7
* I：检查 slli, srli, srai 的 imm
* load：检查 funct3
* env：检查 imm, funct3, Rs1, Rd
* jalr：检查 funct3
* lui/auipc：不检查
* S：检查 funct3
* B：检查 funct3 和 imm
* J：检查 imm
## MM
* 提供指令数据双读口和单写口，同步读写
* PCEN 控制 Instr 是否改变，PCCLR 控制 Instr 同步清零

| MemCtr | mode |
| :----: | :--: |
|  0000  |  lb  |
|  0001  |  lh  |
|  0010  |  lw  |
|  0100  |  lbu |
|  0101  |  lhu |
|  1000  |  sb  |
|  1001  |  sh  |
|  1010  |  sw  |
## PC
* 根据 Wait, PCCtr, lastPC, imm 更新 PC，并输出 PC, nextPC
* 必须保证 lastPC[1:0], imm[1:0] 为 0，否则 PC 不会改变

| PCCtr |    newPC     |
| :---: | :----------: |
|  00   |    PC + 4    |
|  01   |      PC      |
|  10   | lastPC + imm |
|  11   |      imm     |
## RegFile
* 提供写使能，2 读口，1 写口，同步写，异步读
* 0 号寄存器固定为 0

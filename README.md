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
#### jalr 指令
* opcode = 1100111

| instr | funct3 |
| :---: | :----: |
| jalr  |  000   |
#### 环境调用指令
* opcode = 1110011

|  instr  |      imm      | Rs1 | funct3 |  Rd  |
| :-----: | :-----------: | :-: | :----: | :--: |
|  ecall  | 000000000000  |  0  |  000   |  0   |
| ebreak  | 000000000001  |  0  |  000   |  0   |
|  mret   | 001100000010  |  0  |  000   |  0   |
|  csrrw  |               |     |  001   |      |
|  csrrs  |               |     |  010   |      |
|  csrrc  |               |     |  011   |      |
| csrrwi  |               |     |  101   |      |
| csrrsi  |               |     |  110   |      |
| csrrci  |               |     |  111   |      |
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
# CSR 寄存器
|    name    | addr |
| :--------: | :--: |
|  mstatus   | 300  |
|    misa    | 301  |
|  medeleg   | 302  |
|  mideleg   | 303  |
|    mie     | 304  |
|   mtvec    | 305  |
|  mscratch  | 340  |
|    mepc    | 341  |
|   mcause   | 342  |
|   mtval    | 343  |
|    mip     | 344  |
|  mhartid   | F14  |
|   mcycle   | B00  |
|  mcycleh   | B80  |
|  minstret  | B02  |
| minstreth  | B82  |
|  sstatus   | 100  |
|    sie     | 104  |
|   stvec    | 105  |
|  sscratch  | 140  |
|    sepc    | 141  |
|   scause   | 142  |
|   stval    | 143  |
|    sip     | 144  |
|    satp    | 180  |
## mstatus/sstatus
|  bit  | name |              function                | sstatus |
| :---: | :--: | :----------------------------------: | :-----: |
|   0   | UIE  | User Interrupt Enable                |    *    |
|   1   | SIE  | Supervisor Interrupt Enable          |    *    |
|   3   | MIE  | Machine Interrupt Enable             |         |
|   4   | UPIE | User Previous Interrupt Enable       |    *    |
|   5   | SPIE | Supervisor Previous Interrupt Enable |    *    |
|   7   | MPIE | Machine Previous Interrupt Enable    |         |
|   8   | SPP  | Supervisor Previous Privilege        |    *    |
| 12:11 | MPP  | Machine Previous Privilege           |         |
| 14:13 |  FS  | Floating-Point Status                |    *    |
| 16:15 |  XS  | Extension Status                     |    *    |
|  17   | MPRV | Memory Privilege                     |         |
|  18   | SUM  | Supervisor User Memory Access        |    *    |
|  19   | MXR  | Make Executable Readable             |    *    |
|  20   | TVM  | Trap Virtual Memory                  |         |
|  21   |  TW  | Time Wait                            |         |
|  22   | TSR  | Trap SRET                            |         |
|  31   |  SD  | State Dirty                          |    *    |
## mie/sie
| bit | name |               function               | sie |
| :-: | :--: | :----------------------------------: | :-: |
|  0  | USIE | User Software Interrupt Enable       |  *  |
|  1  | SSIE | Supervisor Software Interrupt Enable |  *  |
|  3  | MSIE | Machine Software Interrupt Enable    |     |
|  4  | UTIE | User Timer Interrupt Enable          |  *  |
|  5  | STIE | Supervisor Timer Interrupt Enable    |  *  |
|  7  | MTIE | Machine Timer Interrupt Enable       |     |
|  8  | UEIE | User External Interrupt Enable       |  *  |
|  9  | SEIE | Supervisor External Interrupt Enable |  *  |
| 11  | MEIE | Machine External Interrupt Enable    |     |
## mtvec/stvec
| mtvec[1:0] |            address            |
| :--------: | :---------------------------: |
|     00     | mtvec                         |
|     01     | mtvec + mcause.Async_Code * 4 |
## mcause/scause
| bit  |      name      |
| :--: | :------------: |
| 30:0 | Exception Code |
|  31  | Interrupt      |
## mepc/sepc
## medeleg/mideleg
## mip/sip
## mtval/stval
## mscratch/sscratch
## pmpcfg0-pmpcfg3
* 编址 0x3A0-0x3A3
* pmpcfg 包含 4 个 8 位的控制块
* 控制块结构：

| bit | name |       function        |
| :-: | :--: | :-------------------: |
|  0  |  R   | Read                  |
|  1  |  W   | Write                 |
|  2  |  X   | Execute               |
| 4:3 |  A   | Address Matching Mode |
|  7  |  L   | Lock                  |
* Address Matching Mode:

| code | name  |            function            |                                      address                                       |
| :--: | :---: | :----------------------------: | :--------------------------------------------------------------------------------: |
|  00  |  OFF  |                                |                                                                                    |
|  01  |  TOR  | Top of Range                   | pmpaddr[i - 1] << 2 ~ pmpaddr[i] << 2 - 1                                          |
|  10  |  NA4  | Naturally Aligned 4-Byte       | pmpaddr[i] << 2 ~ pmpaddr[i] << 2 + 3                                              |
|  11  | NAPOT | Naturally Aligned Power-of-Two | startaddr = pmpaddr[i] 清除尾部连续 1 后左移 2，大小 = 2 ^ (尾部连续 1 的个数 + 3) |
## pmpaddr0-pmpaddr15
* 编址 0x3B0-0x3BF
## misa
|  bit  |    name    |  function   |
| :---: | :--------: | :---------: |
| 31:30 | MXLEN      | Word Length |
| 25:0  | Extensions |             |
* MXLEN:

| code | length |
| :--: | :----: |
|  01  |   32   |
|  10  |   64   |
|  11  |  128   |
## satp
|  bit  | name |         function         |
| :---: | :--: | :----------------------: |
|  31   | MODE |                          |
| 30:22 | ASID | Address Space Identifier |
| 21:0  | PPN  | Physical Page Number     |
# 异常和中断
## 异常类型
|  code  |              name              |
| :----: | :----------------------------: |
|  0000  | Instruction address misaligned |
|  0001  | Instruction access fault       |
|  0010  | Illegal instruction            |
|  0011  | Breakpoint                     |
|  0100  | Load address misaligned        |
|  0101  | Load access fault              |
|  0110  | Store/AMO address misaligned   |
|  0111  | Store/AMO access fault         |
|  1000  | Environment call from U-mode   |
|  1001  | Environment call from S-mode   |
|  1011  | Environment call from M-mode   |
|  1100  | Instruction page fault         |
|  1101  | Load page fault                |
|  1111  | Store/AMO page fault           |
## 中断类型
|  code  |              name              |
| :----: | :----------------------------: |
|  0000  | User software interrupt        |
|  0001  | Supervisor software interrupt  |
|  0011  | Machine software interrupt     |
|  0100  | User timer interrupt           |
|  0101  | Supervisor timer interrupt     |
|  0111  | Machine timer interrupt        |
|  1000  | User external interrupt        |
|  1001  | Supervisor external interrupt  |
|  1011  | Machine external interrupt     |

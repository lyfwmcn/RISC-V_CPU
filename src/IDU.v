`timescale 1ns / 1ns

module IDU (
    input [31:0] Instr,
    output Ebreak,
    output Ecall,
    output InstrFault,
    output BusAused,
    output BusBused,
    output CSRWr,
    output DataREN,
    output DataWEN,
    output PredTaken,
    output RegWr,
    output [1:0] ALUASrc,
    output [1:0] ALUBSrc,
    output [1:0] CSRSrc,
    output [2:0] MemCtr,
    output [2:0] RegSrc,
    output [4:0] BranchCtr,
    output [4:0] Rd,
    output [4:0] Rs1,
    output [4:0] Rs2,
    output [5:0] ALUCtr,
    output [11:0] CSRRd,
    output [31:0] imm
);

wire [6:0] opcode;
wire [2:0] funct3;
wire [6:0] funct7;
wire [4:0] _Rs1;
wire [4:0] _Rs2;
wire [4:0] _Rd;

assign opcode = Instr[6:0];
assign funct3 = Instr[14:12];
assign funct7 = Instr[31:25];
assign _Rs1 = Instr[19:15];
assign _Rs2 = Instr[24:20];
assign _Rd = Instr[11:7];

wire [3:0] optype;

assign optype = opcode == 7'h73 ? (funct3 == 3'h0 ? 4'hc : (funct3 > 3'h4 ? 4'hb : 4'ha)) :  // SYSTEM
                opcode == 7'h6f ? 4'h9 :  // J
                opcode == 7'h63 ? 4'h8 :  // B
                opcode == 7'h23 ? 4'h7 :  // S
                opcode == 7'h17 ? 4'h6 :  // auipc
                opcode == 7'h37 ? 4'h5 :  // lui
                opcode == 7'h67 ? 4'h4 :  // jalr
                opcode == 7'h3  ? 4'h3 :  // load
                opcode == 7'h13 ? 4'h2 :  // I
                opcode == 7'h33 ? 4'h1 :  // R
                4'h0;                     // invalid

wire [31:0] _imm;
assign _imm = optype == 4'h7 ? {{20{Instr[31]}}, Instr[31:25], Instr[11:7]} :
              optype == 4'h8 ? {{19{Instr[31]}}, Instr[31], Instr[7], Instr[30:25], Instr[11:8], 1'h0} :
              optype == 4'h9 ? {{11{Instr[31]}}, Instr[31], Instr[19:12], Instr[20], Instr[30:21], 1'h0} :
              optype == 4'h5 || optype == 4'h6 ? {Instr[31:12], 12'h0} :
              optype == 4'h2 && (funct3 == 3'h1 || funct3 == 3'h5) ? {27'h0, Instr[24:20]} :
              optype >= 4'h2 && optype <= 4'h4 ? {{20{Instr[31]}}, Instr[31:20]} :
              optype == 4'hb ? {27'h0, _Rs1} :
              32'h0;

wire InstrFaults [15:0];
assign InstrFaults[0] = 1'h1;
// invalid 指令错误
assign InstrFaults[1] = funct7[6] != 1'h0 || funct7[4:0] != 5'h0 || (funct3 != 3'h0 && funct3 != 3'h5 && funct7[5] == 1'h1);
// R 型指令检查 funct7
assign InstrFaults[2] = (funct3 == 3'h1 && _imm[11:5] != 7'h0) || (funct3 == 3'h5 && (_imm[11] != 1'h0 || _imm[9:5] != 5'h0));
// I 型指令检查 srli 和 srai 的 funct7
assign InstrFaults[3] = funct3 == 3'h3 || funct3 == 3'h6 || funct3 == 3'h7;
// load 型指令检查 funct3
assign InstrFaults[4] = funct3 != 3'h0;
// jalr 检查 funct3
assign InstrFaults[5] = 1'h0;
// lui 无错误
assign InstrFaults[6] = 1'h0;
// auipc 无错误
assign InstrFaults[7] = funct3 > 3'h2;
// S 型指令检查 funct3
assign InstrFaults[8] = funct3 == 3'h2 || funct3 == 3'h3;
// B 型指令检查 funct3
assign InstrFaults[9] = 1'h0;
// J 型指令无错误
assign InstrFaults[10] = funct3 == 3'h4;
// SYSTEM 型指令（funct3 == 1, 2, 3, 4）
assign InstrFaults[11] = 1'h0;
// SYSTEM 型指令（funct3 == 5, 6, 7）
assign InstrFaults[12] = _Rs1 != 5'h0 || _Rd != 5'h0 || (_imm != 32'h0 && _imm != 32'h1 && _imm != 32'h302);
// SYSTEM 型指令（funct3 == 0）
assign InstrFaults[13] = 1'h1;
assign InstrFaults[14] = 1'h1;
assign InstrFaults[15] = 1'h1;
assign InstrFault = InstrFaults[optype];

assign Ebreak = InstrFault == 1'h0 && optype == 4'hc && _imm == 32'h1;
assign Ecall = InstrFault == 1'h0 && optype == 4'hc && _imm == 32'h0;
assign RegWr = InstrFault == 1'h1 ? 1'h1 : optype != 4'h7 && optype != 4'h8 && optype != 4'hc;
assign CSRWr = InstrFault == 1'h0 && (optype == 4'ha || optype == 4'hb);
assign BusAused = InstrFault == 1'h1 ? 1'h1 : optype != 4'h5 && optype != 4'h6 && optype != 4'h9 && optype != 4'hb && optype != 4'hc;
assign BusBused = InstrFault == 1'h0 && (optype == 4'h1 || optype == 4'h7 || optype == 4'h8);
assign PredTaken = InstrFault == 1'h0 && ((optype == 4'h8 && _imm[31] == 1'h1) || optype == 4'h9);
assign DataREN = InstrFault == 1'h0 && optype == 4'h3 ? 1'h1 : 1'h0;
assign DataWEN = InstrFault == 1'h0 && optype == 4'h7 ? 1'h1 : 1'h0;
assign CSRSrc = InstrFault == 1'h1 ? 2'h0 :
                optype == 4'ha ? (funct3 == 3'h1 ? 2'h1 : 2'h0) :
                optype == 4'hb ? (funct3 == 3'h5 ? 2'h2 : 2'h0) :
                2'h0;
assign ALUASrc = InstrFault == 1'h1 ? 2'h0 :
                 optype == 4'h6 ? 2'h1 :
                 optype == 4'hb ? 2'h2 :
                 2'h0;
assign ALUBSrc = InstrFault == 1'h1 ? 2'h1 :
                 optype == 4'h1 || optype == 4'h8 ? 2'h0 :
                 optype == 4'ha || optype == 4'hb ? (funct3[1:0] == 2'h2 || funct3[1:0] == 2'h3 ? 2'h2 : 2'h0) :
                 2'h1;
assign RegSrc = InstrFault == 1'h1 ? 3'h0 :
                optype == 4'h5 ? 3'h3 :
                optype == 4'h3 ? 3'h2 :
                optype == 4'h4 || optype == 4'h9 ? 3'h1 :
                optype == 4'ha || optype == 4'hb ? 3'h4 :
                3'h0;
assign MemCtr = InstrFault == 1'h0 ? funct3 : 3'h2;
assign BranchCtr = InstrFault == 1'h1 ? 5'h0 :
                   optype == 4'h8 ? {2'h1, funct3} :
                   optype == 4'h9 ? 5'h10 :
                   optype == 4'h4 ? 5'h18 :
                   5'h0;
assign Rs1 = InstrFault == 1'h0 ? _Rs1 : 5'h0;
assign Rs2 = InstrFault == 1'h0 ? _Rs2 : 5'h0;
assign Rd = InstrFault == 1'h0 ? _Rd : 5'h0;
assign ALUCtr = InstrFault == 1'h1 ? 6'h0 :
                optype == 4'h1 ? {2'h0, funct7[5], funct3} :
                optype == 4'h2 ? {2'h0, funct3 == 3'h5 ? funct7[5] : 1'h0, funct3} :
                optype == 4'h8 ? 6'h8 :
                optype == 4'ha || optype == 4'hb ? (funct3[1:0] == 2'h2 ? 6'h6 : (funct3[1:0] == 2'h3 ? 6'h17 : 6'h0)) :
                6'h0;
assign CSRRd = InstrFault == 1'h1 ? 12'h0 :
               optype == 4'ha || optype == 4'hb ? Instr[31:20] :
               12'h0;
assign imm = InstrFault == 1'h0 ? _imm : 32'h0;

endmodule

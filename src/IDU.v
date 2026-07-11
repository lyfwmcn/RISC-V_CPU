`include "defines.vh"

module IDU (
    input [31:0] Instr,
    output InstrError,
    output RegWr,
    output BusAused,
    output BusBused,
    output ALUASrc,
    output ALUBSrc,
    output [1:0] PCCtr,
    output [1:0] RegSrc,
    output [2:0] BranchCtr,
    output [3:0] ALUCtr,
    output [3:0] MemCtr,
    output [4:0] Rs1,
    output [4:0] Rs2,
    output [4:0] Rd,
    output [31:0] imm
);

wire [6:0] opcode;
wire [2:0] funct3;
wire [6:0] funct7;

assign funct7 = Instr[31:25];
assign Rs2 = Instr[24:20];
assign Rs1 = Instr[19:15];
assign funct3 = Instr[14:12];
assign Rd = Instr[11:7];
assign opcode = Instr[6:0];

wire [3:0] optype;

assign optype = opcode == 7'h73 ? 4'ha :  // env
                opcode == 7'h6f ? 4'h9 :  // J
                opcode == 7'h63 ? 4'h8 :  // B
                opcode == 7'h23 ? 4'h7 :  // S
                opcode == 7'h17 ? 4'h6 :  // auipc
                opcode == 7'h37 ? 4'h5 :  // lui
                opcode == 7'h67 ? 4'h4 :  // jalr
                opcode == 7'h3 ? 4'h3 :   // load
                opcode == 7'h13 ? 4'h2 :  // I
                opcode == 7'h33 ? 4'h1 :  // R
                4'h0;

wire [15:0] InstrErrors;
assign InstrErrors[0] = 1'h1;
assign InstrErrors[1] = funct7[6] != 1'h0 || funct7[4:0] != 5'h0 || (funct3 != 3'h0 && funct3 != 3'h5 && funct7[5] != 1'h0);
assign InstrErrors[2] = (funct3 == 3'h1 && imm[11:5] != 7'h0) || (funct3 == 3'h5 && imm[10:5] != 6'h0);
assign InstrErrors[3] = funct3 == 3'h3 || funct3 == 3'h6 || funct3 == 3'h7;
assign InstrErrors[4] = funct3 != 3'h0;
assign InstrErrors[5] = 1'h0;
assign InstrErrors[6] = 1'h0;
assign InstrErrors[7] = funct3 > 3'h2;
assign InstrErrors[8] = funct3 == 3'h2 || funct3 == 3'h3 || imm[1] != 1'h0;
assign InstrErrors[9] = imm[1] != 1'h0;
assign InstrErrors[10] = imm[11:1] != 11'h0 || funct3 != 3'h0 || Rs1 != 5'h0 || Rd != 5'h0;
assign InstrErrors[11] = 1'h1;
assign InstrErrors[12] = 1'h1;
assign InstrErrors[13] = 1'h1;
assign InstrErrors[14] = 1'h1;
assign InstrErrors[15] = 1'h1;
assign InstrError = InstrErrors[optype];

assign RegWr = optype != 4'h7 && optype != 4'h8 && optype != 4'ha;
assign BusAused = optype != 4'h0 && optype != 4'h5 && optype != 4'h6 && optype != 4'h9;
assign BusBused = optype == 4'h1 || optype == 4'h7 || optype == 4'h8;
assign ALUASrc = optype == 4'h6;
assign ALUBSrc = optype != 4'h1 && optype != 4'h8;
assign PCCtr = optype == 4'h4 ? 2'h3 :
               optype == 4'h8 || optype == 4'h9 ? 2'h2 :
               2'h0;
assign RegSrc = optype == 4'h5 ? 2'h3 :
                optype == 4'h3 ? 2'h2 :
                optype == 4'h4 || optype == 4'h9 ? 2'h1 :
                2'h0;
assign BranchCtr = optype == 4'h8 ? funct3 : 3'h2;
assign ALUCtr = optype == 4'h1 ? {funct7[5], funct3} :
                optype == 4'h2 ? {funct3 == 3'h5 ? funct7[5] : 1'h0, funct3} :
                optype == 4'h8 ? 4'h8 :
                4'h0;
assign MemCtr = {optype == 4'h7 ? 1'h1 : 1'h0, funct3};
assign imm = optype == 4'h7 ? {{20{Instr[31]}}, Instr[31:25], Instr[11:7]} :
             optype == 4'h8 ? {{19{Instr[31]}}, Instr[31], Instr[7], Instr[30:25], Instr[11:8], 1'h0} :
             optype == 4'h9 ? {{11{Instr[31]}}, Instr[31], Instr[19:12], Instr[20], Instr[30:21], 1'h0} :
             optype == 4'h5 || optype == 4'h6 ? {Instr[31:12], 12'h0} :
             optype == 4'h2 && (funct3 == 3'h1 || funct3 == 3'h5) ? {27'h0, Instr[24:20]} :
             (optype >= 4'h2 && optype <= 4'h4) || optype == 4'ha ? {{20{Instr[31]}}, Instr[31:20]} :
             32'h0;

endmodule

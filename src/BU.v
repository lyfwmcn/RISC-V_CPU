`timescale 1ns / 1ns

module BU (
    input ZF,
    input CF,
    input SF,
    input OF,
    input IDPredTaken,
    input MPredTaken,
    input [4:0] IDBranchCtr,
    input [4:0] MBranchCtr,
    input [31:0] BusW,
    input [31:0] IDimm,
    input [31:0] IDPC,
    input [31:0] Mimm,
    input [31:0] MPC,
    output Jump,
    output PredJump,
    output [1:0] PCCtr,
    output [31:0] _imm,
    output [31:0] _PC
);

wire [4:0] _MBranchCtr;
assign _MBranchCtr = MBranchCtr[4:3] == 2'h1 ? ((MBranchCtr[2:0] == 3'h2 || MBranchCtr[2:0] == 3'h3) ? 5'h0 : MBranchCtr) : (MBranchCtr[2:0] != 3'h0 ? 5'h0 : MBranchCtr);

// 部分仅仿真
// ------------------------------------------------------------
wire [4:0] _IDBranchCtr;
assign _IDBranchCtr = IDBranchCtr === 5'hx ? 5'h0 :
                      IDBranchCtr[4:3] == 2'h1 ? ((IDBranchCtr[2:0] == 3'h2 || IDBranchCtr[2:0] == 3'h3) ? 5'h0 : IDBranchCtr) : (IDBranchCtr[2:0] != 3'h0 ? 5'h0 : IDBranchCtr);
wire _IDPredTaken;
assign _IDPredTaken = IDPredTaken === 1'hx ? 1'h0 :
                      (_IDBranchCtr[4:3] == 2'h0 || _IDBranchCtr[4:3] == 2'h3) && IDPredTaken == 1'h1 ? 1'h0 :
                      IDPredTaken;
wire [31:0] _IDimm;
assign _IDimm = IDimm === 32'hx ? 32'h0 : IDimm;
wire [31:0] _IDPC;
assign _IDPC = IDPC === 32'hx ? 32'h0 : IDPC;
wire _MPredTaken;
assign _MPredTaken = MPredTaken == 1'h1 && (_MBranchCtr[4:3] == 2'h0 || _MBranchCtr[4:3] == 2'h3) ? 1'h0 : MPredTaken;
// ------------------------------------------------------------

wire condsatisfieds [7:0];
assign condsatisfieds[0] = ZF == 1'h1;
assign condsatisfieds[1] = ZF == 1'h0;
assign condsatisfieds[4] = SF ^ OF == 1'h1;
assign condsatisfieds[5] = SF ^ OF == 1'h0;
assign condsatisfieds[6] = CF == 1'h1;
assign condsatisfieds[7] = CF == 1'h0;

assign condsatisfieds[2] = 1'h0;
assign condsatisfieds[3] = 1'h0;

wire condsatisfied;
assign condsatisfied = condsatisfieds[_MBranchCtr[2:0]];

wire [2:0] Cond;
wire [2:0] Conds [3:0];
assign Conds[0] = _IDPredTaken == 1'h1 ? 3'h1 : 3'h0;
assign Conds[1] = condsatisfied == 1'h1 ? (_MPredTaken == 1'h1 ? (_IDPredTaken == 1'h1 ? 3'h1 : 3'h0) : 3'h2) :
                  (_MPredTaken == 1'h1 ? 3'h4 : (_IDPredTaken == 1'h1 ? 3'h1 : 3'h0));
assign Conds[2] = _MPredTaken == 1'h1 ? (_IDPredTaken == 1'h1 ? 3'h1 : 3'h0) : 3'h2;
assign Conds[3] = 3'h3;
assign Cond = Conds[_MBranchCtr[4:3]];

assign Jump = Cond >= 3'h2 && Cond <= 3'h4;
assign PredJump = Cond == 3'h1;
assign PCCtr = Cond == 3'h0 ? 2'h0 :
               Cond == 3'h3 ? 2'h3 :
               Cond <= 3'h4 ? 2'h2 :
               2'h0;
assign _imm = Cond == 3'h0 ? 32'h0 :
              Cond == 3'h1 ? _IDimm :
              Cond == 3'h2 ? Mimm :
              Cond == 3'h3 ? BusW :
              Cond == 3'h4 ? 32'h4 :
              32'h0;
assign _PC = Cond == 3'h0 ? 32'h0 :
             Cond == 3'h1 ? _IDPC :
             Cond == 3'h3 ? 32'h0 :
             Cond <= 3'h4 ? MPC :
             32'h0;

endmodule

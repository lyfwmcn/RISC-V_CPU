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
                      _IDBranchCtr[4:3] == 2'h3 && IDPredTaken == 1'h1 ? 1'h0 :
                      IDPredTaken;
wire [31:0] _IDimm;
assign _IDimm = IDimm === 32'hx ? 32'h0 : IDimm;
wire [31:0] _IDPC;
assign _IDPC = IDPC === 32'hx ? 32'h0 : IDPC;
wire _MPredTaken;
assign _MPredTaken = MPredTaken == 1'h1 && _MBranchCtr[4:3] == 2'h3 ? 1'h0 : MPredTaken;
// ------------------------------------------------------------

wire condsatisfied [7:0];
assign condsatisfied[0] = ZF == 1'h1;
assign condsatisfied[1] = ZF == 1'h0;
assign condsatisfied[4] = SF ^ OF == 1'h1;
assign condsatisfied[5] = SF ^ OF == 1'h0;
assign condsatisfied[6] = CF == 1'h1;
assign condsatisfied[7] = CF == 1'h0;

assign condsatisfied[2] = 1'h0;
assign condsatisfied[3] = 1'h0;

// M 阶段指令 PCCtr 经过 BranchCtr 处理后得到 PCCtr1
wire [1:0] PCCtr1;
assign PCCtr1 = condsatisfied[_MBranchCtr[2:0]] == 1'h1 ? 2'h2 : 2'h0;

// 根据 ID 阶段指令和 M 阶段指令是否提前改变 PC 和 PCCtr1 是否为 0 分出 8 种情况
wire [2:0] Cond;
assign Cond = {_IDPredTaken, _MPredTaken, PCCtr1 != 2'h0};

// _PCCtrs[Cond] 得到最终 PCCtr
wire [1:0] PCCtrs [7:0];
assign PCCtrs[0] = 2'h0;
assign PCCtrs[1] = PCCtr1;
assign PCCtrs[2] = 2'h2;
assign PCCtrs[3] = 2'h0;
assign PCCtrs[4] = 2'h2;
assign PCCtrs[5] = PCCtr1;
assign PCCtrs[6] = 2'h2;
assign PCCtrs[7] = 2'h2;
assign PCCtr = PCCtrs[Cond];

wire [31:0] _Mimms [3:0];
assign _Mimms[0] = 32'h0;
assign _Mimms[1] = 32'h0;
assign _Mimms[2] = Mimm;
assign _Mimms[3] = BusW;

assign _imm = Cond == 3'h4 || Cond == 3'h7 ? _IDimm :
              Cond == 3'h2 || Cond == 3'h6 ? 32'h4 : _Mimms[PCCtr];
assign _PC = Cond == 3'h4 || Cond == 3'h7 ? _IDPC : MPC;
assign Jump = Cond != 3'h4 && Cond != 3'h7 && PCCtr != 2'h0;
assign PredJump = (Cond == 3'h4 || Cond == 3'h7) && PCCtr != 2'h0;

endmodule

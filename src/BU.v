`include "defines.vh"

/*
 * ZF ~ OF: EX 阶段的标志信号
 * MPredTaken：当前 M 阶段的指令是否提前修改了 PC
 * IDPredTaken：当前 ID 阶段的指令是否要提前修改 PC
 * MPCCtr：当前 M 阶段的指令的原始 PCCtr
 * IDPCCtr: 当前 ID 阶段的指令的原始 PCCtr
 * BranchCtr: 控制最终 PCCtr 是否变成 0 的条件的信号
 * Mimm: 当前 M 阶段的 imm
 * IDimm: 当前 ID 阶段的 imm
 * BusW: 当前 M 阶段的 BusW
 * MPC: 当前 M 阶段的 PC
 * IDPC: 当前 ID 阶段的 PC
 * Jump: M 阶段指令是否跳转
 * PredJump: ID 阶段指令是否跳转
 * _PCCtr: 接入 PC 的最终 PCCtr
 * _imm: 接入 PC 的最终 imm
 * _PC: 接入 PC 的最终 PC
 * 异常处理：
 * BranchCtr = 3：可避免异常。发生时 PC + 4
 * IDPredTaken = 1 同时 IDPCCtr = 3：可避免异常。发生时 IDPredTaken = 0
 * MPredTaken = 1 同时 MPCCtr = 3：可避免异常。发生时 MPredTaken = 0
 */
module BU (
    input ZF,
    input CF,
    input SF,
    input OF,
    input MPredTaken,
    input IDPredTaken,
    input [1:0] MPCCtr,
    input [1:0] IDPCCtr,
    input [2:0] BranchCtr,
    input [31:0] Mimm,
    input [31:0] IDimm,
    input [31:0] BusW,
    input [31:0] MPC,
    input [31:0] IDPC,
    output Jump,
    output PredJump,
    output [1:0] _PCCtr,
    output [31:0] _imm,
    output [31:0] _PC
);

// 部分仅仿真
// ------------------------------------------------------------
wire _IDPredTaken;
wire [1:0] _IDPCCtr;
wire [31:0] _IDimm;
wire [31:0] _IDPC;
assign _IDPredTaken = IDPredTaken === 1'hx ? 1'h0 :
                      _IDPCCtr == 2'h3 && IDPredTaken == 1'h1 ? 1'h0 :
                      IDPredTaken;
assign _IDPCCtr = IDPCCtr === 2'hx ? 2'h0 : IDPCCtr;
assign _IDimm = IDimm === 32'hx ? 32'h0 : IDimm;
assign _IDPC = IDPC === 32'hx ? 32'h0 : IDPC;
// ------------------------------------------------------------

wire _MPredTaken;
assign _MPredTaken = MPredTaken == 1'h1 && MPCCtr == 2'h3 ? 1'h0 : MPredTaken;

// PCCtrKeep[BranchCtr] 得 M 阶段指令 PCCtr 是否保持不变
wire PCCtrKeep [7:0];

assign PCCtrKeep[0] = ZF == 1'h1;
assign PCCtrKeep[1] = ZF == 1'h0;
assign PCCtrKeep[2] = 1'h1;
assign PCCtrKeep[4] = SF ^ OF == 1'h1;
assign PCCtrKeep[5] = SF ^ OF == 1'h0;
assign PCCtrKeep[6] = CF == 1'h1;
assign PCCtrKeep[7] = CF == 1'h0;

assign PCCtrKeep[3] = 1'h0;

// M 阶段指令 PCCtr 经过 BranchCtr 处理后得到 PCCtr1
wire [1:0] PCCtr1;
assign PCCtr1 = PCCtrKeep[BranchCtr] ? MPCCtr : 2'h0;

// 根据 ID 阶段指令和 M 阶段指令是否提前改变 PC 和 PCCtr1 是否为 0 分出 8 种情况
wire [2:0] Cond;
assign Cond = {_IDPredTaken, _MPredTaken, PCCtr1 != 2'h0};

// _PCCtrs[Cond] 得到最终 PCCtr
wire [1:0] _PCCtrs [7:0];
assign _PCCtrs[0] = 2'h0;
assign _PCCtrs[1] = PCCtr1;
assign _PCCtrs[2] = 2'h2;
assign _PCCtrs[3] = 2'h0;
assign _PCCtrs[4] = IDPCCtr;
assign _PCCtrs[5] = PCCtr1;
assign _PCCtrs[6] = 2'h2;
assign _PCCtrs[7] = IDPCCtr;
assign _PCCtr = _PCCtrs[Cond];

wire [31:0] _Mimms [3:0];
assign _Mimms[0] = 32'h0;
assign _Mimms[1] = 32'h0;
assign _Mimms[2] = Mimm;
assign _Mimms[3] = BusW;

wire [31:0] _IDimms [3:0];
assign _IDimms[0] = 32'h0;
assign _IDimms[1] = 32'h0;
assign _IDimms[2] = _IDimm;
assign _IDimms[3] = 32'h0;

assign _imm = Cond == 3'h4 || Cond == 3'h7 ? _IDimms[_PCCtr] :
              Cond == 3'h2 || Cond == 3'h6 ? 32'h4 : _Mimms[_PCCtr];
assign _PC = Cond == 3'h4 || Cond == 3'h7 ? _IDPC : MPC;
assign Jump = Cond != 3'h4 && Cond != 3'h7 && _PCCtr != 2'h0;
assign PredJump = (Cond == 3'h4 || Cond == 3'h7) && _PCCtr != 2'h0;

endmodule

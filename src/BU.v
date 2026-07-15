`include "defines.vh"

module BU (
    input ZF,
    input CF,
    input SF,
    input OF,
    input MPredTaken,
    input IDPredTaken,
    input [1:0] PCCtr,
    input [2:0] BranchCtr,
    input [31:0] Mimm,
    input [31:0] IDimm,
    input [31:0] BusW,
    input [31:0] MPC,
    input [31:0] IDPC,
    output BranchCtrError,
    output Jump,
    output PredJump,
    output [1:0] _PCCtr,
    output [31:0] _imm,
    output [31:0] _PC
);

// 仅仿真
// ------------------------------------------------------------
wire _IDPredTaken;
wire [31:0] _IDimm;
wire [31:0] _IDPC;
assign _IDPredTaken = IDPredTaken === 1'hx ? 1'h0 : IDPredTaken;
assign _IDimm = IDimm === 32'hx ? 1'h0 : IDimm;
assign _IDPC = IDPC === 32'hx ? 32'h0 : IDPC;
// ------------------------------------------------------------

assign BranchCtrError = BranchCtr == 3'h3;

wire PCCtrKeep [7:0];

assign PCCtrKeep[0] = ZF == 1'h1;
assign PCCtrKeep[1] = ZF == 1'h0;
assign PCCtrKeep[2] = 1'h1;
assign PCCtrKeep[4] = SF ^ OF == 1'h1;
assign PCCtrKeep[5] = SF ^ OF == 1'h0;
assign PCCtrKeep[6] = CF == 1'h1;
assign PCCtrKeep[7] = CF == 1'h0;

assign PCCtrKeep[3] = 1'h0;

wire [1:0] PCCtr1;

assign PCCtr1 = PCCtrKeep[BranchCtr] ? PCCtr : 2'h0;

wire [2:0] Cond;

assign Cond = {_IDPredTaken, MPredTaken, PCCtr1 != 2'h0};

wire [1:0] _PCCtrs [7:0];
assign _PCCtrs[0] = 2'h0;
assign _PCCtrs[1] = PCCtr1;
assign _PCCtrs[2] = 2'h2;  // 更正
assign _PCCtrs[3] = 2'h0;
assign _PCCtrs[4] = 2'h2;  // 
assign _PCCtrs[5] = PCCtr1;
assign _PCCtrs[6] = 2'h2;  // 更正
assign _PCCtrs[7] = 2'h2;  // 
assign _PCCtr = _PCCtrs[Cond];

wire [31:0] _imms [3:0];

assign _imms[0] = 32'h0;
assign _imms[1] = 32'h0;
assign _imms[2] = Mimm;
assign _imms[3] = BusW;
assign _imm = Cond == 3'h4 || Cond == 3'h7 ? _IDimm :
              Cond == 3'h2 || Cond == 3'h6 ? 32'h4 : _imms[_PCCtr];

assign _PC = Cond == 3'h4 || Cond == 3'h7 ? _IDPC : MPC;

assign Jump = Cond != 3'h4 && Cond != 3'h7 && _PCCtr != 2'h0;
assign PredJump = Cond == 3'h4 || Cond == 3'h7;

endmodule

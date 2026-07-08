module BU (
    input ZF,
    input CF,
    input SF,
    input OF,
    input [1:0] PCCtr,
    input [2:0] BranchCtr,
    input [31:0] imm,
    input [31:0] BusW,
    output BranchCtrError,
    output [1:0] _PCCtr,
    output [31:0] _imm,
    output Jump
);

assign BranchCtrError = BranchCtr == 3'h3;

wire [1:0] _PCCtrs [7:0];

assign _PCCtrs[0] = ZF == 1'h1 ? PCCtr : 2'h0;
assign _PCCtrs[1] = ZF == 1'h0 ? PCCtr : 2'h0;
assign _PCCtrs[2] = PCCtr;
assign _PCCtrs[4] = SF ^ OF == 1'h1 ? PCCtr : 2'h0;
assign _PCCtrs[5] = SF ^ OF == 1'h0 ? PCCtr : 2'h0;
assign _PCCtrs[6] = CF == 1'h1 ? PCCtr : 2'h0;
assign _PCCtrs[7] = CF == 1'h0 ? PCCtr : 2'h0;

assign _PCCtrs[3] = 2'h0;

assign _PCCtr = _PCCtrs[BranchCtr];

wire [31:0] _imms [3:0];

assign _imms[0] = 32'h0;
assign _imms[1] = 32'h0;
assign _imms[2] = imm;
assign _imms[3] = BusW;
assign _imm = _imms[_PCCtr];

assign Jump = _PCCtr == 2'h2 || _PCCtr == 2'h3;

endmodule

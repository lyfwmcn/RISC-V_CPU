`include "defines.vh"

module CPU (
    input CLK,
    input RST
);

wire [31:0] IFPC;
wire [31:0] IFnextPC;

wire IDALUASrc;
wire IDALUBSrc;
wire IDRegWr;
wire IDBusAused;
wire IDBusBused;
wire [1:0] IDPCCtr;
wire [1:0] IDRegSrc;
wire [2:0] IDBranchCtr;
wire [3:0] IDALUCtr;
wire [3:0] IDMemCtr;
wire [4:0] IDRd;
wire [4:0] IDRs1;
wire [4:0] IDRs2;
wire [31:0] IDimm;
wire [31:0] IDPC;
wire [31:0] IDnextPC;
wire [31:0] IDBusA;
wire [31:0] IDBusB;
wire [31:0] IDInstr;
wire [31:0] ID_BusA;
wire [31:0] ID_BusB;

wire EXZF;
wire EXCF;
wire EXSF;
wire EXOF;
wire EXRegWr;
wire EXALUASrc;
wire EXALUBSrc;
wire [1:0] EXPCCtr;
wire [1:0] EXRegSrc;
wire [2:0] EXBranchCtr;
wire [3:0] EXALUCtr;
wire [3:0] EXMemCtr;
wire [4:0] EXRd;
wire [31:0] EXimm;
wire [31:0] EXPC;
wire [31:0] EXnextPC;
wire [31:0] EXBusW;
wire [31:0] EXBusA;
wire [31:0] EXBusB;
wire [31:0] EX_BusA;
wire [31:0] EX_BusB;

assign EX_BusA = EXALUASrc == 1'h0 ? EXBusA : EXPC;
assign EX_BusB = EXALUBSrc == 1'h0 ? EXBusB : EXimm;

wire MZF;
wire MCF;
wire MSF;
wire MOF;
wire MRegWr;
wire [1:0] MPCCtr;
wire [1:0] MRegSrc;
wire [1:0] M_PCCtr;
wire [2:0] MBranchCtr;
wire [4:0] MRd;
wire [31:0] Mimm;
wire [31:0] M_imm;
wire [31:0] MPC;
wire [31:0] MnextPC;
wire [31:0] MBusW;
wire [31:0] Mmem;

wire WBRegWr;
wire [1:0] WBRegSrc;
wire [4:0] WBRd;
wire [31:0] WBimm;
wire [31:0] WBnextPC;
wire [31:0] WBBusW;
wire [31:0] WBmem;
wire [31:0] WB_BusW;

assign WB_BusW = WBRegSrc == 2'h0 ? WBBusW :
                 WBRegSrc == 2'h1 ? WBnextPC :
                 WBRegSrc == 2'h2 ? WBmem : WBimm;

wire Wait;
wire Jump;
wire IDRegCLR = Wait | Jump;

PC PC (
    .CLK(CLK),
    .RST(RST),
    .Wait(Wait),
    .PCCtr(M_PCCtr),
    .lastPC(MPC),
    .imm(M_imm),
    .lastPCError(),
    .immError(),
    .PC(IFPC),
    .nextPC(IFnextPC)
);

MM MM (
    .CLK(CLK),
    .PCEN(Wait),
    .PCCLR(Jump),
    .MemCtr(EXMemCtr),
    .DataIn(EXBusB),
    .PC(IFPC),
    .Addr(EXBusW),
    .PCAlignError(),
    .AddrAlignError(),
    .PCOverflowError(),
    .AddrOverflowError(),
    .MemCtrError(),
    .Instr(IDInstr),
    .DataOut(Mmem)
);

IFReg IFReg (
    .CLK(CLK),
    .RST(RST),
    .EN(~Wait),
    .CLR(Jump),
    .PC(IFPC),
    .nextPC(IFnextPC),
    ._PC(IDPC),
    ._nextPC(IDnextPC)
);

IDU IDU (
    .Instr(IDInstr),
    .InstrError(),
    .RegWr(IDRegWr),
    .BusAused(IDBusAused),
    .BusBused(IDBusBused),
    .ALUASrc(IDALUASrc),
    .ALUBSrc(IDALUBSrc),
    .PCCtr(IDPCCtr),
    .RegSrc(IDRegSrc),
    .BranchCtr(IDBranchCtr),
    .ALUCtr(IDALUCtr),
    .MemCtr(IDMemCtr),
    .Rs1(IDRs1),
    .Rs2(IDRs2),
    .Rd(IDRd),
    .imm(IDimm)
);

RegFile RegFile (
    .CLK(CLK),
    .RST(RST),
    .RegWr(WBRegWr),
    .Rd(WBRd),
    .Rs1(IDRs1),
    .Rs2(IDRs2),
    .BusW(WB_BusW),
    .BusA(IDBusA),
    .BusB(IDBusB)
);

IDReg IDReg (
    .CLK(CLK),
    .RST(RST),
    .EN(1'h1),
    .CLR(IDRegCLR),
    .ALUASrc(IDALUASrc),
    .ALUBSrc(IDALUBSrc),
    .RegWr(IDRegWr),
    .PCCtr(IDPCCtr),
    .RegSrc(IDRegSrc),
    .BranchCtr(IDBranchCtr),
    .ALUCtr(IDALUCtr),
    .MemCtr(IDMemCtr),
    .Rd(IDRd),
    .imm(IDimm),
    .PC(IDPC),
    .nextPC(IDnextPC),
    .BusA(ID_BusA),
    .BusB(ID_BusB),
    ._ALUASrc(EXALUASrc),
    ._ALUBSrc(EXALUBSrc),
    ._RegWr(EXRegWr),
    ._PCCtr(EXPCCtr),
    ._RegSrc(EXRegSrc),
    ._BranchCtr(EXBranchCtr),
    ._ALUCtr(EXALUCtr),
    ._MemCtr(EXMemCtr),
    ._Rd(EXRd),
    ._imm(EXimm),
    ._PC(EXPC),
    ._nextPC(EXnextPC),
    ._BusA(EXBusA),
    ._BusB(EXBusB)
);

ALU ALU (
    .ALUCtr(EXALUCtr),
    .BusA(EX_BusA),
    .BusB(EX_BusB),
    .ALUCtrError(),
    .OperError(),
    .ZF(EXZF),
    .CF(EXCF),
    .SF(EXSF),
    .OF(EXOF),
    .BusW(EXBusW)
);

EXReg EXReg (
    .CLK(CLK),
    .RST(RST),
    .EN(1'h1),
    .CLR(Jump),
    .ZF(EXZF),
    .CF(EXCF),
    .SF(EXSF),
    .OF(EXOF),
    .RegWr(EXRegWr),
    .PCCtr(EXPCCtr),
    .RegSrc(EXRegSrc),
    .BranchCtr(EXBranchCtr),
    .Rd(EXRd),
    .imm(EXimm),
    .PC(EXPC),
    .nextPC(EXnextPC),
    .BusW(EXBusW),
    ._ZF(MZF),
    ._CF(MCF),
    ._SF(MSF),
    ._OF(MOF),
    ._RegWr(MRegWr),
    ._PCCtr(MPCCtr),
    ._RegSrc(MRegSrc),
    ._BranchCtr(MBranchCtr),
    ._Rd(MRd),
    ._imm(Mimm),
    ._PC(MPC),
    ._nextPC(MnextPC),
    ._BusW(MBusW)
);

BU BU (
    .ZF(MZF),
    .CF(MCF),
    .SF(MSF),
    .OF(MOF),
    .PCCtr(MPCCtr),
    .BranchCtr(MBranchCtr),
    .imm(Mimm),
    .BusW(MBusW),
    .BranchCtrError(),
    ._PCCtr(M_PCCtr),
    ._imm(M_imm),
    .Jump(Jump)
);

MReg MReg (
    .CLK(CLK),
    .RST(RST),
    .EN(1'h1),
    .CLR(1'h0),
    .RegWr(MRegWr),
    .RegSrc(MRegSrc),
    .Rd(MRd),
    .imm(Mimm),
    .nextPC(MnextPC),
    .BusW(MBusW),
    .mem(Mmem),
    ._RegWr(WBRegWr),
    ._RegSrc(WBRegSrc),
    ._Rd(WBRd),
    ._imm(WBimm),
    ._nextPC(WBnextPC),
    ._BusW(WBBusW),
    ._mem(WBmem)
);

ByPass ByPass (
    .IDBusAused(IDBusAused),
    .IDBusBused(IDBusBused),
    .EXRegWr(EXRegWr),
    .MRegWr(MRegWr),
    .WBRegWr(WBRegWr),
    .EXRegSrc(EXRegSrc),
    .MRegSrc(MRegSrc),
    .IDRs1(IDRs1),
    .IDRs2(IDRs2),
    .EXRd(EXRd),
    .MRd(MRd),
    .WBRd(WBRd),
    .IDBusA(IDBusA),
    .IDBusB(IDBusB),
    .EXBusW(EXBusW),
    .MBusW(MBusW),
    .WB_BusW(WB_BusW),
    .EXnextPC(EXnextPC),
    .MnextPC(MnextPC),
    .EXimm(EXimm),
    .Mimm(Mimm),
    .Mmem(Mmem),
    .Wait(Wait),
    .ID_BusA(ID_BusA),
    .ID_BusB(ID_BusB)
);

endmodule

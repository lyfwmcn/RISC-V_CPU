`timescale 1ns/1ns

module CPU (
    input CLK,
    input RST
);

wire IFInstrAccessFault;
wire IFInstrPageFault;
wire [31:0] IFPC;
wire [31:0] IFPCPlus4;

wire IDEbreak;
wire IDEcall;
wire IDInstrAccessFault;
wire IDInstrPageFault;
wire IDInstrFault;
wire IDBusAused;
wire IDBusBused;
wire IDCSRWr;
wire IDDataREN;
wire IDDataWEN;
wire IDPredTaken;
wire IDRegWr;
wire [1:0] IDALUASrc;
wire [1:0] IDALUBSrc;
wire [1:0] IDCSRSrc;
wire [2:0] IDMemCtr;
wire [2:0] IDRegSrc;
wire [4:0] IDBranchCtr;
wire [4:0] IDRd;
wire [4:0] IDRs1;
wire [4:0] IDRs2;
wire [5:0] IDALUCtr;
wire [11:0] IDCSRRd;
wire [31:0] IDBusA;
wire [31:0] IDBusB;
wire [31:0] IDCSRout;
wire [31:0] IDimm;
wire [31:0] IDInstr;
wire [31:0] IDPC;
wire [31:0] IDPCPlus4;
wire [31:0] ID_BusA;
wire [31:0] ID_BusB;
wire [31:0] ID_CSRout;

wire EXEbreak;
wire EXEcall;
wire EXInstrAccessFault;
wire EXInstrPageFault;
wire EXInstrFault;
wire EXZF;
wire EXCF;
wire EXSF;
wire EXOF;
wire EXCSRWr;
wire EXDataREN;
wire EXDataWEN;
wire EXPredTaken;
wire EXRegWr;
wire [1:0] EXALUASrc;
wire [1:0] EXALUBSrc;
wire [1:0] EXCSRSrc;
wire [2:0] EXMemCtr;
wire [2:0] EXRegSrc;
wire [4:0] EXBranchCtr;
wire [4:0] EXRd;
wire [5:0] EXALUCtr;
wire [11:0] EXCSRRd;
wire [31:0] EXBusA;
wire [31:0] EXBusB;
wire [31:0] EXBusW;
wire [31:0] EXCSRout;
wire [31:0] EXimm;
wire [31:0] EXPC;
wire [31:0] EXPCPlus4;
wire [31:0] EX_BusA;
wire [31:0] EX_BusB;

assign EX_BusA = EXALUASrc == 2'h0 ? EXBusA :
                 EXALUASrc == 2'h1 ? EXPC :
                 EXALUASrc == 2'h2 ? EXimm :
                 32'h0;
assign EX_BusB = EXALUBSrc == 2'h0 ? EXBusB :
                 EXALUBSrc == 2'h1 ? EXimm :
                 EXALUBSrc == 2'h2 ? EXCSRout :
                 32'h0;

wire MEbreak;
wire MEcall;
wire MInstrAccessFault;
wire MInstrAlignFault;
wire MInstrPageFault;
wire MInstrFault;
wire MLoadAccessFault;
wire MLoadAlignFault;
wire MLoadPageFault;
wire MStoreAccessFault;
wire MStoreAlignFault;
wire MStorePageFault;
wire MZF;
wire MCF;
wire MSF;
wire MOF;
wire MCSRWr;
wire MDataREN;
wire MDataWEN;
wire MPredTaken;
wire MRegWr;
wire [1:0] MCSRSrc;
wire [1:0] MPCCtr;
wire [2:0] MMemCtr;
wire [2:0] MRegSrc;
wire [4:0] MBranchCtr;
wire [4:0] MRd;
wire [11:0] MCSRRd;
wire [31:0] MBusA;
wire [31:0] MBusB;
wire [31:0] MBusW;
wire [31:0] MCSRout;
wire [31:0] Mimm;
wire [31:0] MPC;
wire [31:0] MPCPlus4;
wire [31:0] M_imm;
wire [31:0] M_PC;

wire WBCSRWr;
wire WBRegWr;
wire [1:0] WBCSRSrc;
wire [2:0] WBRegSrc;
wire [4:0] WBRd;
wire [11:0] WBCSRRd;
wire [31:0] WBBusA;
wire [31:0] WBBusW;
wire [31:0] WBCSRin;
wire [31:0] WBCSRout;
wire [31:0] WBimm;
wire [31:0] WBmem;
wire [31:0] WBPCPlus4;
wire [31:0] WB_BusW;

assign WB_BusW = WBRegSrc == 3'h0 ? WBBusW :
                 WBRegSrc == 3'h1 ? WBPCPlus4 :
                 WBRegSrc == 3'h2 ? WBmem :
                 WBRegSrc == 3'h3 ? WBimm :
                 WBRegSrc == 3'h4 ? WBCSRout :
                 32'h0;
assign WBCSRin = WBCSRSrc == 2'h0 ? WBBusW :
                 WBCSRSrc == 2'h1 ? WBBusA :
                 WBCSRSrc == 2'h2 ? WBimm :
                 32'h0;

wire Wait;
wire Jump;
wire PredJump;

MemoryUnit MemoryUnit (
    .CLK(CLK),
    .RST(RST),
    .DataREN(MDataREN),
    .DataWEN(MDataWEN),
    .InstrCLR(Jump | PredJump),
    .InstrEN(~Wait),
    .MemCtr(MMemCtr),
    .DataAddr(MBusW),
    .DataIn(MBusB),
    .InstrAddr(IFPC),
    .InstrAccessFault(IFInstrAccessFault),
    .InstrPageFault(IFInstrPageFault),
    .LoadAccessFault(MLoadAccessFault),
    .LoadAlignFault(MLoadAlignFault),
    .LoadPageFault(MLoadPageFault),
    .StoreAccessFault(MStoreAccessFault),
    .StoreAlignFault(MStoreAlignFault),
    .StorePageFault(MStorePageFault),
    .DataOut(WBmem),
    .Instr(IDInstr)
);

PCReg PCReg (
    .CLK(CLK),
    .RST(RST),
    .Wait(Wait),
    .PCCtr(MPCCtr),
    .imm(M_imm),
    .lastPC(M_PC),
    .InstrAlignFault(MInstrAlignFault),
    .PC(IFPC),
    .PCPlus4(IFPCPlus4)
);

IDU IDU (
    .Instr(IDInstr),
    .Ebreak(IDEbreak),
    .Ecall(IDEcall),
    .InstrFault(IDInstrFault),
    .BusAused(IDBusAused),
    .BusBused(IDBusBused),
    .CSRWr(IDCSRWr),
    .DataREN(IDDataREN),
    .DataWEN(IDDataWEN),
    .PredTaken(IDPredTaken),
    .RegWr(IDRegWr),
    .ALUASrc(IDALUASrc),
    .ALUBSrc(IDALUBSrc),
    .CSRSrc(IDCSRSrc),
    .MemCtr(IDMemCtr),
    .RegSrc(IDRegSrc),
    .BranchCtr(IDBranchCtr),
    .Rd(IDRd),
    .Rs1(IDRs1),
    .Rs2(IDRs2),
    .ALUCtr(IDALUCtr),
    .CSRRd(IDCSRRd),
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

CSRFile CSRFile (
    .CLK(CLK),
    .RST(RST),
    .CSRWr(WBCSRWr),
    .CSRRd(WBCSRRd),
    .CSRRs(IDCSRRd),
    .CSRin(WBCSRin),
    .CSRout(IDCSRout)
);

ALU ALU (
    .ALUCtr(EXALUCtr),
    .BusA(EX_BusA),
    .BusB(EX_BusB),
    .ZF(EXZF),
    .CF(EXCF),
    .SF(EXSF),
    .OF(EXOF),
    .BusW(EXBusW)
);

BU BU (
    .ZF(MZF),
    .CF(MCF),
    .SF(MSF),
    .OF(MOF),
    .IDPredTaken(IDPredTaken),
    .MPredTaken(MPredTaken),
    .IDBranchCtr(IDBranchCtr),
    .MBranchCtr(MBranchCtr),
    .BusW(MBusW),
    .IDimm(IDimm),
    .IDPC(IDPC),
    .Mimm(Mimm),
    .MPC(MPC),
    .Jump(Jump),
    .PredJump(PredJump),
    .PCCtr(MPCCtr),
    ._imm(M_imm),
    ._PC(M_PC)
);

IFReg IFReg (
    .CLK(CLK),
    .RST(RST),
    .EN(~Wait),
    .CLR(Jump | PredJump),
    .InstrAccessFault(IFInstrAccessFault),
    .InstrPageFault(IFInstrPageFault),
    .PC(IFPC),
    .PCPlus4(IFPCPlus4),
    ._InstrAccessFault(IDInstrAccessFault),
    ._InstrPageFault(IDInstrPageFault),
    ._PC(IDPC),
    ._PCPlus4(IDPCPlus4)
);

IDReg IDReg (
    .CLK(CLK),
    .RST(RST),
    .EN(1'h1),
    .CLR(Wait | Jump),
    .Ebreak(IDEbreak),
    .Ecall(IDEcall),
    .InstrAccessFault(IDInstrAccessFault),
    .InstrPageFault(IDInstrPageFault),
    .InstrFault(IDInstrFault),
    .CSRWr(IDCSRWr),
    .DataREN(IDDataREN),
    .DataWEN(IDDataWEN),
    .PredTaken(IDPredTaken),
    .RegWr(IDRegWr),
    .ALUASrc(IDALUASrc),
    .ALUBSrc(IDALUBSrc),
    .CSRSrc(IDCSRSrc),
    .MemCtr(IDMemCtr),
    .RegSrc(IDRegSrc),
    .BranchCtr(IDBranchCtr),
    .Rd(IDRd),
    .ALUCtr(IDALUCtr),
    .CSRRd(IDCSRRd),
    .BusA(ID_BusA),
    .BusB(ID_BusB),
    .CSRout(IDCSRout),
    .imm(IDimm),
    .PC(IDPC),
    .PCPlus4(IDPCPlus4),
    ._Ebreak(EXEbreak),
    ._Ecall(EXEcall),
    ._InstrAccessFault(EXInstrAccessFault),
    ._InstrPageFault(EXInstrPageFault),
    ._InstrFault(EXInstrFault),
    ._CSRWr(EXCSRWr),
    ._DataREN(EXDataREN),
    ._DataWEN(EXDataWEN),
    ._PredTaken(EXPredTaken),
    ._RegWr(EXRegWr),
    ._ALUASrc(EXALUASrc),
    ._ALUBSrc(EXALUBSrc),
    ._CSRSrc(EXCSRSrc),
    ._MemCtr(EXMemCtr),
    ._RegSrc(EXRegSrc),
    ._BranchCtr(EXBranchCtr),
    ._Rd(EXRd),
    ._ALUCtr(EXALUCtr),
    ._CSRRd(EXCSRRd),
    ._BusA(EXBusA),
    ._BusB(EXBusB),
    ._CSRout(EXCSRout),
    ._imm(EXimm),
    ._PC(EXPC),
    ._PCPlus4(EXPCPlus4)
);

EXReg EXReg (
    .CLK(CLK),
    .RST(RST),
    .EN(1'h1),
    .CLR(Jump),
    .Ebreak(EXEbreak),
    .Ecall(EXEcall),
    .InstrAccessFault(EXInstrAccessFault),
    .InstrPageFault(EXInstrPageFault),
    .InstrFault(EXInstrFault),
    .ZF(EXZF),
    .CF(EXCF),
    .SF(EXSF),
    .OF(EXOF),
    .CSRWr(EXCSRWr),
    .DataREN(EXDataREN),
    .DataWEN(EXDataWEN),
    .PredTaken(EXPredTaken),
    .RegWr(EXRegWr),
    .CSRSrc(EXCSRSrc),
    .MemCtr(EXMemCtr),
    .RegSrc(EXRegSrc),
    .BranchCtr(EXBranchCtr),
    .Rd(EXRd),
    .CSRRd(EXCSRRd),
    .BusA(EXBusA),
    .BusB(EXBusB),
    .BusW(EXBusW),
    .CSRout(EXCSRout),
    .imm(EXimm),
    .PC(EXPC),
    .PCPlus4(EXPCPlus4),
    ._Ebreak(MEbreak),
    ._Ecall(MEcall),
    ._InstrAccessFault(MInstrAccessFault),
    ._InstrPageFault(MInstrPageFault),
    ._InstrFault(MInstrFault),
    ._ZF(MZF),
    ._CF(MCF),
    ._SF(MSF),
    ._OF(MOF),
    ._CSRWr(MCSRWr),
    ._DataREN(MDataREN),
    ._DataWEN(MDataWEN),
    ._PredTaken(MPredTaken),
    ._RegWr(MRegWr),
    ._CSRSrc(MCSRSrc),
    ._MemCtr(MMemCtr),
    ._RegSrc(MRegSrc),
    ._BranchCtr(MBranchCtr),
    ._Rd(MRd),
    ._CSRRd(MCSRRd),
    ._BusA(MBusA),
    ._BusB(MBusB),
    ._BusW(MBusW),
    ._CSRout(MCSRout),
    ._imm(Mimm),
    ._PC(MPC),
    ._PCPlus4(MPCPlus4)
);

RegByPass RegByPass (
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
    .EXCSRout(EXCSRout),
    .EXimm(EXimm),
    .EXPCPlus4(EXPCPlus4),
    .MCSRout(MCSRout),
    .MBusW(MBusW),
    .Mimm(Mimm),
    .MPCPlus4(MPCPlus4),
    .WB_BusW(WB_BusW),
    .Wait(Wait),
    .ID_BusA(ID_BusA),
    .ID_BusB(ID_BusB)
);

MReg MReg (
    .CLK(CLK),
    .RST(RST),
    .EN(1'h1),
    .CLR(1'h0),
    .CSRWr(MCSRWr),
    .RegWr(MRegWr),
    .CSRSrc(MCSRSrc),
    .RegSrc(MRegSrc),
    .Rd(MRd),
    .CSRRd(MCSRRd),
    .BusA(MBusA),
    .BusW(MBusW),
    .CSRout(MCSRout),
    .imm(Mimm),
    .PCPlus4(MPCPlus4),
    ._CSRWr(WBCSRWr),
    ._RegWr(WBRegWr),
    ._CSRSrc(WBCSRSrc),
    ._RegSrc(WBRegSrc),
    ._Rd(WBRd),
    ._CSRRd(WBCSRRd),
    ._BusA(WBBusA),
    ._BusW(WBBusW),
    ._CSRout(WBCSRout),
    ._imm(WBimm),
    ._PCPlus4(WBPCPlus4)
);

CSRByPass CSRByPass (
    .IDCSRWr(IDCSRWr),
    .EXCSRWr(EXCSRWr),
    .MCSRWr(MCSRWr),
    .WBCSRWr(WBCSRWr),
    .EXCSRSrc(EXCSRSrc),
    .MCSRSrc(MCSRSrc),
    .IDCSRRd(IDCSRRd),
    .EXCSRRd(EXCSRRd),
    .MCSRRd(MCSRRd),
    .WBCSRRd(WBCSRRd),
    .IDCSRout(IDCSRout),
    .EXBusA(EXBusA),
    .EXBusW(EXBusW),
    .EXimm(EXimm),
    .MBusA(MBusA),
    .MBusW(MBusW),
    .Mimm(Mimm),
    .WBCSRin(WBCSRin),
    .ID_CSRout(ID_CSRout)
);

endmodule

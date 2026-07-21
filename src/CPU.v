`include "defines.vh"

module CPU (
    input CLK,
    input RST
);

wire [31:0] IFPC;
wire [31:0] IFnextPC;

wire IDRegWr;
wire IDCSRWr;
wire IDPredTaken;
wire IDMMused;
wire IDInstrError;
wire IDBusAused;
wire IDBusBused;
wire [1:0] IDCSRSrc;
wire [1:0] IDALUASrc;
wire [1:0] IDALUBSrc;
wire [1:0] IDPCCtr;
wire [2:0] IDRegSrc;
wire [2:0] IDBranchCtr;
wire [3:0] IDMemCtr;
wire [4:0] IDRd;
wire [4:0] IDRs1;
wire [4:0] IDRs2;
wire [5:0] IDALUCtr;
wire [11:0] IDCSRRd;
wire [31:0] ID_BusA;
wire [31:0] ID_BusB;
wire [31:0] IDimm;
wire [31:0] IDPC;
wire [31:0] IDnextPC;
wire [31:0] IDInstr;
wire [31:0] IDBusA;
wire [31:0] IDBusB;
wire [31:0] IDCSRout;
wire [31:0] ID_CSRout;

wire EXZF;
wire EXCF;
wire EXSF;
wire EXOF;
wire EXRegWr;
wire EXCSRWr;
wire EXPredTaken;
wire EXMMused;
wire EXInstrError;
wire [1:0] EXCSRSrc;
wire [1:0] EXALUASrc;
wire [1:0] EXALUBSrc;
wire [1:0] EXPCCtr;
wire [2:0] EXRegSrc;
wire [2:0] EXBranchCtr;
wire [3:0] EXMemCtr;
wire [4:0] EXRd;
wire [5:0] EXALUCtr;
wire [11:0] EXCSRRd;
wire [31:0] EXimm;
wire [31:0] EXPC;
wire [31:0] EXnextPC;
wire [31:0] EXBusA;
wire [31:0] EXBusB;
wire [31:0] EXBusW;
wire [31:0] EXCSRout;
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

wire MZF;
wire MCF;
wire MSF;
wire MOF;
wire MRegWr;
wire MCSRWr;
wire MInstrError;
wire MPCAlignError;
wire MAddrErrorType;
wire MAddrAlignError;
wire MPCOverflowError;
wire MAddrOverflowError;
wire MPredTaken;
wire MMMused;
wire [1:0] MCSRSrc;
wire [1:0] MPCCtr;
wire [1:0] M_PCCtr;
wire [2:0] MRegSrc;
wire [2:0] MBranchCtr;
wire [3:0] MMemCtr;
wire [4:0] MRd;
wire [11:0] MCSRRd;
wire [31:0] Mimm;
wire [31:0] M_imm;
wire [31:0] MPC;
wire [31:0] MnextPC;
wire [31:0] MBusA;
wire [31:0] MBusB;
wire [31:0] MBusW;
wire [31:0] MCSRout;
wire [31:0] M_PC;

wire WBRegWr;
wire WBCSRWr;
wire WBInstrError;
wire WBPCAlignError;
wire WBAddrErrorType;
wire WBAddrAlignError;
wire WBPCOverflowError;
wire WBAddrOverflowError;
wire [1:0] WBCSRSrc;
wire [2:0] WBRegSrc;
wire [4:0] WBRd;
wire [11:0] WBCSRRd;
wire [31:0] WBBusA;
wire [31:0] WBimm;
wire [31:0] WBnextPC;
wire [31:0] WBBusW;
wire [31:0] WBCSRout;
wire [31:0] WBmem;
wire [31:0] WB_BusW;
wire [31:0] WBCSRin;

assign WB_BusW = WBRegSrc == 3'h0 ? WBBusW :
                 WBRegSrc == 3'h1 ? WBnextPC :
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
wire IFRegCLR;
assign IFRegCLR = Jump | PredJump;
wire IDRegCLR;
assign IDRegCLR = Jump | Wait;
wire MMPCCLR;
assign MMPCCLR = Jump | PredJump;

PC PC (
    .CLK(CLK),
    .RST(RST),
    .Wait(Wait),
    .PCCtr(M_PCCtr),
    .lastPC(M_PC),
    .imm(M_imm),
    .PCAlignError(MPCAlignError),
    .PC(IFPC),
    .nextPC(IFnextPC)
);

MM MM (
    .CLK(CLK),
    .RST(RST),
    .MMused(MMMused),
    .PCEN(~Wait),
    .PCCLR(MMPCCLR),
    .MemCtr(MMemCtr),
    .DataIn(MBusB),
    .PC(IFPC),
    .Addr(MBusW),
    .AddrErrorType(MAddrErrorType),
    .AddrAlignError(MAddrAlignError),
    .PCOverflowError(MPCOverflowError),
    .AddrOverflowError(MAddrOverflowError),
    .Instr(IDInstr),
    .DataOut(WBmem)
);

IFReg IFReg (
    .CLK(CLK),
    .RST(RST),
    .EN(~Wait),
    .CLR(IFRegCLR),
    .PC(IFPC),
    .nextPC(IFnextPC),
    ._PC(IDPC),
    ._nextPC(IDnextPC)
);

IDU IDU (
    .Instr(IDInstr),
    .InstrError(IDInstrError),
    .RegWr(IDRegWr),
    .CSRWr(IDCSRWr),
    .BusAused(IDBusAused),
    .BusBused(IDBusBused),
    .PredTaken(IDPredTaken),
    .MMused(IDMMused),
    .CSRSrc(IDCSRSrc),
    .ALUASrc(IDALUASrc),
    .ALUBSrc(IDALUBSrc),
    .PCCtr(IDPCCtr),
    .RegSrc(IDRegSrc),
    .BranchCtr(IDBranchCtr),
    .MemCtr(IDMemCtr),
    .Rs1(IDRs1),
    .Rs2(IDRs2),
    .Rd(IDRd),
    .ALUCtr(IDALUCtr),
    .CSRRd(IDCSRRd),
    .imm(IDimm)
);

IDReg IDReg (
    .CLK(CLK),
    .RST(RST),
    .EN(1'h1),
    .CLR(IDRegCLR),
    .RegWr(IDRegWr),
    .CSRWr(IDCSRWr),
    .PredTaken(IDPredTaken),
    .MMused(IDMMused),
    .InstrError(IDInstrError),
    .CSRSrc(IDCSRSrc),
    .ALUASrc(IDALUASrc),
    .ALUBSrc(IDALUBSrc),
    .PCCtr(IDPCCtr),
    .RegSrc(IDRegSrc),
    .BranchCtr(IDBranchCtr),
    .MemCtr(IDMemCtr),
    .Rd(IDRd),
    .ALUCtr(IDALUCtr),
    .CSRRd(IDCSRRd),
    .BusA(ID_BusA),
    .BusB(ID_BusB),
    .CSRout(ID_CSRout),
    .imm(IDimm),
    .PC(IDPC),
    .nextPC(IDnextPC),
    ._RegWr(EXRegWr),
    ._CSRWr(EXCSRWr),
    ._PredTaken(EXPredTaken),
    ._MMused(EXMMused),
    ._InstrError(EXInstrError),
    ._CSRSrc(EXCSRSrc),
    ._ALUASrc(EXALUASrc),
    ._ALUBSrc(EXALUBSrc),
    ._PCCtr(EXPCCtr),
    ._RegSrc(EXRegSrc),
    ._BranchCtr(EXBranchCtr),
    ._MemCtr(EXMemCtr),
    ._Rd(EXRd),
    ._ALUCtr(EXALUCtr),
    ._CSRRd(EXCSRRd),
    ._BusA(EXBusA),
    ._BusB(EXBusB),
    ._CSRout(EXCSRout),
    ._imm(EXimm),
    ._PC(EXPC),
    ._nextPC(EXnextPC)
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
    .CSRWr(EXCSRWr),
    .PredTaken(EXPredTaken),
    .MMused(EXMMused),
    .InstrError(EXInstrError),
    .CSRSrc(EXCSRSrc),
    .PCCtr(EXPCCtr),
    .RegSrc(EXRegSrc),
    .BranchCtr(EXBranchCtr),
    .MemCtr(EXMemCtr),
    .Rd(EXRd),
    .CSRRd(EXCSRRd),
    .imm(EXimm),
    .PC(EXPC),
    .nextPC(EXnextPC),
    .BusA(EXBusA),
    .BusB(EXBusB),
    .BusW(EXBusW),
    .CSRout(EXCSRout),
    ._ZF(MZF),
    ._CF(MCF),
    ._SF(MSF),
    ._OF(MOF),
    ._RegWr(MRegWr),
    ._CSRWr(MCSRWr),
    ._PredTaken(MPredTaken),
    ._MMused(MMMused),
    ._InstrError(MInstrError),
    ._CSRSrc(MCSRSrc),
    ._PCCtr(MPCCtr),
    ._RegSrc(MRegSrc),
    ._BranchCtr(MBranchCtr),
    ._MemCtr(MMemCtr),
    ._Rd(MRd),
    ._CSRRd(MCSRRd),
    ._imm(Mimm),
    ._PC(MPC),
    ._nextPC(MnextPC),
    ._BusA(MBusA),
    ._BusB(MBusB),
    ._BusW(MBusW),
    ._CSRout(MCSRout)
);

BU BU (
    .ZF(MZF),
    .CF(MCF),
    .SF(MSF),
    .OF(MOF),
    .MPredTaken(MPredTaken),
    .IDPredTaken(IDPredTaken),
    .MPCCtr(MPCCtr),
    .IDPCCtr(IDPCCtr),
    .BranchCtr(MBranchCtr),
    .Mimm(Mimm),
    .IDimm(IDimm),
    .BusW(MBusW),
    .MPC(MPC),
    .IDPC(IDPC),
    .Jump(Jump),
    .PredJump(PredJump),
    ._PCCtr(M_PCCtr),
    ._imm(M_imm),
    ._PC(M_PC)
);

MReg MReg (
    .CLK(CLK),
    .RST(RST),
    .EN(1'h1),
    .CLR(1'h0),
    .RegWr(MRegWr),
    .CSRWr(MCSRWr),
    .InstrError(MInstrError),
    .PCAlignError(MPCAlignError),
    .AddrErrorType(MAddrErrorType),
    .AddrAlignError(MAddrAlignError),
    .PCOverflowError(MPCOverflowError),
    .AddrOverflowError(MAddrOverflowError),
    .CSRSrc(MCSRSrc),
    .RegSrc(MRegSrc),
    .Rd(MRd),
    .CSRRd(MCSRRd),
    .BusA(MBusA),
    .imm(Mimm),
    .nextPC(MnextPC),
    .BusW(MBusW),
    .CSRout(MCSRout),
    ._RegWr(WBRegWr),
    ._CSRWr(WBCSRWr),
    ._InstrError(WBInstrError),
    ._PCAlignError(WBPCAlignError),
    ._AddrErrorType(WBAddrErrorType),
    ._AddrAlignError(WBAddrAlignError),
    ._PCOverflowError(WBPCOverflowError),
    ._AddrOverflowError(WBAddrOverflowError),
    ._CSRSrc(WBCSRSrc),
    ._RegSrc(WBRegSrc),
    ._Rd(WBRd),
    ._CSRRd(WBCSRRd),
    ._BusA(WBBusA),
    ._imm(WBimm),
    ._nextPC(WBnextPC),
    ._BusW(WBBusW),
    ._CSRout(WBCSRout)
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
    .EXimm(EXimm),
    .MnextPC(MnextPC),
    .Mimm(Mimm),
    .EXCSRout(EXCSRout),
    .MCSRout(MCSRout),
    .Wait(Wait),
    .ID_BusA(ID_BusA),
    .ID_BusB(ID_BusB)
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
    .EXBusW(EXBusW),
    .MBusW(MBusW),
    .WBCSRin(WBCSRin),
    .EXBusA(EXBusA),
    .MBusA(MBusA),
    .EXimm(EXimm),
    .Mimm(Mimm),
    .ID_CSRout(ID_CSRout)
);

endmodule

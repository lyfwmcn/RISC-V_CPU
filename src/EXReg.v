`timescale 1ns / 1ns

module EXReg (
    input CLK,
    input RST,
    input EN,
    input CLR,
    input Ebreak,
    input Ecall,
    input InstrAccessFault,
    input InstrPageFault,
    input InstrFault,
    input ZF,
    input CF,
    input SF,
    input OF,
    input CSRWr,
    input DataREN,
    input DataWEN,
    input PredTaken,
    input RegWr,
    input [1:0] CSRSrc,
    input [2:0] MemCtr,
    input [2:0] RegSrc,
    input [4:0] BranchCtr,
    input [4:0] Rd,
    input [11:0] CSRRd,
    input [31:0] BusA,
    input [31:0] BusB,
    input [31:0] BusW,
    input [31:0] CSRout,
    input [31:0] imm,
    input [31:0] PC,
    input [31:0] PCPlus4,
    output reg _Ebreak,
    output reg _Ecall,
    output reg _InstrAccessFault,
    output reg _InstrPageFault,
    output reg _InstrFault,
    output reg _ZF,
    output reg _CF,
    output reg _SF,
    output reg _OF,
    output reg _CSRWr,
    output reg _DataREN,
    output reg _DataWEN,
    output reg _PredTaken,
    output reg _RegWr,
    output reg [1:0] _CSRSrc,
    output reg [2:0] _MemCtr,
    output reg [2:0] _RegSrc,
    output reg [4:0] _BranchCtr,
    output reg [4:0] _Rd,
    output reg [11:0] _CSRRd,
    output reg [31:0] _BusA,
    output reg [31:0] _BusB,
    output reg [31:0] _BusW,
    output reg [31:0] _CSRout,
    output reg [31:0] _imm,
    output reg [31:0] _PC,
    output reg [31:0] _PCPlus4
);

always @(posedge CLK or posedge RST) begin
    if (RST == 1'h1) begin
        _Ebreak <= 1'h0;
        _Ecall <= 1'h0;
        _InstrAccessFault <= 1'h0;
        _InstrPageFault <= 1'h0;
        _InstrFault <= 1'h0;
        _ZF <= 1'h1;
        _CF <= 1'h0;
        _SF <= 1'h0;
        _OF <= 1'h0;
        _CSRWr <= 1'h0;
        _DataREN <= 1'h0;
        _DataWEN <= 1'h0;
        _PredTaken <= 1'h0;
        _RegWr <= 1'h1;
        _CSRSrc <= 2'h0;
        _MemCtr <= 3'h2;
        _RegSrc <= 3'h0;
        _BranchCtr <= 5'h0;
        _Rd <= 5'h0;
        _CSRRd <= 12'h0;
        _BusA <= 32'h0;
        _BusB <= 32'h0;
        _BusW <= 32'h0;
        _CSRout <= 32'h0;
        _imm <= 32'h0;
        _PC <= 32'h0;
        _PCPlus4 <= 32'h4;
    end
    else if (EN == 1'h1) begin
        _Ebreak <= CLR == 1'h1 ? 1'h0 : Ebreak;
        _Ecall <= CLR == 1'h1 ? 1'h0 : Ecall;
        _InstrAccessFault <= CLR == 1'h1 ? 1'h0 : InstrAccessFault;
        _InstrPageFault <= CLR == 1'h1 ? 1'h0 : InstrPageFault;
        _InstrFault <= CLR == 1'h1 ? 1'h0 : InstrFault;
        _ZF <= CLR == 1'h1 ? 1'h1 : ZF;
        _CF <= CLR == 1'h1 ? 1'h0 : CF;
        _SF <= CLR == 1'h1 ? 1'h0 : SF;
        _OF <= CLR == 1'h1 ? 1'h0 : OF;
        _CSRWr <= CLR == 1'h1 ? 1'h0 : CSRWr;
        _DataREN <= CLR == 1'h1 ? 1'h0 : DataREN;
        _DataWEN <= CLR == 1'h1 ? 1'h0 : DataWEN;
        _PredTaken <= CLR == 1'h1 ? 1'h0 : PredTaken;
        _RegWr <= CLR == 1'h1 ? 1'h1 : RegWr;
        _CSRSrc <= CLR == 1'h1 ? 2'h0 : CSRSrc;
        _MemCtr <= CLR == 1'h1 ? 3'h2 : MemCtr;
        _RegSrc <= CLR == 1'h1 ? 3'h0 : RegSrc;
        _BranchCtr <= CLR == 1'h1 ? 5'h0 : BranchCtr;
        _Rd <= CLR == 1'h1 ? 5'h0 : Rd;
        _CSRRd <= CLR == 1'h1 ? 12'h0 : CSRRd;
        _BusA <= CLR == 1'h1 ? 32'h0 : BusA;
        _BusB <= CLR == 1'h1 ? 32'h0 : BusB;
        _BusW <= CLR == 1'h1 ? 32'h0 : BusW;
        _CSRout <= CLR == 1'h1 ? 32'h0 : CSRout;
        _imm <= CLR == 1'h1 ? 32'h0 : imm;
        _PC <= CLR == 1'h1 ? 32'h0 : PC;
        _PCPlus4 <= CLR == 1'h1 ? 32'h4 : PCPlus4;
    end
end

endmodule

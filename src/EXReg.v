`include "defines.vh"

module EXReg (
    input CLK,
    input RST,
    input EN,
    input CLR,
    input ZF,
    input CF,
    input SF,
    input OF,
    input RegWr,
    input CSRWr,
    input PredTaken,
    input MMused,
    input InstrError,
    input [1:0] CSRSrc,
    input [1:0] PCCtr,
    input [2:0] RegSrc,
    input [2:0] BranchCtr,
    input [3:0] MemCtr,
    input [4:0] Rd,
    input [11:0] CSRRd,
    input [31:0] imm,
    input [31:0] PC,
    input [31:0] nextPC,
    input [31:0] BusA,
    input [31:0] BusB,
    input [31:0] BusW,
    input [31:0] CSRout,
    output reg _ZF,
    output reg _CF,
    output reg _SF,
    output reg _OF,
    output reg _RegWr,
    output reg _CSRWr,
    output reg _PredTaken,
    output reg _MMused,
    output reg _InstrError,
    output reg [1:0] _CSRSrc,
    output reg [1:0] _PCCtr,
    output reg [2:0] _RegSrc,
    output reg [2:0] _BranchCtr,
    output reg [3:0] _MemCtr,
    output reg [4:0] _Rd,
    output reg [11:0] _CSRRd,
    output reg [31:0] _imm,
    output reg [31:0] _PC,
    output reg [31:0] _nextPC,
    output reg [31:0] _BusA,
    output reg [31:0] _BusB,
    output reg [31:0] _BusW,
    output reg [31:0] _CSRout
);

always @(posedge CLK or posedge RST) begin
    if (RST == 1'h1) begin
        _ZF <= 1'h1;
        _CF <= 1'h0;
        _SF <= 1'h0;
        _OF <= 1'h0;
        _RegWr <= 1'h1;
        _CSRWr <= 1'h0;
        _PredTaken <= 1'h0;
        _MMused <= 1'h0;
        _InstrError <= 1'h0;
        _CSRSrc <= 2'h0;
        _PCCtr <= 2'h0;
        _RegSrc <= 3'h0;
        _BranchCtr <= 3'h2;
        _MemCtr <= 4'h0;
        _Rd <= 5'h0;
        _CSRRd <= 12'h0;
        _imm <= 32'h0;
        _PC <= 32'h0;
        _nextPC <= 32'h4;
        _BusA <= 32'h0;
        _BusB <= 32'h0;
        _BusW <= 32'h0;
        _CSRout <= 32'h0;
    end
    else if (EN == 1'h1) begin
        _ZF <= CLR == 1'h1 ? 1'h1 : ZF;
        _CF <= CLR == 1'h1 ? 1'h0 : CF;
        _SF <= CLR == 1'h1 ? 1'h0 : SF;
        _OF <= CLR == 1'h1 ? 1'h0 : OF;
        _RegWr <= CLR == 1'h1 ? 1'h1 : RegWr;
        _CSRWr <= CLR == 1'h1 ? 1'h0 : CSRWr;
        _PredTaken <= CLR == 1'h1 ? 1'h0 : PredTaken;
        _MMused <= CLR == 1'h1 ? 1'h0 : MMused;
        _InstrError <= CLR == 1'h1 ? 1'h0 : InstrError;
        _CSRSrc <= CLR == 1'h1 ? 2'h0 : CSRSrc;
        _PCCtr <= CLR == 1'h1 ? 2'h0 : PCCtr;
        _RegSrc <= CLR == 1'h1 ? 3'h0 : RegSrc;
        _BranchCtr <= CLR == 1'h1 ? 3'h2 : BranchCtr;
        _MemCtr <= CLR == 1'h1 ? 4'h0 : MemCtr;
        _Rd <= CLR == 1'h1 ? 5'h0 : Rd;
        _CSRRd <= CLR == 1'h1 ? 12'h0 : CSRRd;
        _imm <= CLR == 1'h1 ? 32'h0 : imm;
        _PC <= CLR == 1'h1 ? 32'h0 : PC;
        _nextPC <= CLR == 1'h1 ? 32'h4 : nextPC;
        _BusA <= CLR == 1'h1 ? 32'h0 : BusA;
        _BusB <= CLR == 1'h1 ? 32'h0 : BusB;
        _BusW <= CLR == 1'h1 ? 32'h0 : BusW;
        _CSRout <= CLR == 1'h1 ? 32'h0 : CSRout;
    end
end

endmodule

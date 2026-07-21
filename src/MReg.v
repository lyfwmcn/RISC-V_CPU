`include "defines.vh"

module MReg (
    input CLK,
    input RST,
    input EN,
    input CLR,
    input RegWr,
    input CSRWr,
    input InstrError,
    input PCAlignError,
    input AddrErrorType,
    input AddrAlignError,
    input PCOverflowError,
    input AddrOverflowError,
    input [1:0] CSRSrc,
    input [2:0] RegSrc,
    input [4:0] Rd,
    input [11:0] CSRRd,
    input [31:0] BusA,
    input [31:0] imm,
    input [31:0] nextPC,
    input [31:0] BusW,
    input [31:0] CSRout,
    output reg _RegWr,
    output reg _CSRWr,
    output reg _InstrError,
    output reg _PCAlignError,
    output reg _AddrErrorType,
    output reg _AddrAlignError,
    output reg _PCOverflowError,
    output reg _AddrOverflowError,
    output reg [1:0] _CSRSrc,
    output reg [2:0] _RegSrc,
    output reg [4:0] _Rd,
    output reg [11:0] _CSRRd,
    output reg [31:0] _BusA,
    output reg [31:0] _imm,
    output reg [31:0] _nextPC,
    output reg [31:0] _BusW,
    output reg [31:0] _CSRout
);

always @(posedge CLK or posedge RST) begin
    if (RST == 1'h1) begin
        _RegWr <= 1'h1;
        _CSRWr <= 1'h0;
        _InstrError <= 1'h0;
        _PCAlignError <= 1'h0;
        _AddrErrorType <= 1'h0;
        _AddrAlignError <= 1'h0;
        _PCOverflowError <= 1'h0;
        _AddrOverflowError <= 1'h0;
        _CSRSrc <= 2'h0;
        _RegSrc <= 3'h0;
        _Rd <= 5'h0;
        _CSRRd <= 12'h0;
        _BusA <= 32'h0;
        _imm <= 32'h0;
        _nextPC <= 32'h4;
        _BusW <= 32'h0;
        _CSRout <= 32'h0;
    end
    else if (EN == 1'h1) begin
        _RegWr <= CLR == 1'h1 ? 1'h1 : RegWr;
        _CSRWr <= CLR == 1'h1 ? 1'h0 : CSRWr;
        _InstrError <= CLR == 1'h1 ? 1'h0 : InstrError;
        _PCAlignError <= CLR == 1'h1 ? 1'h0 : PCAlignError;
        _AddrErrorType <= CLR == 1'h1 ? 1'h0 : AddrErrorType;
        _AddrAlignError <= CLR == 1'h1 ? 1'h0 : AddrAlignError;
        _PCOverflowError <= CLR == 1'h1 ? 1'h0 : PCOverflowError;
        _AddrOverflowError <= CLR == 1'h1 ? 1'h0 : AddrOverflowError;
        _CSRSrc <= CLR == 1'h1 ? 2'h0 : CSRSrc;
        _RegSrc <= CLR == 1'h1 ? 3'h0 : RegSrc;
        _Rd <= CLR == 1'h1 ? 5'h0 : Rd;
        _CSRRd <= CLR == 1'h1 ? 12'h0 : CSRRd;
        _BusA <= CLR == 1'h1 ? 32'h0 : BusA;
        _imm <= CLR == 1'h1 ? 32'h0 : imm;
        _nextPC <= CLR == 1'h1 ? 32'h4 : nextPC;
        _BusW <= CLR == 1'h1 ? 32'h0 : BusW;
        _CSRout <= CLR == 1'h1 ? 32'h0 : CSRout;
    end
end

endmodule

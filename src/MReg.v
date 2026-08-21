`timescale 1ns / 1ns

module MReg (
    input CLK,
    input RST,
    input EN,
    input CLR,
    input CSRWr,
    input RegWr,
    input [1:0] CSRSrc,
    input [2:0] RegSrc,
    input [4:0] Rd,
    input [11:0] CSRRd,
    input [31:0] BusA,
    input [31:0] BusW,
    input [31:0] CSRout,
    input [31:0] imm,
    input [31:0] PCPlus4,
    output reg _CSRWr,
    output reg _RegWr,
    output reg [1:0] _CSRSrc,
    output reg [2:0] _RegSrc,
    output reg [4:0] _Rd,
    output reg [11:0] _CSRRd,
    output reg [31:0] _BusA,
    output reg [31:0] _BusW,
    output reg [31:0] _CSRout,
    output reg [31:0] _imm,
    output reg [31:0] _PCPlus4
);

always @(posedge CLK or posedge RST) begin
    if (RST == 1'h1) begin
        _CSRWr <= 1'h0;
        _RegWr <= 1'h1;
        _CSRSrc <= 2'h0;
        _RegSrc <= 3'h0;
        _Rd <= 5'h0;
        _CSRRd <= 12'h0;
        _BusA <= 32'h0;
        _BusW <= 32'h0;
        _CSRout <= 32'h0;
        _imm <= 32'h0;
        _PCPlus4 <= 32'h4;
    end
    else if (EN == 1'h1) begin
        _CSRWr <= CLR == 1'h1 ? 1'h0 : CSRWr;
        _RegWr <= CLR == 1'h1 ? 1'h1 : RegWr;
        _CSRSrc <= CLR == 1'h1 ? 2'h0 : CSRSrc;
        _RegSrc <= CLR == 1'h1 ? 3'h0 : RegSrc;
        _Rd <= CLR == 1'h1 ? 5'h0 : Rd;
        _CSRRd <= CLR == 1'h1 ? 12'h0 : CSRRd;
        _BusA <= CLR == 1'h1 ? 32'h0 : BusA;
        _BusW <= CLR == 1'h1 ? 32'h0 : BusW;
        _CSRout <= CLR == 1'h1 ? 32'h0 : CSRout;
        _imm <= CLR == 1'h1 ? 32'h0 : imm;
        _PCPlus4 <= CLR == 1'h1 ? 32'h4 : PCPlus4;
    end
end

endmodule

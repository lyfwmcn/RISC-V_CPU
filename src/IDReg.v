`include "defines.vh"

module IDReg (
    input CLK,
    input RST,
    input EN,
    input CLR,
    input RegWr,
    input CSRWr,
    input PredTaken,
    input MMused,
    input InstrError,
    input [1:0] CSRSrc,
    input [1:0] ALUASrc,
    input [1:0] ALUBSrc,
    input [1:0] PCCtr,
    input [2:0] RegSrc,
    input [2:0] BranchCtr,
    input [3:0] MemCtr,
    input [4:0] Rd,
    input [5:0] ALUCtr,
    input [11:0] CSRRd,
    input [31:0] BusA,
    input [31:0] BusB,
    input [31:0] CSRout,
    input [31:0] imm,
    input [31:0] PC,
    input [31:0] nextPC,
    output reg _RegWr,
    output reg _CSRWr,
    output reg _PredTaken,
    output reg _MMused,
    output reg _InstrError,
    output reg [1:0] _CSRSrc,
    output reg [1:0] _ALUASrc,
    output reg [1:0] _ALUBSrc,
    output reg [1:0] _PCCtr,
    output reg [2:0] _RegSrc,
    output reg [2:0] _BranchCtr,
    output reg [3:0] _MemCtr,
    output reg [4:0] _Rd,
    output reg [5:0] _ALUCtr,
    output reg [11:0] _CSRRd,
    output reg [31:0] _BusA,
    output reg [31:0] _BusB,
    output reg [31:0] _CSRout,
    output reg [31:0] _imm,
    output reg [31:0] _PC,
    output reg [31:0] _nextPC
);

always @(posedge CLK or posedge RST) begin
    if (RST == 1'h1) begin
        _RegWr <= 1'h1;
        _CSRWr <= 1'h0;
        _PredTaken <= 1'h0;
        _MMused <= 1'h0;
        _InstrError <= 1'h0;
        _CSRSrc <= 2'h0;
        _ALUASrc <= 2'h0;
        _ALUBSrc <= 2'h1;
        _PCCtr <= 2'h0;
        _RegSrc <= 3'h0;
        _BranchCtr <= 3'h2;
        _MemCtr <= 4'h0;
        _Rd <= 5'h0;
        _ALUCtr <= 6'h0;
        _CSRRd <= 12'h0;
        _BusA <= 32'h0;
        _BusB <= 32'h0;
        _CSRout <= 32'h0;
        _imm <= 32'h0;
        _PC <= 32'h0;
        _nextPC <= 32'h4;
    end
    else if (EN == 1'h1) begin
        _RegWr <= CLR == 1'h1 ? 1'h1 : RegWr;
        _CSRWr <= CLR == 1'h1 ? 1'h0 : CSRWr;
        _PredTaken <= CLR == 1'h1 ? 1'h0 : PredTaken;
        _MMused <= CLR == 1'h1 ? 1'h0 : MMused;
        _InstrError <= CLR == 1'h1 ? 1'h0 : InstrError;
        _CSRSrc <= CLR == 1'h1 ? 2'h0 : CSRSrc;
        _ALUASrc <= CLR == 1'h1 ? 2'h0 : ALUASrc;
        _ALUBSrc <= CLR == 1'h1 ? 2'h1 : ALUBSrc;
        _PCCtr <= CLR == 1'h1 ? 2'h0 : PCCtr;
        _RegSrc <= CLR == 1'h1 ? 3'h0 : RegSrc;
        _BranchCtr <= CLR == 1'h1 ? 3'h2 : BranchCtr;
        _MemCtr <= CLR == 1'h1 ? 4'h0 : MemCtr;
        _Rd <= CLR == 1'h1 ? 5'h0 : Rd;
        _ALUCtr <= CLR == 1'h1 ? 6'h0 : ALUCtr;
        _CSRRd <= CLR == 1'h1 ? 12'h0 : CSRRd;
        _BusA <= CLR == 1'h1 ? 32'h0 : BusA;
        _BusB <= CLR == 1'h1 ? 32'h0 : BusB;
        _CSRout <= CLR == 1'h1 ? 32'h0 : CSRout;
        _imm <= CLR == 1'h1 ? 32'h0 : imm;
        _PC <= CLR == 1'h1 ? 32'h0 : PC;
        _nextPC <= CLR == 1'h1 ? 32'h4 : nextPC;
    end
end

endmodule

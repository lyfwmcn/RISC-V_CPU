`include "defines.vh"

module IDReg (
    input CLK,
    input RST,
    input EN,
    input CLR,
    input ALUASrc,
    input ALUBSrc,
    input RegWr,
    input [1:0] PCCtr,
    input [1:0] RegSrc,
    input [2:0] BranchCtr,
    input [3:0] ALUCtr,
    input [3:0] MemCtr,
    input [4:0] Rd,
    input [31:0] imm,
    input [31:0] PC,
    input [31:0] nextPC,
    input [31:0] BusA,
    input [31:0] BusB,
    output reg _ALUASrc,
    output reg _ALUBSrc,
    output reg _RegWr,
    output reg [1:0] _PCCtr,
    output reg [1:0] _RegSrc,
    output reg [2:0] _BranchCtr,
    output reg [3:0] _ALUCtr,
    output reg [3:0] _MemCtr,
    output reg [4:0] _Rd,
    output reg [31:0] _imm,
    output reg [31:0] _PC,
    output reg [31:0] _nextPC,
    output reg [31:0] _BusA,
    output reg [31:0] _BusB
);

always @(posedge CLK or posedge RST) begin
    if (RST == 1'h1) begin
        _ALUASrc <= 1'h0;
        _ALUBSrc <= 1'h1;
        _RegWr <= 1'h1;
        _PCCtr <= 2'h0;
        _RegSrc <= 2'h0;
        _BranchCtr <= 3'h2;
        _ALUCtr <= 4'h0;
        _MemCtr <= 4'h0;
        _Rd <= 5'h0;
        _imm <= 32'h0;
        _PC <= 32'h0;
        _nextPC <= 32'h4;
        _BusA <= 32'h0;
        _BusB <= 32'h0;
    end
    else if (EN == 1'h1) begin
        _ALUASrc <= CLR == 1'h1 ? 1'h0 : ALUASrc;
        _ALUBSrc <= CLR == 1'h1 ? 1'h1 : ALUBSrc;
        _RegWr <= CLR == 1'h1 ? 1'h1 : RegWr;
        _PCCtr <= CLR == 1'h1 ? 2'h0 : PCCtr;
        _RegSrc <= CLR == 1'h1 ? 2'h0 : RegSrc;
        _BranchCtr <= CLR == 1'h1 ? 3'h2 : BranchCtr;
        _ALUCtr <= CLR == 1'h1 ? 4'h0 : ALUCtr;
        _MemCtr <= CLR == 1'h1 ? 4'h0 : MemCtr;
        _Rd <= CLR == 1'h1 ? 5'h0 : Rd;
        _imm <= CLR == 1'h1 ? 32'h0 : imm;
        _PC <= CLR == 1'h1 ? 32'h0 : PC;
        _nextPC <= CLR == 1'h1 ? 32'h4 : nextPC;
        _BusA <= CLR == 1'h1 ? 32'h0 : BusA;
        _BusB <= CLR == 1'h1 ? 32'h0 : BusB;
    end
end

endmodule

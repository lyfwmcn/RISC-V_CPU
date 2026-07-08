`include "defines.vh"

module MReg (
    input CLK,
    input RST,
    input EN,
    input CLR,
    input RegWr,
    input [1:0] RegSrc,
    input [4:0] Rd,
    input [31:0] imm,
    input [31:0] nextPC,
    input [31:0] BusW,
    input [31:0] mem,
    output reg _RegWr,
    output reg [1:0] _RegSrc,
    output reg [4:0] _Rd,
    output reg [31:0] _imm,
    output reg [31:0] _nextPC,
    output reg [31:0] _BusW,
    output reg [31:0] _mem
);

always @(posedge CLK or posedge RST) begin
    if (RST == 1'h1) begin
        _RegWr <= 1'h1;
        _RegSrc <= 2'h0;
        _Rd <= 5'h0;
        _imm <= 32'h0;
        _nextPC <= 32'h4;
        _BusW <= 32'h0;
        _mem <= 32'h0;
    end
    else if (EN == 1'h1) begin
        _RegWr <= CLR == 1'h1 ? 1'h1 : RegWr;
        _RegSrc <= CLR == 1'h1 ? 2'h0 : RegSrc;
        _Rd <= CLR == 1'h1 ? 5'h0 : Rd;
        _imm <= CLR == 1'h1 ? 32'h0 : imm;
        _nextPC <= CLR == 1'h1 ? 32'h4 : nextPC;
        _BusW <= CLR == 1'h1 ? 32'h0 : BusW;
        _mem <= CLR == 1'h1 ? 32'h0 : mem;
    end
end

endmodule

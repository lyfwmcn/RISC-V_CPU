`timescale 1ns / 1ns

module IFReg (
    input CLK,
    input RST,
    input EN,
    input CLR,
    input InstrAccessFault,
    input InstrPageFault,
    input [31:0] PC,
    input [31:0] PCPlus4,
    output reg _InstrAccessFault,
    output reg _InstrPageFault,
    output reg [31:0] _PC,
    output reg [31:0] _PCPlus4
);

always @(posedge CLK or posedge RST) begin
    if (RST == 1'h1) begin
        _InstrAccessFault <= 1'h0;
        _InstrPageFault <= 1'h0;
        _PC <= 32'h0;
        _PCPlus4 <= 32'h4;
    end
    else if (EN == 1'h1) begin
        _InstrAccessFault <= CLR == 1'h1 ? 1'h0 : InstrAccessFault;
        _InstrPageFault <= CLR == 1'h1 ? 1'h0 : InstrPageFault;
        _PC <= CLR == 1'h1 ? 32'h0 : PC;
        _PCPlus4 <= CLR == 1'h1 ? 32'h4 : PCPlus4;
    end
end

endmodule

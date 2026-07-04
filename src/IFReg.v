module IFReg (
    input CLK,
    input RST,
    input EN,
    input CLR,
    input [31:0] PC,
    input [31:0] nextPC,
    output reg [31:0] _PC,
    output reg [31:0] _nextPC
);

always @(posedge CLK or posedge RST) begin
    if (RST == 1'h1) begin
        _PC <= 32'h0;
        _nextPC <= 32'h4;
    end
    else if (EN == 1'h1) begin
        _PC <= CLR == 1'h1 ? 32'h0 : PC;
        _nextPC <= CLR == 1'h1 ? 32'h4 : nextPC;
    end
end

endmodule

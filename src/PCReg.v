`timescale 1ns / 1ns

module PCReg (
    input CLK,
    input RST,
    input Wait,
    input [1:0] PCCtr,
    input [31:0] imm,
    input [31:0] lastPC,
    output InstrAlignFault,
    output [31:0] PC,
    output [31:0] PCPlus4
);

// Wait = 1 且 PCCtr = 0 时 _PCCtr = 1
wire [1:0] _PCCtr;
assign _PCCtr = Wait == 1'h1 && PCCtr == 2'h0 ? 2'h1 : PCCtr;

reg [31:0] addr;

assign PC = addr;
wire [31:0] nextAddr [3:0];
assign nextAddr[0] = addr + 32'h4;
assign nextAddr[1] = addr;
assign nextAddr[2] = lastPC + imm;
assign nextAddr[3] = imm;
assign PCPlus4 = nextAddr[0];

assign InstrAlignFault = nextAddr[_PCCtr][1:0] != 2'h0;

always @(posedge CLK or posedge RST) begin
    if (RST == 1'h1) begin
        addr <= 32'h0;
    end
    else begin
        addr <= InstrAlignFault == 1'h0 ? nextAddr[_PCCtr] : nextAddr[0];
    end
end

endmodule

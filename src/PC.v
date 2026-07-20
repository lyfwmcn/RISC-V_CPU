`include "defines.vh"

/*
 * Wait: 等待控制信号
 * PCCtr: 控制信号
 * lastPC: M 阶段指令的 PC
 * imm: M 阶段指令的 imm
 * PCAlignError: PC 地址不对齐
 * PC: IF 阶段指令的 PC
 * nextPC: IF 阶段指令的 PC + 4
 * 异常处理：
 * PC 不对齐：不可避免异常。发生时 PC + 4
 */
module PC (
    input CLK,
    input RST,
    input Wait,
    input [1:0] PCCtr,
    input [31:0] lastPC,
    input [31:0] imm,
    output PCAlignError,
    output [31:0] PC,
    output [31:0] nextPC
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
assign nextPC = nextAddr[0];

assign PCAlignError = nextAddr[_PCCtr][1:0] != 2'h0;

always @(posedge CLK or posedge RST) begin
    if (RST == 1'h1) begin
        addr <= 32'h0;
    end
    else begin
        addr <= PCAlignError == 1'h1 ? nextAddr[0] : nextAddr[_PCCtr];
    end
end

endmodule

`include "defines.vh"

/*
 * ALUCtr: 控制信号
 * BusA: 操作数 A
 * BusB: 操作数 B
 * ZF ~ OF: 加 / 减法标志信号
 * BusW: 结果
 * 异常处理：
 * ALUCtr 异常：可避免异常。发生时输出 ZF = 1, CF = 0, SF = 0, OF = 0, BusW = 0
 */
module ALU (
    input [3:0] ALUCtr,
    input [31:0] BusA,
    input [31:0] BusB,
    output ZF,
    output CF,
    output SF,
    output OF,
    output [31:0] BusW
);

// 当 ALUCtr 不在范围内，在 9 ~ c, e ~ f 时为 1
wire ALUCtrError;
assign ALUCtrError = (ALUCtr >= 4'h9 && ALUCtr <= 4'hc) || (ALUCtr >= 4'he && ALUCtr <= 4'hf);

// result[ALUCtr[2:0]] 得到不同模式结果
wire [31:0] result [7:0];

wire [31:0] _BusB;
assign _BusB = ALUCtr[3] == 1'h0 ? BusB : ~BusB + 32'h1;
wire cout;

assign {cout, result[0]} = BusA + _BusB;
assign result[1] = BusA << BusB[4:0];
assign result[2] = $signed(BusA) < $signed(BusB) ? 32'h1 : 32'h0;
assign result[3] = BusA < BusB ? 32'h1 : 32'h0;
assign result[4] = BusA ^ BusB;
assign result[5] = ALUCtr[3] == 1'h0 ? BusA >> BusB[4:0] : $unsigned($signed(BusA) >>> BusB[4:0]);
assign result[6] = BusA | BusB;
assign result[7] = BusA & BusB;

assign ZF = ALUCtrError == 1'h0 ? result[0] == 32'h0 : 1'h1;
assign CF = ALUCtrError == 1'h0 ? ALUCtr[3] ^ cout : 1'h0;
assign SF = ALUCtrError == 1'h0 ? result[0][31] : 1'h0;
assign OF = ALUCtrError == 1'h0 ? (BusA[31] & _BusB[31] & ~result[0][31]) | (~BusA[31] & ~_BusB[31] & result[0][31]) : 1'h0;
assign BusW = ALUCtrError == 1'h0 ? result[ALUCtr[2:0]] : 32'h0;

endmodule

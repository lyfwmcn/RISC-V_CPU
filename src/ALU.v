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
    input [5:0] ALUCtr,
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
assign ALUCtrError = (ALUCtr[3:0] >= 4'h9 && ALUCtr[3:0] <= 4'hc) || (ALUCtr[3:0] >= 4'he && ALUCtr[3:0] <= 4'hf);

wire [31:0] _BusA;
wire [31:0] _BusB;
assign _BusA = ALUCtr[4] == 1'h0 ? BusA : ~BusA;
assign _BusB = ALUCtr[5] == 1'h0 ? BusB : ~BusB;

// result[ALUCtr[2:0]] 得到不同模式结果
wire [31:0] result [7:0];

wire [31:0] __BusB;
assign __BusB = ALUCtr[3] == 1'h0 ? _BusB : ~_BusB + 32'h1;
wire cout;

assign {cout, result[0]} = _BusA + __BusB;
assign result[1] = _BusA << _BusB[4:0];
assign result[2] = $signed(_BusA) < $signed(_BusB) ? 32'h1 : 32'h0;
assign result[3] = _BusA < _BusB ? 32'h1 : 32'h0;
assign result[4] = _BusA ^ _BusB;
assign result[5] = ALUCtr[3] == 1'h0 ? _BusA >> _BusB[4:0] : $unsigned($signed(_BusA) >>> _BusB[4:0]);
assign result[6] = _BusA | _BusB;
assign result[7] = _BusA & _BusB;

assign ZF = ALUCtrError == 1'h0 ? result[0] == 32'h0 : 1'h1;
assign CF = ALUCtrError == 1'h0 ? ALUCtr[3] ^ cout : 1'h0;
assign SF = ALUCtrError == 1'h0 ? result[0][31] : 1'h0;
assign OF = ALUCtrError == 1'h0 ? (_BusA[31] & __BusB[31] & ~result[0][31]) | (~_BusA[31] & ~__BusB[31] & result[0][31]) : 1'h0;
assign BusW = ALUCtrError == 1'h0 ? result[ALUCtr[2:0]] : 32'h0;

endmodule

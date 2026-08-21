`timescale 1ns / 1ns

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

wire ALUCtrError;
assign ALUCtrError = (ALUCtr[3:0] >= 4'h9 && ALUCtr[3:0] <= 4'hc) || (ALUCtr[3:0] >= 4'he);

wire [31:0] _BusA;
assign _BusA = ALUCtr[4] == 1'h0 ? BusA : ~BusA;
wire [31:0] _BusB;
assign _BusB = ALUCtr[5] == 1'h0 ? BusB : ~BusB;

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

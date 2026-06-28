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

wire [31:0] result [0:15];

assign result[0] = BusA + BusB;
assign {CF, result[8]} = BusA + ~BusB + 32'd1;
assign result[1] = BusA << BusB[4:0];
assign result[2] = $signed(BusA) < $signed(BusB);
assign result[3] = BusA < BusB;
assign result[4] = BusA ^ BusB;
assign result[5] = BusA >> BusB[4:0];
assign result[13] = BusA >>> BusB[4:0];
assign result[6] = BusA | BusB;
assign result[7] = BusA & BusB;

assign result[9] = 32'd0;
assign result[10] = 32'd0;
assign result[11] = 32'd0;
assign result[12] = 32'd0;
assign result[14] = 32'd0;
assign result[15] = 32'd0;

assign ZF = result[8] == 32'd0;
assign SF = result[8][31];
assign OF = BusA[31] & ~BusB[31] & ~SF | ~BusA[31] & BusB[31] & SF;
assign BusW = result[ALUCtr];

endmodule

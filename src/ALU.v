module ALU (
    input [31:0] busA,
    input [31:0] busB,
    input [3:0] ALUCtr,
    output [31:0] busW,
    output ZF,
    output CF,
    output SF,
    output OF
);

wire [31:0] result [0:15];

assign result[0] = busA + busB;
assign {CF, result[8]} = busA + ~busB + 32'd1;
assign result[1] = busA << busB[4:0];
assign result[2] = $signed(busA) < $signed(busB);
assign result[3] = busA < busB;
assign result[4] = busA ^ busB;
assign result[5] = busA >> busB[4:0];
assign result[13] = busA >>> busB[4:0];
assign result[6] = busA | busB;
assign result[7] = busA & busB;

assign result[9] = 32'd0;
assign result[10] = 32'd0;
assign result[11] = 32'd0;
assign result[12] = 32'd0;
assign result[14] = 32'd0;
assign result[15] = 32'd0;

assign ZF = result[8] == 32'd0;
assign SF = result[8][31];
assign OF = busA[31] & ~busB[31] & ~SF | ~busA[31] & busB[31] & SF;
assign busW = result[ALUCtr];

endmodule

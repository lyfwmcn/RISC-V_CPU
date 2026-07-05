module ALU (
    input [3:0] ALUCtr,
    input [31:0] BusA,
    input [31:0] BusB,
    output ALUCtrError,
    output ZF,
    output CF,
    output SF,
    output OF,
    output [31:0] BusW
);

assign ALUCtrError = ((ALUCtr >= 4'h9) && (ALUCtr <= 4'hc)) || ((ALUCtr >= 4'he) && (ALUCtr <= 4'hf));

wire [31:0] result [0:7];

wire [31:0] _BusB;
assign _BusB = ALUCtr[3] == 1'h0 ? BusB : (~BusB + 32'h1);
wire cout;

assign {cout, result[0]} = BusA + _BusB;
assign result[1] = BusA << BusB[4:0];
assign result[2] = $signed(BusA) < $signed(BusB) ? 32'h1 : 32'h0;
assign result[3] = BusA < BusB ? 32'h1 : 32'h0;
assign result[4] = BusA ^ BusB;
assign result[5] = (ALUCtr[3] == 1'h0 ? BusA >> BusB[4:0] : $unsigned($signed(BusA) >>> BusB[4:0]));
assign result[6] = BusA | BusB;
assign result[7] = BusA & BusB;

assign ZF = result[0] == 32'h0;
assign CF = ALUCtr[3] ^ cout;
assign SF = result[0][31];
assign OF = (BusA[31] & _BusB[31] & ~SF) | (~BusA[31] & ~_BusB[31] & SF);
assign BusW = ALUCtrError == 1'h0 ? result[ALUCtr[2:0]] : 32'h0;

endmodule

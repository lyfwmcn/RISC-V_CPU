`include "defines.vh"

module ByPass (
    input EXBusAused,
    input EXBusBused,
    input MRegWr,
    input WBRegWr,
    input [1:0] MRegSrc,
    input [4:0] EXRs1,
    input [4:0] EXRs2,
    input [4:0] MRd,
    input [4:0] WBRd,
    input [31:0] EXBusA,
    input [31:0] EXBusB,
    input [31:0] MBusW,
    input [31:0] WB_BusW,
    input [31:0] MnextPC,
    input [31:0] Mimm,
    output Wait,
    output [31:0] EX_BusA,
    output [31:0] EX_BusB
);

wire [2:0] CondA;
assign CondA = EXBusAused == 1'h0 || EXRs1 == 5'h0 ? 3'h7 :
               MRd == EXRs1 && MRegWr == 1'h1 ? (MRegSrc == 2'h2 ? 3'h6 : 3'h5) :
               WBRd == EXRs1 && WBRegWr == 1'h1 ? 3'h4 : 3'h3;

wire [2:0] CondB;
assign CondB = EXBusBused == 1'h0 || EXRs2 == 5'h0 ? 3'h7 :
               MRd == EXRs2 && MRegWr == 1'h1 ? (MRegSrc == 2'h2 ? 3'h6 : 3'h5) :
               WBRd == EXRs2 && WBRegWr == 1'h1 ? 3'h4 : 3'h3;

wire [31:0] EX_BusAs [7:0];

assign EX_BusAs[0] = EXBusA;
assign EX_BusAs[1] = EXBusA;
assign EX_BusAs[2] = EXBusA;
assign EX_BusAs[3] = EXBusA;
assign EX_BusAs[4] = WB_BusW;
assign EX_BusAs[5] = MRegSrc == 2'h0 ? MBusW :
                     MRegSrc == 2'h1 ? MnextPC :
                     MRegSrc == 2'h2 ? 32'h0 : Mimm;
assign EX_BusAs[6] = 32'h0;
assign EX_BusAs[7] = 32'h0;

assign EX_BusA = EX_BusAs[CondA];

wire [31:0] EX_BusBs [7:0];

assign EX_BusBs[0] = EXBusB;
assign EX_BusBs[1] = EXBusB;
assign EX_BusBs[2] = EXBusB;
assign EX_BusBs[3] = EXBusB;
assign EX_BusBs[4] = EX_BusAs[4];
assign EX_BusBs[5] = EX_BusAs[5];
assign EX_BusBs[6] = 32'h0;
assign EX_BusBs[7] = 32'h0;

assign EX_BusB = EX_BusBs[CondB];

assign Wait = CondA == 3'h6 || CondB == 3'h6;

endmodule

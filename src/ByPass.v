`include "defines.vh"

module ByPass (
    input IDBusAused,
    input IDBusBused,
    input EXRegWr,
    input MRegWr,
    input WBRegWr,
    input [2:0] EXRegSrc,
    input [2:0] MRegSrc,
    input [4:0] IDRs1,
    input [4:0] IDRs2,
    input [4:0] EXRd,
    input [4:0] MRd,
    input [4:0] WBRd,
    input [31:0] IDBusA,
    input [31:0] IDBusB,
    input [31:0] EXBusW,
    input [31:0] MBusW,
    input [31:0] WB_BusW,
    input [31:0] EXnextPC,
    input [31:0] EXimm,
    input [31:0] MnextPC,
    input [31:0] Mimm,
    input [31:0] EXCSRout,
    input [31:0] MCSRout,
    output Wait,
    output [31:0] ID_BusA,
    output [31:0] ID_BusB
);

wire [2:0] CondA;
assign CondA = IDBusAused == 1'h0 || IDRs1 == 5'h0 ? 3'h7 :
               EXRd == IDRs1 && EXRegWr == 1'h1 ? (EXRegSrc == 3'h2 ? 3'h6 : 3'h5) :
               MRd == IDRs1 && MRegWr == 1'h1 ? (MRegSrc == 3'h2 ? 3'h4 : 3'h3) :
               WBRd == IDRs1 && WBRegWr == 1'h1 ? 3'h2 : 3'h1;

wire [2:0] CondB;
assign CondB = IDBusBused == 1'h0 || IDRs2 == 5'h0 ? 3'h7 :
               EXRd == IDRs2 && EXRegWr == 1'h1 ? (EXRegSrc == 3'h2 ? 3'h6 : 3'h5) :
               MRd == IDRs2 && MRegWr == 1'h1 ? (MRegSrc == 3'h2 ? 3'h4 : 3'h3) :
               WBRd == IDRs2 && WBRegWr == 1'h1 ? 3'h2 : 3'h1;

wire [31:0] ID_BusAs [7:0];

assign ID_BusAs[0] = IDBusA;
assign ID_BusAs[1] = IDBusA;
assign ID_BusAs[2] = WB_BusW;
assign ID_BusAs[3] = MRegSrc == 3'h0 ? MBusW :
                     MRegSrc == 3'h1 ? MnextPC :
                     MRegSrc == 3'h2 ? 32'h0 :
                     MRegSrc == 3'h3 ? Mimm :
                     MRegSrc == 3'h4 ? MCSRout :
                     32'h0;
assign ID_BusAs[4] = 32'h0;
assign ID_BusAs[5] = EXRegSrc == 3'h0 ? EXBusW :
                     EXRegSrc == 3'h1 ? EXnextPC :
                     EXRegSrc == 3'h2 ? 32'h0 :
                     EXRegSrc == 3'h3 ? EXimm :
                     EXRegSrc == 3'h4 ? EXCSRout :
                     32'h0;
assign ID_BusAs[6] = 32'h0;
assign ID_BusAs[7] = 32'h0;

assign ID_BusA = ID_BusAs[CondA];

wire [31:0] ID_BusBs [7:0];

assign ID_BusBs[0] = IDBusB;
assign ID_BusBs[1] = IDBusB;
assign ID_BusBs[2] = ID_BusAs[2];
assign ID_BusBs[3] = ID_BusAs[3];
assign ID_BusBs[4] = 32'h0;
assign ID_BusBs[5] = ID_BusAs[5];
assign ID_BusBs[6] = 32'h0;
assign ID_BusBs[7] = 32'h0;

assign ID_BusB = ID_BusBs[CondB];

assign Wait = CondA == 3'h4 || CondA == 3'h6 || CondB == 3'h4 || CondB == 3'h6;

endmodule

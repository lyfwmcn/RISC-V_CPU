`include "defines.vh"

module CSRByPass (
    input IDCSRWr,
    input EXCSRWr,
    input MCSRWr,
    input WBCSRWr,
    input [1:0] EXCSRSrc,
    input [1:0] MCSRSrc,
    input [11:0] IDCSRRd,
    input [11:0] EXCSRRd,
    input [11:0] MCSRRd,
    input [11:0] WBCSRRd,
    input [31:0] IDCSRout,
    input [31:0] EXBusW,
    input [31:0] MBusW,
    input [31:0] WBCSRin,
    input [31:0] EXBusA,
    input [31:0] MBusA,
    input [31:0] EXimm,
    input [31:0] Mimm,
    output [31:0] ID_CSRout
);

assign ID_CSRout = IDCSRWr == 1'h0 ? 32'h0 :
                   EXCSRWr == 1'h1 && EXCSRRd == IDCSRRd ? (EXCSRSrc == 2'h0 ? EXBusW :
                                                            EXCSRSrc == 2'h1 ? EXBusA :
                                                            EXCSRSrc == 2'h2 ? EXimm :
                                                            32'h0) :
                   MCSRWr == 1'h1 && MCSRRd == IDCSRRd ? (MCSRSrc == 2'h0 ? MBusW :
                                                          MCSRSrc == 2'h1 ? MBusA :
                                                          MCSRSrc == 2'h2 ? Mimm :
                                                          32'h0) :
                   WBCSRWr == 1'h1 && WBCSRRd == IDCSRRd ? WBCSRin :
                   IDCSRout;

endmodule

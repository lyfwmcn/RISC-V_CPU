`timescale 1ns / 1ns

module CSRFile (
    input CLK,
    input RST,
    input CSRWr,
    input WBIsInstr,
    input [11:0] CSRRd,
    input [11:0] CSRRs,
    input [31:0] CSRin,
    output [31:0] CSRout
);

reg [31:0] sstatus;
reg [31:0] sie;
reg [31:0] stvec;
reg [31:0] sscratch;
reg [31:0] sepc;
reg [31:0] scause;
reg [31:0] stval;
reg [31:0] sip;
reg [31:0] satp;
reg [31:0] mstatus;
reg [31:0] misa;
reg [31:0] medeleg;
reg [31:0] mideleg;
reg [31:0] mie;
reg [31:0] mtvec;
reg [31:0] mscratch;
reg [31:0] mepc;
reg [31:0] mcause;
reg [31:0] mtval;
reg [31:0] mip;
reg [31:0] mcycle;
reg [31:0] minstret;
reg [31:0] mcycleh;
reg [31:0] minstreth;
reg [31:0] mhartid;

assign CSRout = CSRRs == 12'h100 ? sstatus :
                CSRRs == 12'h104 ? sie :
                CSRRs == 12'h105 ? stvec :
                CSRRs == 12'h140 ? sscratch :
                CSRRs == 12'h141 ? sepc :
                CSRRs == 12'h142 ? scause :
                CSRRs == 12'h143 ? stval :
                CSRRs == 12'h144 ? sip :
                CSRRs == 12'h180 ? satp :
                CSRRs == 12'h300 ? mstatus :
                CSRRs == 12'h301 ? misa :
                CSRRs == 12'h302 ? medeleg :
                CSRRs == 12'h303 ? mideleg :
                CSRRs == 12'h304 ? mie :
                CSRRs == 12'h305 ? mtvec :
                CSRRs == 12'h340 ? mscratch :
                CSRRs == 12'h341 ? mepc :
                CSRRs == 12'h342 ? mcause :
                CSRRs == 12'h343 ? mtval :
                CSRRs == 12'h344 ? mip :
                CSRRs == 12'hB00 ? mcycle :
                CSRRs == 12'hB02 ? minstret :
                CSRRs == 12'hB80 ? mcycleh :
                CSRRs == 12'hB82 ? minstreth :
                CSRRs == 12'hF14 ? mhartid :
                32'h0;

initial begin
    misa <= 32'h40000100;
    mhartid <= 32'h0;
end

always @(posedge CLK or posedge RST) begin
    // ---------------------------
    if (RST == 1'h1) begin
        sstatus <= 32'h0;
        sie <= 32'h0;
        stvec <= 32'h0;
        sscratch <= 32'h0;
        sepc <= 32'h0;
        scause <= 32'h0;
        stval <= 32'h0;
        sip <= 32'h0;
        satp <= 32'h0;
        mstatus <= 32'h0;
        medeleg <= 32'h0;
        mideleg <= 32'h0;
        mie <= 32'h0;
        mtvec <= 32'h0;
        mscratch <= 32'h0;
        mepc <= 32'h0;
        mcause <= 32'h0;
        mtval <= 32'h0;
        mip <= 32'h0;
        mcycle <= 32'h0;
        minstret <= 32'h0;
        mcycleh <= 32'h0;
        minstreth <= 32'h0;
    end
    // 这里需要更改
    // ---------------------------
    else begin
        {mcycleh, mcycle} <= {mcycleh, mcycle} + 64'h1;
        if (WBIsInstr == 1'h1) begin
            {minstreth, minstret} <= {minstreth, minstret} + 64'h1;
        end
        if (CSRWr == 1'h1) begin
            case (CSRRd)
                12'h100: sstatus <= CSRin;
                12'h104: sie <= CSRin;
                12'h105: stvec <= CSRin;
                12'h140: sscratch <= CSRin;
                12'h141: sepc <= CSRin;
                12'h142: scause <= CSRin;
                12'h143: stval <= CSRin;
                12'h144: sip <= CSRin;
                12'h180: satp <= CSRin;
                12'h300: mstatus <= CSRin;
                12'h302: medeleg <= CSRin;
                12'h303: mideleg <= CSRin;
                12'h304: mie <= CSRin;
                12'h305: mtvec <= CSRin;
                12'h340: mscratch <= CSRin;
                12'h341: mepc <= CSRin;
                12'h342: mcause <= CSRin;
                12'h343: mtval <= CSRin;
                12'h344: mip <= CSRin;
                default: ;
            endcase
        end
    end
end

endmodule

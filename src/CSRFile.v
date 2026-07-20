`include "defines.vh"

module CSRFile (
    input CLK,
    input RST,
    input CSRWr,
    input [11:0] CSRRd,
    input [11:0] CSRRs,
    input [31:0] CSRin,
    output [31:0] CSRout
);

reg [31:0] regs [0:4095];

assign CSRout = regs[CSRRs];

integer i;

always @(posedge CLK or posedge RST) begin
    if (RST == 1'h1) begin
        for (i = 0; i < 4096; i = i + 1) begin
            regs[i] <= 32'h0;
        end
    end
    else if (CSRWr == 1'h1) begin
        regs[CSRRd] <= CSRin;
    end
end

endmodule

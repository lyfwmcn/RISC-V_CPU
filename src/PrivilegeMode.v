`timescale 1ns/1ns

module PrivilegeMode (
    input CLK,
    input RST,
    input ModeChange,
    input [1:0] NextMode,
    output reg [1:0] Mode
);

always @(posedge CLK or posedge RST) begin
    if (RST == 1'h1) begin
        Mode <= 2'h3;
    end
    else if (ModeChange == 1'h1) begin
        Mode <= NextMode == 2'h2 ? 2'h3 : NextMode;
    end
end

endmodule

module PC (
    input CLK,
    input RST,
    input [1:0] PCCtr,
    input [31:0] lastPC,
    input [31:0] imm,
    output lastPCError,
    output immError,
    output [31:0] PC,
    output [31:0] nextPC
);

assign lastPCError = lastPC[1:0] != 2'h0;
assign immError = imm[1:0] != 2'h0;

reg [31:0] addr;

assign PC = addr;
wire [31:0] nextAddr [3:0];
assign nextAddr[0] = addr + 32'h4;
assign nextAddr[1] = addr;
assign nextAddr[2] = lastPC + imm;
assign nextAddr[3] = imm;
assign nextPC = nextAddr[0];

always @(posedge CLK or posedge RST) begin
    if (RST == 1'h1) begin
        addr <= 32'h0;
    end
    else begin
        addr <= (lastPCError == 1'h1 && PCCtr == 2'h2) || (immError == 1'h1 && (PCCtr == 2'h2 || PCCtr == 2'h3)) ? addr + 32'h4 : nextAddr[PCCtr];
    end
end

endmodule

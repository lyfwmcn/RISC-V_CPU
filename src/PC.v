module PC (
    input CLK,
    input RST,
    input [1:0] PCCtr,
    input [31:0] lastPC,
    input [31:0] imm,
    output [31:0] PC,
    output [31:0] nextPC
);

reg [31:0] addr;

assign PC = addr;
wire [31:0] nextAddr [3:0];
assign nextAddr[0] = addr + 32'd4;
assign nextAddr[1] = addr;
assign nextAddr[2] = lastPC + imm;
assign nextAddr[3] = imm;
assign nextPC = nextAddr[0];

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        addr <= 32'd0;
    end
    else begin
        addr <= nextAddr[PCCtr];
    end
end

endmodule

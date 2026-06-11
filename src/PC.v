module PC (
    input [31:0] imm,
    input [1:0] PCCtr,
    input Clk,
    input Rst,
    output [31:0] PC,
    output [31:0] nextPC
);

reg [31:0] addr;

assign PC = addr;
wire [31:0] _addr [3:0];
assign _addr[0] = addr;
assign _addr[1] = addr + 32'd4;
assign _addr[2] = addr + imm;
assign _addr[3] = imm;
assign nextPC = _addr[1];

always @(posedge Clk or posedge Rst) begin
    if (Rst) begin
        addr <= 32'd0;
    end
    else begin
        addr <= _addr[PCCtr];
    end
end

endmodule

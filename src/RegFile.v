module RegFile (
    input [31:0] busW,
    input [4:0] Rd,
    input [4:0] Rs1,
    input [4:0] Rs2,
    input RegWr,
    output [31:0] busA,
    output [31:0] busB,
    input Clk,
    input Rst
);

reg [31:0] regs [1:31];

assign busA = (Rs1 == 5'd0) ? 32'd0 : regs[Rs1];
assign busB = (Rs2 == 5'd0) ? 32'd0 : regs[Rs2];

integer i;

always @(posedge Clk or posedge Rst) begin
    if (Rst) begin
        for (i = 1; i < 32; i = i + 1) begin
            regs[i] <= 32'd0;
        end
    end
    else if (RegWr && Rd > 0) begin
        regs[Rd] <= busW;
    end
end

endmodule

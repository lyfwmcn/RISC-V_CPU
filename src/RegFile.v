module RegFile (
    input CLK,
    input RST,
    input RegWr,
    input [4:0] Rd,
    input [4:0] Rs1,
    input [4:0] Rs2,
    input [31:0] BusW,
    output [31:0] BusA,
    output [31:0] BusB
);

reg [31:0] regs [1:31];

assign BusA = (Rs1 == 5'd0) ? 32'd0 : regs[Rs1];
assign BusB = (Rs2 == 5'd0) ? 32'd0 : regs[Rs2];

integer i;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        for (i = 1; i < 32; i = i + 1) begin
            regs[i] <= 32'd0;
        end
    end
    else if (RegWr && Rd > 0) begin
        regs[Rd] <= BusW;
    end
end

endmodule

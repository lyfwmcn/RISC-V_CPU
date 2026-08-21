`timescale 1ns/1ns

module tb;

reg CLK;
reg RST;

CPU CPU(
    .CLK(CLK),
    .RST(RST)
);

initial begin
    RST = 1;
    #5
    RST = 0;
    #5
    CLK = 0;
    forever #5 CLK = ~CLK;
end

initial begin
    $finish;
end

initial begin
    $dumpfile("./bin/wave.vcd");
    $dumpvars(0, tb);
end

endmodule

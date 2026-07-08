`include "defines.vh"

module tb;

reg CLK;

initial begin
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

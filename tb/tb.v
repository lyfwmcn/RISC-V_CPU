`timescale 1ns / 1ns

module tb;

// 测试台信号定义：输入用 reg，输出用 wire
reg [31:0]   Datain;
reg [4:0]    Addr0;
reg [4:0]    Addr1;
reg [4:0]    Addr2;
reg          Clk;
reg          We;
reg          Rst;
wire [31:0]  Dataout0;
wire [31:0]  Dataout1;
wire [31:0]  Dataout2;

// 例化寄存器堆
RegFile regfile (
    .Datain(Datain),
    .Addr0(Addr0),
    .Addr1(Addr1),
    .Addr2(Addr2),
    .Clk(Clk),
    .We(We),
    .Rst(Rst),
    .Dataout0(Dataout0),
    .Dataout1(Dataout1),
    .Dataout2(Dataout2)
);

// 生成时钟：50MHz 周期 20ns
initial begin
    Clk = 0;
    forever #10 Clk = ~Clk;
end

// 测试激励（完整流程）
initial begin
    // 初始化所有信号
    Datain = 0;
    Addr0 = 0;
    Addr1 = 0;
    Addr2 = 0;
    We = 0;
    Rst = 1;
    
    #5;
    Rst = 0;
    We = 1;
    Addr0 = 6;
    Datain = 12345678;
    
    #10;
    We = 0;
    $finish;
end

// 生成波形
initial begin
    $dumpfile("./bin/wave.vcd");
    $dumpvars(0, tb);
end

endmodule

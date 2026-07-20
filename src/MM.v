`include "defines.vh"

/*
 * 异常处理：
 * PC 地址不对齐：可避免错误。发生时指令固定读出 addi x0, 0, 0
 * PC 越界：不可避免错误。发生时指令固定读出 addi x0, 0, 0
 * Addr 地址不对齐：不可避免错误。发生时无法写入内存，内存固定读出 0
 * Addr 越界：不可避免错误。发生时无法写入内存，内存固定读出 0
 * MemCtr 不在范围内：可避免错误。发生时无法写入内存，内存固定读出 0
 */
module MM (
    input CLK,
    input RST,
    input MMused,
    input PCEN,
    input PCCLR,
    input [3:0] MemCtr,
    input [31:0] DataIn,
    input [31:0] PC,
    input [31:0] Addr,
    output AddrErrorType,
    output AddrAlignError,
    output PCOverflowError,
    output AddrOverflowError,
    output reg [31:0] Instr,
    output reg [31:0] DataOut
);

reg [7:0] mem [1023:0]; // 地址共1024B

// 读取数据并写入
initial begin
    $readmemh("mem/test.hex", mem, 0, 1023);
end

assign AddrErrorType = MemCtr[3];
wire PCAlignError;
assign PCAlignError = PC[1:0] != 2'h0;
assign AddrAlignError = MMused == 1'h1 && (((MemCtr == 4'h1 || MemCtr == 4'h5 || MemCtr == 4'h9) && Addr[0] != 1'h0) || ((MemCtr == 4'h2 || MemCtr == 4'ha) && Addr[1:0] != 2'h0));
assign PCOverflowError = MMused == 1'h1 && PC[31:10] != 22'h0;
assign AddrOverflowError = MMused == 1'h1 && Addr[31:10] != 22'h0;
wire MemCtrError;
assign MemCtrError = MemCtr[2:0] == 3'h3 || MemCtr[2:0] == 3'h6 || MemCtr[2:0] == 3'h7 || (MemCtr[3] == 1'h1 && (MemCtr[2:0] == 3'h4 || MemCtr[2:0] == 3'h5));

wire [31:0] ValidAddr;

assign ValidAddr = {22'h0, Addr[9:0]};

wire [31:0] Addr8_0;
wire [31:0] Addr16_0;
wire [31:0] Addr16_1;
wire [31:0] Addr32_0;
wire [31:0] Addr32_1;
wire [31:0] Addr32_2;
wire [31:0] Addr32_3;

assign Addr8_0 = ValidAddr;
assign Addr16_0 = {ValidAddr[31:1], 1'h0};
assign Addr16_1 = {ValidAddr[31:1], 1'h1};
assign Addr32_0 = {ValidAddr[31:2], 2'h0};
assign Addr32_1 = {ValidAddr[31:2], 2'h1};
assign Addr32_2 = {ValidAddr[31:2], 2'h2};
assign Addr32_3 = {ValidAddr[31:2], 2'h3};

wire [31:0] DataOuts [7:0];

assign DataOuts[0] = {{24{mem[Addr8_0][7]}}, mem[Addr8_0]};
assign DataOuts[1] = {{16{mem[Addr16_1][7]}}, mem[Addr16_1], mem[Addr16_0]};
assign DataOuts[2] = {mem[Addr32_3], mem[Addr32_2], mem[Addr32_1], mem[Addr32_0]};
assign DataOuts[4] = {24'h0, mem[Addr8_0]};
assign DataOuts[5] = {16'h0, mem[Addr16_1], mem[Addr16_0]};

assign DataOuts[3] = 32'h0;
assign DataOuts[6] = 32'h0;
assign DataOuts[7] = 32'h0;

wire [31:0] ValidPC;

assign ValidPC = {22'h0, PC[9:2], 2'h0};

always @(posedge CLK or posedge RST) begin
    if (RST == 1'h1) begin
        DataOut <= 32'h0;
        Instr <= 32'h13;
    end
    else begin
        DataOut <= AddrAlignError == 1'h1 || AddrOverflowError == 1'h1 || MemCtrError == 1'h1 || MemCtr[3] == 1'h1 ? 32'h0 : DataOuts[MemCtr[2:0]];
        if (PCEN == 1'h1) begin
            Instr <= PCAlignError == 1'h1 || PCOverflowError == 1'h1 || PCCLR == 1'h1 ? 32'h13 : {mem[ValidPC + 32'h3], mem[ValidPC + 32'h2], mem[ValidPC + 32'h1], mem[ValidPC]};
        end
    end
    if (AddrAlignError == 1'h0 && AddrOverflowError == 1'h0 && MemCtrError == 1'h0 && MemCtr[3] == 1'h1) begin
        case (MemCtr[2:0])
            0 : mem[Addr8_0] <= DataIn[7:0];
            1 : begin
                mem[Addr16_0] <= DataIn[7:0];
                mem[Addr16_1] <= DataIn[15:8];
            end
            2 : begin
                mem[Addr32_0] <= DataIn[7:0];
                mem[Addr32_1] <= DataIn[15:8];
                mem[Addr32_2] <= DataIn[23:16];
                mem[Addr32_3] <= DataIn[31:24];
            end
            default: ;
        endcase
    end
end

endmodule

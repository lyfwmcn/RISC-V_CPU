`timescale 1ns / 1ns

module MemoryUnit (
    input CLK,
    input RST,
    input DataREN,
    input DataWEN,
    input InstrCLR,
    input InstrEN,
    input [2:0] MemCtr,
    input [31:0] DataAddr,
    input [31:0] DataIn,
    input [31:0] InstrAddr,
    output InstrAccessFault,
    output InstrPageFault,
    output LoadAccessFault,
    output LoadAlignFault,
    output LoadPageFault,
    output StoreAccessFault,
    output StoreAlignFault,
    output StorePageFault,
    output reg [31:0] DataOut,
    output reg [31:0] Instr
);

// 1024B SRAM
reg [7:0] sram [1023:0];

// 读取数据并写入
initial begin
    $readmemh("mem/test.hex", sram, 0, 1023);
end

wire InstrAlignError;
assign InstrAlignError = InstrAddr[1:0] != 2'h0;
wire MemCtrError;
assign MemCtrError = MemCtr == 3'h3 || MemCtr == 3'h6 || MemCtr == 3'h7 || (DataWEN == 1'h1 && (MemCtr == 3'h4 || MemCtr == 3'h5));

assign InstrAccessFault = InstrAddr[31:10] != 22'h0;
assign InstrPageFault = 1'h0;
assign LoadAlignFault = DataREN == 1'h1 && (((MemCtr == 3'h1 || MemCtr == 3'h5) && DataAddr[0] != 1'h0) || (MemCtr == 3'h2 && DataAddr[1:0] != 2'h0));
assign LoadAccessFault = DataREN == 1'h1 && DataAddr[31:10] != 22'h0;
assign LoadPageFault = 1'h0;
assign StoreAlignFault = DataWEN == 1'h1 && ((MemCtr == 3'h1 && DataAddr[0] != 1'h0) || (MemCtr == 3'h2 && DataAddr[1:0] != 2'h0));
assign StoreAccessFault = DataWEN == 1'h1 && DataAddr[31:10] != 22'h0;
assign StorePageFault = 1'h0;

wire [31:0] ValidDataAddr;
assign ValidDataAddr = {22'h0, DataAddr[9:0]};

wire [31:0] Addr8_0;
wire [31:0] Addr16_0;
wire [31:0] Addr16_1;
wire [31:0] Addr32_0;
wire [31:0] Addr32_1;
wire [31:0] Addr32_2;
wire [31:0] Addr32_3;

assign Addr8_0 = ValidDataAddr;
assign Addr16_0 = {ValidDataAddr[31:1], 1'h0};
assign Addr16_1 = {ValidDataAddr[31:1], 1'h1};
assign Addr32_0 = {ValidDataAddr[31:2], 2'h0};
assign Addr32_1 = {ValidDataAddr[31:2], 2'h1};
assign Addr32_2 = {ValidDataAddr[31:2], 2'h2};
assign Addr32_3 = {ValidDataAddr[31:2], 2'h3};

wire [31:0] DataOuts [7:0];

assign DataOuts[0] = {{24{sram[Addr8_0][7]}}, sram[Addr8_0]};
assign DataOuts[1] = {{16{sram[Addr16_1][7]}}, sram[Addr16_1], sram[Addr16_0]};
assign DataOuts[2] = {sram[Addr32_3], sram[Addr32_2], sram[Addr32_1], sram[Addr32_0]};
assign DataOuts[4] = {24'h0, sram[Addr8_0]};
assign DataOuts[5] = {16'h0, sram[Addr16_1], sram[Addr16_0]};

assign DataOuts[3] = 32'h0;
assign DataOuts[6] = 32'h0;
assign DataOuts[7] = 32'h0;

wire [31:0] ValidInstrAddr;
assign ValidInstrAddr = {22'h0, InstrAddr[9:2], 2'h0};

always @(posedge CLK or posedge RST) begin
    if (RST == 1'h1) begin
        Instr <= 32'h13;
        DataOut <= 32'h0;
    end
    else begin
        if (InstrEN == 1'h1) begin
            Instr <= InstrAlignError == 1'h0 && InstrAccessFault == 1'h0 && InstrCLR == 1'h0 ? {sram[ValidInstrAddr + 32'h3], sram[ValidInstrAddr + 32'h2], sram[ValidInstrAddr + 32'h1], sram[ValidInstrAddr]} : 32'h13;
        end
        DataOut <= MemCtrError == 1'h0 && DataREN == 1'h1 && LoadAlignFault == 1'h0 && LoadAccessFault == 1'h0 && LoadPageFault == 1'h0 ? DataOuts[MemCtr] : 32'h0;
    end
    if (MemCtrError == 1'h0 && DataWEN == 1'h1 && StoreAlignFault == 1'h0 && StoreAccessFault == 1'h0 && StorePageFault == 1'h0) begin
        case (MemCtr)
            3'h0 : begin
                sram[Addr8_0] <= DataIn[7:0];
            end
            3'h1 : begin
                sram[Addr16_0] <= DataIn[7:0];
                sram[Addr16_1] <= DataIn[15:8];
            end
            3'h2 : begin
                sram[Addr32_0] <= DataIn[7:0];
                sram[Addr32_1] <= DataIn[15:8];
                sram[Addr32_2] <= DataIn[23:16];
                sram[Addr32_3] <= DataIn[31:24];
            end
            default: ;
        endcase
    end
end

endmodule

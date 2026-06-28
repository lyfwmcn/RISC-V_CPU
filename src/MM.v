module MM (
    input CLK,
    input PCEN,
    input PCCLR,
    input [3:0] MemCtr,
    input [31:0] DataIn,
    input [31:0] PC,
    input [31:0] Addr,
    output AlignError,
    output OverflowError,
    output MemCtrError,
    output reg [31:0] Instr,
    output reg [31:0] DataOut
);

reg [7:0] mem [1023:0]; // 地址共1024B

assign AlignError = ((MemCtr[1:0] == 2'd1) && Addr[0] != 1'd0) || ((MemCtr[1:0] == 2'd2) && Addr[1:0] != 2'd0) || (PC[1:0] != 2'd0);
assign OverflowError = (Addr[31:10] != 22'd0) || (PC[31:10] != 22'd0);
assign MemCtrError = (MemCtr[2:0] == 3'd3) || (MemCtr[2:0] == 3'd6) || (MemCtr[2:0] == 3'd7) || ((MemCtr[3] == 1'd1) && ((MemCtr[2:0] == 3'd4) || (MemCtr[2:0] == 3'd5)));

wire [31:0] ValidAddr;

assign ValidAddr = {22'd0, Addr[9:0]};

wire [31:0] Addr8_0;
wire [31:0] Addr16_0;
wire [31:0] Addr16_1;
wire [31:0] Addr32_0;
wire [31:0] Addr32_1;
wire [31:0] Addr32_2;
wire [31:0] Addr32_3;

assign Addr8_0 = ValidAddr;
assign Addr16_0 = {ValidAddr[31:1], 1'd0};
assign Addr16_1 = {ValidAddr[31:1], 1'd1};
assign Addr32_0 = {ValidAddr[31:2], 2'd0};
assign Addr32_1 = {ValidAddr[31:2], 2'd1};
assign Addr32_2 = {ValidAddr[31:2], 2'd2};
assign Addr32_3 = {ValidAddr[31:2], 2'd3};

wire [31:0] _DataOut [7:0];

assign _DataOut[0] = {{24{mem[Addr8_0][7]}}, mem[Addr8_0]};
assign _DataOut[1] = {{16{mem[Addr16_1][7]}}, mem[Addr16_1], mem[Addr16_0]};
assign _DataOut[2] = {mem[Addr32_3], mem[Addr32_2], mem[Addr32_1], mem[Addr32_0]};
assign _DataOut[4] = {24'd0, mem[Addr8_0]};
assign _DataOut[5] = {16'd0, mem[Addr16_1], mem[Addr16_0]};

assign _DataOut[3] = 32'd0;
assign _DataOut[6] = 32'd0;
assign _DataOut[7] = 32'd0;

wire [31:0] ValidPC;

assign ValidPC = {22'd0, PC[9:2], 2'd0};

always @(posedge CLK) begin
    DataOut <= _DataOut[MemCtr[2:0]];
    if (PCEN == 1'd1) begin
        Instr <= (PCCLR == 1'd0 ? {mem[ValidPC + 32'd3], mem[ValidPC + 32'd2], mem[ValidPC + 32'd1], mem[ValidPC]} : 32'd0);
    end
    if (MemCtr[3]) begin
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

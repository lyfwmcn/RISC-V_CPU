module MM (
    input [31:0] DataIn,
    input [31:0] PC,
    input [31:0] Addr,
    input [3:0] MemCtr,
    input Clk,
    input Rst,
    output [31:0] Instr,
    output [31:0] DataOut
);

reg [7:0] mem [255:0];

assign _PC = {24'd0, PC[7:2] + 2'd0};

assign Instr = {mem[_PC + 32'd3], mem[_PC + 32'd2], mem[_PC + 32'd1], mem[_PC]};

wire [31:0] Addr8_0;
wire [31:0] Addr16_0;
wire [31:0] Addr16_1;
wire [31:0] Addr32_0;
wire [31:0] Addr32_1;
wire [31:0] Addr32_2;
wire [31:0] Addr32_3;

assign _Addr = {24'd0, Addr[7:0]};

assign Addr8_0 = _Addr;
assign Addr16_0 = {_Addr[31:1], 1'd0};
assign Addr16_1 = {_Addr[31:1], 1'd1};
assign Addr32_0 = {_Addr[31:2], 2'd0};
assign Addr32_1 = {_Addr[31:2], 2'd1};
assign Addr32_2 = {_Addr[31:2], 2'd2};
assign Addr32_3 = {_Addr[31:2], 2'd3};

wire [31:0] _DataOut [7:0];

assign _DataOut[0] = {24{mem[Addr8_0][7]}, mem[Addr8_0]};
assign _DataOut[1] = {16{mem[Addr16_1][7]}, mem[Addr16_1], mem[Addr16_0]};
assign _DataOut[2] = {mem[Addr32_3], mem[Addr32_2], mem[Addr32_1], mem[Addr32_0]};
assign _DataOut[4] = {24'd0, mem[Addr8_0]};
assign _DataOut[5] = {16'd0, mem[Addr16_1], mem[Addr16_0]};

assign _DataOut[3] = 32'd0;
assign _DataOut[6] = 32'd0;
assign _DataOut[7] = 32'd0;

assign DataOut = _DataOut[MemCtr[2:0]];

integer i;

always @(posedge Clk or posedge Rst) begin
    if (Rst) begin
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] = 8'd0;
        end
    end
    else if (MemCtr[3]) begin
        case (MemCtr[2:0])
            0 : mem[Addr8_0] = DataIn[7:0];
            1 : begin
                mem[Addr16_0] = DataIn[7:0];
                mem[Addr16_1] = DataIn[15:8];
            end
            2 : begin
                mem[Addr32_0] = DataIn[7:0];
                mem[Addr32_1] = DataIn[15:8];
                mem[Addr32_2] = DataIn[23:16];
                mem[Addr32_3] = DataIn[31:24];
            end
            default: ;
        endcase
    end
end

endmodule

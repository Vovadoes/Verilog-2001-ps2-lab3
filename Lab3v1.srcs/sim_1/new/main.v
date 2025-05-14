`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.05.2025 18:25:31
// Design Name: 
// Module Name: main
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module main(
    input clk_in,
    output clk_out,
    input PS2_clk,
    input PS2_dat,
    output [7:0] AN,
    output [6:0] SEG
    );

wire R_O;
wire [7:0] out;
wire [1:0] flags;

PS2_Manager m_m(
    .clk(clk_in),
    .PS2_dat(PS2_dat),
    .PS2_clk(PS2_clk),
    .R_O(R_O),
    .out(out),
    .flags(flags)
);

delitel #(
    .mod(16384)
) clk_div1 (
    .clk(clk),
    .out(clk_div_out)
);

SevenSegmentLED seg(
    .clk(clk_div_out),
    .RESET(1'b0),
    .NUMBER(shift_register),
    .AN_MASK(an_mask),
    .AN(AN),
    .SEG(SEG)
);

initial an_mask <= 8'b01111100;

always@(posedge R_O)
begin
    shift_register <= {2'b0, flags, 20'b0, out};
end

assign clk_out = PS2_clk;

endmodule

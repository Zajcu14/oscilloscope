`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.07.2023 18:56:45
// Design Name: Pawe³ Mozgowiec
// Module Name: draw_display
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



module top_oscilloscope_basys3 (
    input  wire clk,
    input  wire btnC,
    output wire Vsync,
    output wire Hsync,
    output wire [3:0] vgaRed,
    output wire [3:0] vgaGreen,
    output wire [3:0] vgaBlue,
    inout wire [1:0] JB,
    inout wire PS2Clk,
    inout wire PS2Data,
    output wire JA1
);
wire pclk, mclk;
wire pclk_mirror;

clk_wiz_0 u_clk_wiz_0(
    .clk_105Mhz(mclk),
    .clk_63Mhz(pclk),
    .locked(),
    .clk(clk)
);

ODDR pclk_oddr (
    .Q(pclk_mirror),
    .C(pclk),
    .CE(1'b1),
    .D1(1'b1),
    .D2(1'b0),
    .R(1'b0),
    .S(1'b0)
);

assign JA1 = pclk_mirror;
/**
 *  Project functional top module
 */
 

top_oscilloscope u_top_oscilloscope (
    .clk(pclk),
    .clk_mouse(mclk),
    .rst(btnC),
    .r(vgaRed),
    .g(vgaGreen),
    .b(vgaBlue),
    .hs(Hsync),
    .vs(Vsync),
    .ps2_data(PS2Data),
    .ps2_clk(PS2Clk),
    .i2c(JB)
);

endmodule
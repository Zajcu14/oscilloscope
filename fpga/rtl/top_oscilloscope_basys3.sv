/**
 * San Jose State University
 * EE178 Lab #4
 * Author: prof. Eric Crabilla
 *
 * Modified by:
 * 2023  AGH University of Science and Technology
 * MTM UEC2
 * Piotr Kaczmarczyk
 *
 * Description:
 * Top level synthesizable module including the project top and all the FPGA-referred modules.
 */

`timescale 1 ns / 1 ps

module top_oscilloscope_basys3 (
    input  wire clk,
    input  wire btnC,
    output wire Vsync,
    output wire Hsync,
    output wire [3:0] vgaRed,
    output wire [3:0] vgaGreen,
    output wire [3:0] vgaBlue,
    inout wire [7:0] JB,
    inout wire PS2Clk,
    inout wire PS2Data
);


/**
 * Local variables and signals
 */

wire clk100MHz;
wire locked;
wire pclk;
wire pclk_mirror;


// For details on synthesis attributes used above, see AMD Xilinx UG 901:
// https://docs.xilinx.com/r/en-US/ug901-vivado-synthesis/Synthesis-Attributes


/**
 * Signals assignments
 */


/**
 * FPGA submodules placement
 */
 
clk_wiz_0 u_clk_wiz_0(
  .clk100MHz_ce(),
  .clk100MHz(clk100MHz),
  .clk40MHz_ce(),
  .clk40MHz(),
  // Status and control signals
  .locked,
 // Clock in ports
  .clk
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


/**
 *  Project functional top module
 */

top_oscilloscope u_top_oscilloscope (
    .clk(pclk),
    .clk_mouse(clk100MHz),
    .clk_trigger(clk100MHz),
    .rst(btnC),
    .r(vgaRed),
    .g(vgaGreen),
    .b(vgaBlue),
    .hs(Hsync),
    .vs(Vsync),
    .ps2_data(PS2Data),
    .ps2_clk(PS2Clk),
    .adc(JB)
);

endmodule
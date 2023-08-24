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
    inout wire [1:0] JB,
    inout wire PS2Clk,
    inout wire PS2Data,
    output wire JA1
);
wire pclk, mclk;
wire pclk_mirror;
/*
logic clk_100MHz;
logic clk_10MHz;
logic clk_65MHz;
logic clk_100KHz;

/**
 * Clock divide
 */ 
 /*
clk_divider u_clk_divider_1(
    .clk(clk),
    .pclk(clk_1MHz)
);

clk_divider #( .DIVIDE(15.500)) u_clk_divider_2(
    .clk(clk),
    .pclk(clk_65MHz)
);

 logic [10:0] clk_divider;
 
 always_ff @(posedge clk_10MHz) begin
        if(clk_100KHz === 'bx) begin
            clk_100KHz <= 0;
        end
        else if(clk_divider == 49) begin
            clk_100KHz <= ~clk_100KHz;
            clk_divider <= 0;
        end
        else begin
            clk_100KHz <= clk_100KHz;
            clk_divider <= clk_divider + 1;
        end
 end
 
 /**
 *  Assignments
 */
 /*
 assign clk_100MHz = clk;
 
*/
clk_wiz_0 u_clk_wiz_0(
    .clk_100Mhz(mclk),
    .clk_65Mhz(pclk),
    .locked(),
    .clk_in_100Mhz(clk),
    .reset()
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
    .clk_trigger(pclk),
    .clk_adc(pclk),
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
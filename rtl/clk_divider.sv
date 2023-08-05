`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.07.2023 18:15:12
// Design Name: 
// Module Name: clk_divider
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


module clk_divider #(parameter DIVIDE = 100.000) (
    input logic clk,
    output logic pclk
    );
    
wire clk_in, clk_fb, clk_ss, clk_out;
(* KEEP = "TRUE" *)
(* ASYNC_REG = "TRUE" *)
logic [7:0] safe_start = 0;

wire locked;
wire pclk;
wire pclk_mirror;
 
 
IBUF clk_ibuf (
    .I(clk),
    .O(clk_in)
);

MMCME2_BASE #(
    .CLKIN1_PERIOD(10.000),
    .CLKFBOUT_MULT_F(10.000),
    .CLKOUT0_DIVIDE_F(DIVIDE)
) clk_in_mmcme2 (
    .CLKIN1(clk_in),
    .CLKOUT0(clk_out),
    .CLKOUT0B(),
    .CLKOUT1(),
    .CLKOUT1B(),
    .CLKOUT2(),
    .CLKOUT2B(),
    .CLKOUT3(),
    .CLKOUT3B(),
    .CLKOUT4(),
    .CLKOUT5(),
    .CLKOUT6(),
    .CLKFBOUT(clk_fb),
    .CLKFBOUTB(),
    .CLKFBIN(clk_fb),
    .LOCKED(locked),
    .PWRDWN(1'b0),
    .RST(1'b0)
);

BUFH clk_out_bufh (
    .I(clk_out),
    .O(clk_ss)
);

always_ff @(posedge clk_ss)
    safe_start <= {safe_start[6:0],locked};

BUFGCE #(
    .SIM_DEVICE("7SERIES")
) clk_out_bufgce (
    .I(clk_out),
    .CE(safe_start[7]),
    .O(pclk)
);

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.07.2023 18:56:45
// Design Name: 
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


module draw_display(
    input logic clk,
    input logic clk_data,
    input logic reset,
    input logic data,
    input logic [7:0] graph_scale,

    vga_if.in in,
    vga_if.out out
    );
    
    
    
endmodule

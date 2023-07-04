`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2023 22:48:46
// Design Name: 
// Module Name: draw_mouse
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


module draw_mouse(
    input  logic clk,
    input  logic [11:0] xpos,
    input  logic [11:0] ypos,
    
    vga_if.in in,
    vga_if.out out

    );
    
    logic [11:0] rgb;
    
    MouseDisplay u_mouse_display(
        .pixel_clk(clk),
        .xpos(xpos),
        .ypos(ypos),
        .hcount(in.hcount),
        .vcount(in.vcount),
        .blank(in.hblnk | in.vblnk),
        .enable_mouse_display_out(),
        .rgb_in(in.rgb),
        .rgb_out(rgb)
    );
    
    always_ff @(posedge clk) begin
        out.vcount <= in.vcount;
        out.vsync  <= in.vsync;
        out.vblnk  <= in.vblnk;
        out.hcount <= in.hcount;
        out.hsync  <= in.hsync;
        out.hblnk  <= in.hblnk;
    end
    
    always_comb begin
        out.rgb = rgb;
    end
    
endmodule

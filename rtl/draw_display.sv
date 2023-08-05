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
    //input logic clk_data,
    //input logic reset,
    input reg[7:0] data [0:255],
    //input logic [7:0] graph_scale,

    vga_if.in in,
    vga_if.out out
    );
    import vga_pkg::*;
        // Dodaj resztę kodu z poprzedniego przykładu

    
   /**
     * Local variables and signals
     */

    logic [11:0] rgb_nxt;

    /**
     * Internal logic
     */

    /*always_ff @(posedge clk) begin : bg_ff_blk
        if (rst) begin
            out.vcount <= '0;
            out.vsync  <= '0;
            out.vblnk  <= '0;
            out.hcount <= '0;
            out.hsync  <= '0;
            out.hblnk  <= '0;
            out.rgb    <= '0;
        end else begin
            out.vcount <= in.vcount;
            out.vsync  <= in.vsync;
            out.hblnk  <= in.vblnk;
            out.hcount <= in.hcount;
            out.hsync  <= in.hsync;
            out.hblnk  <= in.hblnk;
            out.rgb    <= rgb_nxt;
        end
    end*/

    /*always_comb begin
        rgb_nxt = in.rgb;
    //draw Shape display
        Draw_Shape_display(in.hcount, in.vcount, 256, 256, V_DISPLAY, H_DISPLAY)
    //draw data on display
        Draw_data_display(data, in.hcount, in.vcount, V_DISPLAY, H_DISPLAY)
    //draw checkered on display
        Draw_checkered_display(in.hcount, in.vcount, 256, 256, V_DISPLAY, H_DISPLAY)

    end*/

    /*function void Draw_Shape_display (input [10:0] in.hcount, [10:0] in.vcount, int length, int height, [10:0] V_DISPLAY, [10:0] H_DISPLAY);
        if ((in.vcount == V_DISPLAY || in.vcount == V_DISPLAY - height) && (in.hcount >= H_DISPLAY && in.hcount <= H_DISPLAY + length))                    
                rgb_nxt = 12'hf_a_0;                
            else if ((in.vcount <= V_DISPLAY || in.vcount >= V_DISPLAY - height) && (in.hcount == H_DISPLAY || in.hcount == H_DISPLAY + length))
                rgb_nxt = 12'hf_a_0;
    endfunction
    
    function void Draw_data_display (input [7:0] data [0:255], [10:0] in.hcount, [10:0] in.vcount, [10:0] V_DISPLAY, [10:0] H_DISPLAY);
        if (in.hcount - H_DISPLAY >= 0 && in.hcount - H_DISPLAY <= 255) begin
            if ((in.hcount >= H_DISPLAY && in.hcount <= H_DISPLAY + length) 
            &&  (in.vcount - V_DISPLAY == data[in.hcount - H_DISPLAY])) begin
                    rgb_nxt = 12'ha_a_0; 
            end
        end
    endfunction
// 256/32 = 8
    function void Draw_checkered_display (input [10:0] in.hcount, [10:0] in.vcount, int length, int height, [10:0] V_DISPLAY, [10:0] H_DISPLAY);
    if ((in.vcount <= V_DISPLAY && in.vcount >= V_DISPLAY - height) && (in.hcount >= H_DISPLAY && in.hcount <= H_DISPLAY + length)) begin                  
            if (in.vcount [5:0] == 6'd32 || in.hcount [5:0] == 6'd32)
                rgb_nxt = 12'hf_a_0;
    end
    endfunction
    */

endmodule

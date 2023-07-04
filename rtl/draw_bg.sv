/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Draw background.
 */


`timescale 1 ns / 1 ps

module draw_bg (
        input  logic clk,
        input  logic rst,

        vga_if.in in,
        vga_if.out out
         
    );

    import vga_pkg::*;


    /**
     * Local variables and signals
     */

    logic [11:0] rgb_nxt;

    /**
     * Internal logic
     */

    always_ff @(posedge clk) begin : bg_ff_blk
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
    end

    always_comb begin : bg_comb_blk
        if (in.vblnk || in.hblnk) begin             // Blanking region:
            rgb_nxt = in.rgb;                   // - make it it black.
        end else begin                              // Active region:
            if (in.vcount == 0)                     // - top edge:
                rgb_nxt = 12'hf_f_0;                // - - make a yellow line.
            else if (in.vcount == VER_PIXELS - 1)   // - bottom edge:
                rgb_nxt = 12'hf_0_0;                // - - make a red line.
            else if (in.hcount == 0)                // - left edge:
                rgb_nxt = 12'h0_f_0;                // - - make a green line.
            else if (in.hcount == HOR_PIXELS - 1)   // - right edge:
                rgb_nxt = 12'h0_0_f;                // - - make a blue line.
            else                                 // The rest of active display pixels:
                rgb_nxt = 12'h8_8_8;              // - fill with gray.
        
            DrawJ_Letter( 11'd100, 11'd150);
            DrawZ_Letter(11'd200, 11'd150);

        end
    end

    function void DrawRect (input [10:0] xpos, [10:0] ypos, int length, int height);
        if( ypos <= in.vcount  && xpos <= in.hcount && (xpos+length) > in.hcount && (ypos+height)  > in.vcount )
            rgb_nxt = 12'h1_2_3;
    endfunction


    function void DrawLine(input [10:0] xpos1, [10:0] ypos1, input [10:0] xpos2, [10:0] ypos2,
            input [10:0] xpos3, [10:0] ypos3, input [10:0] xpos4, [10:0] ypos4);

        int a;
        int b;

        a = int'((real'(ypos2) - real'(ypos1)) / (real'(xpos2) - real'(xpos1)));
        b = int'((real'(ypos4) - real'(ypos3)) / (real'(xpos4) - real'(xpos3)));

        if( $signed(in.vcount - ypos1) > $signed((in.hcount - xpos1)*a) ) begin
            if( $signed(in.vcount - ypos3) < $signed((in.hcount - xpos3)*b) ) begin
                if ( in.vcount >= ypos1 && in.vcount < ypos2 )
                    rgb_nxt = 12'h1_2_3;
            end
        end

    endfunction

    function void DrawCircle (input [10:0] xpos, [10:0] ypos);
        if( ((in.hcount-xpos)**2 + (in.vcount-ypos)**2 < 901) && ((in.hcount-xpos)**2 + (in.vcount-ypos)**2 > 99) ) begin
            if(in.vcount >= ypos) begin
                rgb_nxt = 12'h1_2_3;
            end
        end
    endfunction

    function void DrawZ_Letter(input [10:0] xpos, [10:0] ypos);
        DrawRect (xpos, ypos, 100, 25);
        DrawRect (xpos, ypos+125, 100, 25);
        DrawLine(xpos + 50, ypos+25, xpos, ypos+125, xpos + 100, ypos+25, xpos+50, ypos+125);
    endfunction

    function void DrawJ_Letter (input [10:0] xpos, [10:0] ypos);
        DrawRect (xpos, ypos, 60, 20);
        DrawRect (xpos + 40, ypos + 20, 20, 100);
        DrawCircle (xpos + 30, ypos + 120);
    endfunction

endmodule

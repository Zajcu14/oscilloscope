/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Jakub Zaj¹c
 *
 * Description:
 * Vga timing controller.
 */

`timescale 1 ns / 1 ps

module vga_timing (
    input  logic clk,
    input  logic rst,
    vga_if.out out
    );

    import vga_pkg::*;


    /**
     * Local variables and signals
     */

    localparam HOR_TOTAL_TIME = 1344;
    localparam HOR_BLANK_START = 1024;
    localparam HOR_BLANK_TIME = 320;
    localparam HOR_SYNC_START = 1048;
    localparam HOR_SYNC_TIME = 136;


    localparam VER_TOTAL_TIME = 806;
    localparam VER_BLANK_START = 768;
    localparam VER_BLANK_TIME = 38;
    localparam VER_SYNC_START = 771;
    localparam VER_SYNC_TIME = 6;


    logic vs_nxt;
    logic hs_nxt;
    logic vb_nxt;
    logic hb_nxt;

    logic[0:10] hcount_nxt;
    logic[0:10] vcount_nxt;


    /**
     * Internal logic
     */

    always_ff @(posedge clk) begin
        if(rst) begin
            out.vsync <= '0;
            out.hsync <= '0;
            out.vblnk <= '0;
            out.hblnk <= '0;
            out.hcount <= '0;
            out.vcount <= '0;
            out.rgb <= '0;
        end
        else begin
            out.vsync <= vs_nxt;
            out.hsync <= hs_nxt;
            out.vblnk <= vb_nxt;
            out.hblnk <= hb_nxt;
            out.hcount <= hcount_nxt;
            out.vcount <= vcount_nxt;
            out.rgb <= '0;
        end
    end

    always_comb begin
        if(out.hcount + 1 < HOR_TOTAL_TIME && out.vcount + 1 < VER_TOTAL_TIME ) begin
            hcount_nxt = out.hcount + 1;
            vcount_nxt = out.vcount;
        end
        else if(out.hcount + 1 >= HOR_TOTAL_TIME && out.vcount + 1 < VER_TOTAL_TIME ) begin
            hcount_nxt = 0;
            vcount_nxt = out.vcount + 1;
        end
        else if(out.hcount + 1 < HOR_TOTAL_TIME && out.vcount + 1 >= VER_TOTAL_TIME ) begin
            hcount_nxt = out.hcount + 1;
            vcount_nxt = out.vcount;
        end
        else begin
            hcount_nxt = 0;
            vcount_nxt = 0;
        end
    end

    always_comb begin

        if(hcount_nxt < HOR_BLANK_START) begin
            hs_nxt = 0;
            hb_nxt = 0;
        end
        else if(hcount_nxt < HOR_SYNC_START) begin
            hs_nxt = 0;
            hb_nxt = 1;
        end
        else if(hcount_nxt < HOR_SYNC_START + HOR_SYNC_TIME) begin
            hs_nxt = 1;
            hb_nxt = 1;
        end
        else if(hcount_nxt < HOR_TOTAL_TIME) begin
            hs_nxt = 0;
            hb_nxt = 1;
        end
        else begin
            hs_nxt = 0;
            hb_nxt = 0;
        end

        if(vcount_nxt < VER_BLANK_START) begin
            vs_nxt = 0;
            vb_nxt = 0;
        end
        else if(vcount_nxt < VER_SYNC_START) begin
            vs_nxt = 0;
            vb_nxt = 1;
        end
        else if(vcount_nxt < VER_SYNC_START + VER_SYNC_TIME) begin
            vs_nxt = 1;
            vb_nxt = 1;
        end
        else if(vcount_nxt < VER_BLANK_START + VER_BLANK_TIME) begin
            vs_nxt = 0;
            vb_nxt = 1;
        end
        else begin
            vs_nxt = 0;
            vb_nxt = 0;
        end
    end



endmodule

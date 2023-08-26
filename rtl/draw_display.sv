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
    input logic rst,
    input reg [11:0] data_display [0:255],
    input logic [10:0] x_mouse_pos,
    input logic [10:0] y_mouse_pos,
    input logic  minus_y,
    input logic  minus_x,
    input logic [3:0] scale_voltage,

    vga_if.in in,
    vga_if.out out
    );
    import vga_pkg::*;

    
   /**
     * Local variables and signals
     */

    logic [11:0] rgb_nxt;
    logic [1:0] case_minus = 'b0;

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
            out.vblnk  <= in.vblnk;
            out.hcount <= in.hcount;
            out.hsync  <= in.hsync;
            out.hblnk  <= in.hblnk;
            out.rgb    <= rgb_nxt;
        end
    end

    always_comb begin
        rgb_nxt = in.rgb;

        //DISPLAY__1
    //draw Shape display
        Draw_Shape_display(in.hcount, in.vcount, LENGTH_DISPLAY_1, HEIGHT_DISPLAY_1, V_DISPLAY_1, H_DISPLAY_1);
    //draw data_display on display
        Draw_data_display(data_display, in.hcount, in.vcount, V_DISPLAY_1, H_DISPLAY_1, LENGTH_DISPLAY_1, 
        HEIGHT_DISPLAY_1, x_mouse_pos, y_mouse_pos, scale_voltage);
    //draw checkered on display
        Draw_checkered_display(in.hcount, in.vcount, LENGTH_DISPLAY_1, HEIGHT_DISPLAY_1, V_DISPLAY_1, H_DISPLAY_1);

        //DISPLAY__2
    //draw Shape display
        Draw_Shape_display(in.hcount, in.vcount, LENGTH_DISPLAY_2, HEIGHT_DISPLAY_2, V_DISPLAY_2, H_DISPLAY_2);
    //draw data_display on display
        Draw_data_display_2(data_display, in.hcount, in.vcount, V_DISPLAY_2, H_DISPLAY_2, LENGTH_DISPLAY_2, HEIGHT_DISPLAY_2, x_mouse_pos, y_mouse_pos);
    //draw checkered on display
        Draw_checkered_display(in.hcount, in.vcount, LENGTH_DISPLAY_2, HEIGHT_DISPLAY_2, V_DISPLAY_2, H_DISPLAY_2);
        
    end


    function void Draw_Shape_display (input [10:0] hcount, [10:0] vcount, [10:0] length, [10:0] height, [10:0] V_DISPLAY, [10:0] H_DISPLAY);
        if ((vcount == V_DISPLAY || vcount + height == V_DISPLAY) && (hcount >= H_DISPLAY && hcount <= H_DISPLAY + length))                    
                rgb_nxt = 12'hf_a_0;                
            else if ((vcount <= V_DISPLAY && vcount + height >= V_DISPLAY) && (hcount == H_DISPLAY || hcount == H_DISPLAY + length))
                rgb_nxt = 12'hf_a_0;
    endfunction
    

    function void Draw_data_display (input [11:0] data_display [0:255], [10:0] hcount, [10:0] vcount,
         [10:0] V_DISPLAY, [10:0] H_DISPLAY, [10:0] length, [10:0] height, [10:0] x_mouse_pos, [10:0] y_mouse_pos, [3:0] scale_voltage);
        case_minus = {minus_y, minus_x};
        if ((vcount <= V_DISPLAY && vcount + height >= V_DISPLAY) && (hcount >= H_DISPLAY && hcount <= H_DISPLAY + length)) begin
            case(case_minus)
                2'b00: begin
                    if(V_DISPLAY  - vcount == (data_display[hcount - H_DISPLAY - x_mouse_pos]/(scale_voltage * 12'd4)) - y_mouse_pos)
                    rgb_nxt = 12'ha_a_0;
                end
                2'b01: begin
                    if(V_DISPLAY  - vcount == (data_display[hcount - H_DISPLAY + x_mouse_pos]/(scale_voltage * 12'd4)) - y_mouse_pos)
                    rgb_nxt = 12'ha_a_0;
                end
                2'b10: begin
                    if(V_DISPLAY  - vcount == (data_display[hcount - H_DISPLAY - x_mouse_pos]/(scale_voltage * 12'd4)) + y_mouse_pos)
                    rgb_nxt = 12'ha_a_0;
                end
                2'b11: begin
                    if(V_DISPLAY  - vcount == (data_display[hcount - H_DISPLAY + x_mouse_pos]/(scale_voltage * 12'd4)) + y_mouse_pos)
                    rgb_nxt = 12'ha_a_0; 
                end
            endcase
        end
    endfunction

// 256/32 = 8
    function void Draw_checkered_display (input [10:0] hcount, [10:0] vcount, [10:0] length, [10:0] height, [10:0] V_DISPLAY, [10:0] H_DISPLAY);
    if ((vcount <= V_DISPLAY && vcount >= V_DISPLAY - height) && (hcount >= H_DISPLAY && hcount <= H_DISPLAY + length)) begin                  
            if ((vcount - V_DISPLAY) % 7'd64 == 0 || (hcount-H_DISPLAY) % 7'd64 == 0)
                rgb_nxt = 12'hf_a_0;
    end
    endfunction


    function void Draw_data_display_2 (input [11:0] data_display [0:255], [10:0] hcount, [10:0] vcount,
        [10:0] V_DISPLAY, [10:0] H_DISPLAY, [10:0] length, [10:0] height, [10:0] x_mouse_pos, [10:0] y_mouse_pos);
       case_minus = {minus_y, minus_x};
       if ((vcount <= V_DISPLAY && vcount + height >= V_DISPLAY) && (hcount >= H_DISPLAY && hcount <= H_DISPLAY + length)) begin
           case(case_minus)
               2'b00: begin
                   if(V_DISPLAY  - vcount == (data_display[hcount - H_DISPLAY - x_mouse_pos]) - y_mouse_pos)
                   rgb_nxt = 12'ha_a_0;
               end
               2'b01: begin
                   if(V_DISPLAY  - vcount == data_display[hcount - H_DISPLAY + x_mouse_pos] - y_mouse_pos)
                   rgb_nxt = 12'ha_a_0;
               end
               2'b10: begin
                   if(V_DISPLAY  - vcount == data_display[hcount - H_DISPLAY - x_mouse_pos] + y_mouse_pos)
                   rgb_nxt = 12'ha_a_0;
               end
               2'b11: begin
                   if(V_DISPLAY  - vcount == data_display[hcount - H_DISPLAY + x_mouse_pos] + y_mouse_pos)
                   rgb_nxt = 12'ha_a_0; 
               end
           endcase
       end
   endfunction
    

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.06.2023 21:16:12
// Design Name: 
// Module Name: user_interface
// Project Name: oscilloscope
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


module user_interface(
    input logic rst,
    input logic clk,
    input logic left_mouse,
    input  logic [11:0] xpos,
    input  logic [11:0] ypos,
    output logic [10:0] x_mouse_pos,
    output logic [10:0] y_mouse_pos, 
    output logic  minus_y,
    output logic  minus_x,
    output [3:0] delay,
    output [3:0] mode,
    output [3:0] corner_freq,
    output [3:0] amplitude_scale,
    output [3:0] time_scale,
    output [3:0] scale_voltage
    );
    import vga_pkg::*;

    
    /**
      * Local variables and signals
      */
 
    logic [10:0] x_mouse_pos_nxt, y_mouse_pos_nxt;
    logic [11:0] xpos_nxt, ypos_nxt;
    logic  minus_y_nxt, minus_x_nxt;
     /**
      * Internal logic
      */
 
    always_ff @(posedge clk) begin : bg_ff_blk
        if (rst) begin
           x_mouse_pos <= '0;
           y_mouse_pos <= '0;
           minus_y <= '0;
           minus_x <= '0;
        end else begin
           x_mouse_pos <= x_mouse_pos_nxt;
           y_mouse_pos <= y_mouse_pos_nxt; 
           minus_y <= minus_y_nxt;
           minus_x <= minus_x_nxt;
        end
    end
 
    always_comb begin
        move_chart();
    end
 



    function void  move_chart;
        y_mouse_pos_nxt = y_mouse_pos;
        x_mouse_pos_nxt = x_mouse_pos;
         minus_y_nxt = minus_y; 
        minus_x_nxt = minus_x;
        if ((xpos >= V_DISPLAY_1 && xpos<= V_DISPLAY_1 + LENGTH_DISPLAY_1) 
        && (ypos <= H_DISPLAY_1 && ypos + HEIGHT_DISPLAY_1 >= H_DISPLAY_1)) begin
            if (left_mouse)begin
                y_mouse_pos_nxt = (ypos_nxt >= ypos)? (ypos_nxt - ypos) : (ypos - ypos_nxt);
                x_mouse_pos_nxt = (xpos_nxt >= xpos)? (xpos_nxt - xpos) : (xpos - xpos_nxt);
                minus_y_nxt = (ypos_nxt >= ypos)? 1'b0 : 1'b1;
                minus_x_nxt = (xpos_nxt >= xpos)? 1'b0 : 1'b1;
            end
        end else begin
            xpos_nxt = xpos;
            ypos_nxt = ypos;
        end
     endfunction
     
     


endmodule
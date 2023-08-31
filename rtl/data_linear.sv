`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.07.2023 18:56:45
// Design Name: 
// Module Name: data_linear
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


module data_linear(
    input logic clk,
    input logic rst,
    input reg [11:0] data_display [0:255],
    output reg [11:0] data_display_linear [0:511],
    input [10:0] vcount
    );
    import vga_pkg::*;

    
   /**
     * Local variables and signals
     */

    /**
     * Internal logic
     */
    logic [9:0] index;
    logic [1:0] state;
    
    always_ff @(posedge clk) begin
        if (rst) begin
         data_display_linear[0] <= '0;
         index <= 0;
         state <= 0;
        end else begin
            case(state)
            2'd0: begin
                data_display_linear[index] <= data_display [index];
                index <= index + 1;
                state <= (index == 512)? 2'd2 : 2'd1;
            end
            2'd1: begin
                data_display_linear[index] <= data_display [index - 1];
                index <= index;
                state <= 2'd0;
            end    
            2'd2: begin
                index <= (vcount > 8 & vcount < 30);
                state <= 2'd0;
            end    
            endcase

        end
        end

endmodule

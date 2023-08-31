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
    output reg [11:0] data_display_linear [0:767],
    vga_if.in in
    );
    import vga_pkg::*;

    
   /**
     * Local variables and signals
     */

    /**
     * Internal logic
     */

    always_ff @(posedge clk) begin
        if (rst) begin

        end else begin
        end
    end

    always_comb begin
        
    end

endmodule

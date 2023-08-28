/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Pawel mozgowiec
 *
 * Description:
 * Draw rect.
 */


 `timescale 1 ns / 1 ps

 module char_rom_16x16 (
     input  logic clk,
     input  logic rst,
     output logic [6:0]char_code,
     input logic [7:0]char_xy
 );
 import vga_pkg::*;
 logic [3:0] x_pos, y_pos;
 logic [7:0] char_code_nxt;
 assign x_pos = char_xy >>4;
 assign y_pos = char_xy [3:0];

 always_ff @(posedge clk) begin
     if(rst)begin
         char_code <= '0;
     end else begin
         char_code <= char_code_nxt [6:0];
     end
end

reg [0:((8*16*16) - 1)] tekst = 
{"\
ABABABABIJKLMNOP\
ABCDEFGHIJKLMNOP\
ABCDEFGHIJKLMNOP\
ABCDEFGHIJKLMNOP\
ABCDEFGHIJKLMNOP\
ABCDEFGHIJKLMNOP\
ABCDEFGHIJKLMNOP\
ABCDEFGHIJKLMNOP\
ABCDEFGHIJKLMNOP\
ABCDEFGHIJKLMNOP\
ABCDEFGHIJKLMNOP\
ABCDEFGHIJKLMNOP\
ABCDEFGHIJKLMNOP\
ABCDEFGHIJKLMNOP\
ABCDEFGHIJKLMNOP\
ABCDEFGHIJKLMNOP\
"};
 always_comb begin
    char_code_nxt = tekst [8*((y_pos*16)+x_pos) +: 8];

 end
 
 endmodule
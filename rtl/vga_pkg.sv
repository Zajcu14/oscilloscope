/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Package with vga related constants.
 */

package vga_pkg;

// Parameters for VGA Display 1024 x 768 @ 60fps using a 65 MHz clock;
localparam HOR_PIXELS = 1024;
localparam VER_PIXELS = 768;
localparam V_DISPLAY_1 = 530;
localparam H_DISPLAY_1 = 45;
localparam [10:0] LENGTH_DISPLAY_1 = 768;
localparam [10:0] HEIGHT_DISPLAY_1 = 512;

localparam V_DISPLAY_2 = 730;
localparam H_DISPLAY_2 = 20;
localparam [10:0] LENGTH_DISPLAY_2 = 896;
localparam [10:0] HEIGHT_DISPLAY_2 = 128;
// Add VGA timing parameters here and refer to them in other modules.

endpackage

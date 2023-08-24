/**
 * San Jose State University
 * EE178 Lab #4
 * Author: prof. Eric Crabilla
 *
 * Modified by:
 * 2023  AGH University of Science and Technology
 * MTM UEC2
 * Piotr Kaczmarczyk
 *
 * Description:
 * The project top module.
 */

 `timescale 1 ns / 1 ps

 module top_oscilloscope (
     input  logic clk,
     input  logic clk_mouse,
     input  logic clk_trigger,
     input  logic clk_adc,  
     input  logic rst,
     output logic vs,
     output logic hs,
     output logic [3:0] r,
     output logic [3:0] g,
     output logic [3:0] b,
     inout wire ps2_clk,
     inout wire ps2_data,
     inout logic [1:0] i2c
 );
 
 
 /**
  * Local variables and signals
  */
  
 wire  [11:0] xpos;
 wire  [11:0] ypos;
 wire  [11:0] xpos_nxt;
 wire  [11:0] ypos_nxt;
 wire left_mouse_nxt, left_mouse;
 wire minus_y, minus_x;
//wire [3:0] scale_voltage;
 
 // Clock wires
//wire clk_trigger;
//wire clk_adc;
//wire clk_mouse;
 
 // Data wires
 //wire adc_series_data;
 //wire [11:0] trigger_rom_data;
 //wire [11:0] trigger_data;
 //wire [11:0] filtered_data;
 //wire [3:0] delay;
 wire [10:0] x_mouse_pos, y_mouse_pos;
 wire [11:0] trigger_buffer [0:255];
 wire [11:0] data_adc;
 // Test wires
 //wire ready;
 //wire [11:0] data [0:399];
 /*reg [11:0] sin_data [0:255] = {  
   8'h80, 8'h82, 8'h85, 8'h87, 8'h89, 8'h8b, 8'h8d, 8'h8f,
   8'h91, 8'h93, 8'h95, 8'h97, 8'h99, 8'h9b, 8'h9d, 8'h9f,
   8'ha1, 8'ha3, 8'ha5, 8'ha7, 8'ha9, 8'hab, 8'had, 8'haf,
   8'hb1, 8'hb3, 8'hb5, 8'hb7, 8'hb9, 8'hbb, 8'hbd, 8'hbf,
   8'hc1, 8'hc3, 8'hc5, 8'hc7, 8'hc9, 8'hcb, 8'hcd, 8'hcf,
   8'hd1, 8'hd3, 8'hd5, 8'hd7, 8'hd9, 8'hdb, 8'hdd, 8'hdf,
   8'he1, 8'he3, 8'he5, 8'he7, 8'he9, 8'heb, 8'hed, 8'hef,
   8'hf1, 8'hf3, 8'hf5, 8'hf7, 8'hf9, 8'hfb, 8'hfd, 8'hff,
   8'ha1, 8'ha3, 8'ha5, 8'ha7, 8'ha9, 8'hab, 8'had, 8'haf,
   8'had, 8'hab, 8'ha9, 8'ha7, 8'ha5, 8'ha3, 8'ha1, 8'h9f,
   8'h9d, 8'h9b, 8'h99, 8'h97, 8'h95, 8'h93, 8'h91, 8'h8f,
   8'h8d, 8'h8b, 8'h89, 8'h87, 8'h85, 8'h82, 8'h80, 8'h7e,
   8'h7c, 8'h7a, 8'h78, 8'h76, 8'h74, 8'h72, 8'h70, 8'h6e,
   8'h6c, 8'h6a, 8'h68, 8'h66, 8'h64, 8'h62, 8'h60, 8'h5e,
   8'h5c, 8'h5a, 8'h58, 8'h56, 8'h54, 8'h52, 8'h50, 8'h4f,
   8'h4d, 8'h4b, 8'h49, 8'h47, 8'h45, 8'h43, 8'h41, 8'h3f,
   8'h3d, 8'h3b, 8'h3a, 8'h38, 8'h36, 8'h34, 8'h32, 8'h31,
   8'h2f, 8'h2d, 8'h2b, 8'h2a, 8'h28, 8'h26, 8'h25, 8'h23,
   8'h21, 8'h20, 8'h1e, 8'h1d, 8'h1b, 8'h1a, 8'h18, 8'h17,
   8'h16, 8'h14, 8'h13, 8'h12, 8'h10, 8'h0f, 8'h0e, 8'h0c,
   8'h0b, 8'h0a, 8'h09, 8'h08, 8'h07, 8'h06, 8'h05, 8'h04,
   8'h03, 8'h02, 8'h02, 8'h01, 8'h00, 8'h00, 8'h00, 8'h00, 
   8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 
   8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 
   8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00,
   8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 
   8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 
   8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00,
   8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 
   8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 
   8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00,
   8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00
};
 */
 
 
 //reg dft_analysis;
 
 
 // VGA signals from timing
 vga_if vga_timing();
 vga_if vga_bg();
 vga_if vga_rect();
 vga_if vga_mouse();
 vga_if vga_interface();
 vga_if vga_display();
 
 
 /**
  * Signals assignments
  */
 
 assign vs = vga_mouse.vsync;
 assign hs = vga_mouse.hsync;
 assign {r,g,b} = vga_mouse.rgb;
 
 
 /**
  * Submodules instances
  */
  
 MouseCtl u_mouse_ctl(
     .ps2_data(ps2_data),
     .ps2_clk(ps2_clk),
     .clk(clk_mouse),
     .rst(rst),
     .xpos(xpos_nxt),
     .ypos(ypos_nxt),
     .left(left_mouse_nxt),
     .middle(),
     .new_event(),
     .right(),
     .setmax_x('0),
     .setmax_y('0),
     .setx('0),
     .sety('0),
     .value('0),
     .zpos()
 );
  
 vga_timing u_vga_timing (
     .clk,
     .rst,
     .out(vga_timing)
 );
 
 // Generate graph
 
/*sin_gen u_graph_gen(
    .clk,
    .out(),
    .ready()
    );*/

 draw_bg u_draw_bg ( 
     .clk,
     .rst,
 
     .in(vga_timing),
     .out(vga_bg)
     //.data()
 );
 
 delay #(.WIDTH(25),
   .CLK_DEL(4)) 
 u_delay_mouse(
    .clk(clk),
    .rst(rst),
    .din({xpos_nxt,ypos_nxt,left_mouse_nxt}),
    .dout({xpos,ypos,left_mouse})
 );
 
 draw_mouse u_draw_mouse (
     .clk,
     .xpos(xpos),
     .ypos(ypos),
     .in(vga_display),
     .out(vga_mouse)
 );
 
 draw_display u_draw_display(
    .clk,
    .rst,
    .in(vga_bg),
    .out(vga_display), 
    .scale_voltage(4'd1),
    .data_display(trigger_buffer),
    .y_mouse_pos(y_mouse_pos),
    .x_mouse_pos(x_mouse_pos),
    .minus_y(minus_y),
    .minus_x(minus_x)
   // .graph_scale({Y_scale,X_scale})
 );

 user_interface u_user_interface(
    .clk,
    .rst,
    .xpos(xpos),
    .ypos(ypos),
    .left_mouse(left_mouse),
    .y_mouse_pos(y_mouse_pos),
    .x_mouse_pos(x_mouse_pos),
    .minus_y(minus_y),
    .minus_x(minus_x)
    //.delay(delay),
    //.mode(),
    //.scale_voltage()
    //.threshold(threshold),
   // .corner_freq(),
   // .amplitude_scale(Y_scale),
   // .time_scale(X_scale)
 );
 
 adc_control u_adc_control (
    .clk(clk_adc),
    .channel(2'b00),
    .rst,
    .sda(i2c[0]),
    .scl(i2c[1]),
    .data_output(data_adc)
);
 
 trigger u_trigger(
    .clk(clk_trigger),
    .mode(2'b01),
    .data_input(data_adc),
    .rst,
    .LEVEL_TRIGGER(8'd10), 
    .trigger_buffer(trigger_buffer)
 );
 
 
  // Niefunkcjonalne
 /*
 
 data_acqusition u_data_acquisition(
    .clk(clk),
    .read(ready),
    .data(data),
    .input_data(adc_series_data)
 );
 
 trigger_data u_trigger_data(
    .clk(clk_adc),
    .data(adc_series_data),
    .data_reg(trigger_rom_data)
 );
 
 trigger_rom u_trigger_rom(
    .clk(clk_trigger),
    .data(trigger_rom_data),
    .data_output_trigger(trigger_data),
    .data_output_display(display_data),
    .delay(delay)
  );
 
  low_pass u_low_pass(
    .clk(clk),
    .data(trigger_data),
    .filtered_data(filtered_data),
    .corner_freq(corner_freq)
  );
 
 dft u_dtt(
      .clk,
      .data(triger_data),
      .dft_analysis(dft_analysis)
  );
 */
 endmodule


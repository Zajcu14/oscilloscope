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
     input  logic rst,
     output logic vs,
     output logic hs,
     output logic [3:0] r,
     output logic [3:0] g,
     output logic [3:0] b,
     inout logic ps2_clk,
     inout logic ps2_data,
     input logic [7:0] adc
 );
 
 
 /**
  * Local variables and signals
  */
  
 wire  [11:0] xpos;
 wire  [11:0] ypos;
 wire  [11:0] xpos_nxt;
 wire  [11:0] ypos_nxt;
 
 // Clock wires
wire clk_trigger;
wire clk_adc;
wire clk_mouse;
 
 // Data wires
 wire adc_series_data;
 wire [11:0] trigger_rom_data;
 wire [11:0] trigger_data;
 wire [11:0] filtered_data;
 
 reg dft_analysis;
 
 
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
 
 assign vs = vga_display.vsync;
 assign hs = vga_display.hsync;
 assign {r,g,b} = vga_display.rgb;
 
 
 /**
  * Submodules instances
  */
  
 vga_timing u_vga_timing (
     .clk,
     .rst,
     .out(vga_timing)
 );
 
 draw_bg u_draw_bg ( 
     .clk,
     .rst,
 
     .in(vga_timing),
     .out(vga_bg)
 );
 
 delay #(.WIDTH(2)) u_delay_mouse(
    .clk,
    .rst(1'b0),
    .din({xpos_nxt,ypos_nxt}),
    .dout({xpos,ypos})
 );
 
 draw_mouse u_draw_mouse (
     .clk,
     .xpos(xpos),
     .ypos(ypos),
 
     .in(vga_bg),
     .out(vga_mouse)
 );
  
  MouseCtl u_mouse_ctl(
     .ps2_data(ps2_data),
     .ps2_clk(ps2_clk),
     .clk(clk100MHz),
     .rst(rst),
     .xpos(xpos_nxt),
     .ypos(ypos_nxt),
     .left(),
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
 
 user_interface u_user_interface(
    .clk,
    .in(vga_mouse),
    .out(vga_interface),
    
    .delay(delay),
    .mode(mode),
    .threshold(threshold),
    .corner_freq(),
    .amplitude_scale(Y_scale),
    .time_scale(X_scale)
 );
 
 draw_display u_draw_display(
    .clk,
    .clk_data(clk_trigger),
    .in(vga_interface),
    .out(vga_display), 
    .reset,
    .data(display_data),
    .graph_scale({Y_scale,X_scale})
 );
 
 adc_control u_adc_control(
    .clk(clk_adc),
    .rst,
    .channel(observed_channel),
    .sda(adc_series_data)
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
  
 trigger u_trigger(
    .clk(clk_trigger),
    .data(trigger_data),
    .mode(mode),
    .threshold(threshold),
    .rst
 );
 
 dft u_dtt(
      .clk,
      .data(triger_data),
      .dft_analysis(dft_analysis)
  );
 
 endmodule

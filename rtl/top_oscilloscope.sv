/**
 *
 * Author:
 *
 * Description:
 * The project top module.
 */

 `timescale 1 ns / 1 ps

 module top_oscilloscope (
     input  logic clk,
     input  logic clk_mouse,
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
 wire  [11:0] xpos_nxt, xpos_nxt_1;
 wire  [11:0] ypos_nxt, ypos_nxt_1;
 wire left_mouse_nxt, left_mouse, right_mouse_nxt, right_mouse, middle_nxt, middle;
 wire left_mouse_nxt_1, right_mouse_nxt_1, middle_nxt_1;
 wire minus_y, minus_x;
 wire [11:0] trigger_level, counter_adc, clk_trig_max;
//wire [3:0] scale_voltage;
 
 // Clock wires
 
 // Data wires
 wire [10:0] x_mouse_pos, y_mouse_pos;
 wire [11:0] trigger_buffer [0:255];
 wire [11:0] data_display [0:255];
// wire [11:0] data_display_dft [0:63];
 //wire [11:0] filtered_data [0:255];
 wire read, ready;
 wire clk_adc;
 wire [11:0] data_adc;
 //wire [11:0] data_display_filter [0:255];
// functions variables
 logic [11:0] average;
 logic [11:0]     min;
 logic [11:0]     max;
 
 
 // VGA signals from timing
 vga_if vga_timing();
 vga_if vga_bg();
 vga_if vga_rect();
 vga_if vga_mouse();
 vga_if vga_interface();
 vga_if vga_display();
 vga_if vga_font_gen();
 
 
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
     .xpos(xpos_nxt_1),
     .ypos(ypos_nxt_1),
     .left(left_mouse_nxt_1),
     .middle(middle_nxt_1),
     .new_event(),
     .right(right_mouse_nxt_1),
     .setmax_x('d1024),
     .setmax_y('d768),
     .setx('0),
     .sety('0),
     .value('0),
     .zpos()
 );
 
functions u_functions (
   .clk,
   .rst,
   .data(data_display[0:79]),
   .average,
   .min,
   .max
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
 /*
filter u_filter(
    .clk,
    .rst,
    .data(data_display),
    .mode(1'b1),
    .filtered_data(data_display_filter)
    );
*/
 delay #(.WIDTH(27),
   .CLK_DEL(4)) 
 u_delay_mouse(
    .clk(clk),
    .rst(rst),
    .din({xpos_nxt,ypos_nxt,left_mouse_nxt,right_mouse_nxt,middle_nxt}),
    .dout({xpos,ypos,left_mouse,right_mouse,middle})
 );

 data_sync u_data_sync(
    .mclk(clk_mouse), 
    .pclk(clk), 
    .rst, 
    .x_pos(xpos_nxt_1), 
    .x_pos_sync(xpos_nxt),
    .y_pos(ypos_nxt_1), 
    .y_pos_sync(ypos_nxt),
    .left_mouse_sync(left_mouse_nxt),
    .right_mouse_sync(right_mouse_nxt),
    .middle_sync(middle_nxt),
    .left_mouse(left_mouse_nxt_1),
    .right_mouse(right_mouse_nxt_1),
    .middle(middle_nxt_1)

);
 draw_mouse u_draw_mouse (
     .clk,
     .xpos(xpos),
     .ypos(ypos),
     .in(vga_font_gen),
     .out(vga_mouse)
 );
 
 draw_display u_draw_display(
    .clk,
    .rst,
    .in(vga_bg),
    .out(vga_display), 
    .scale_voltage(4'd1),
    .data_display(data_display),
    //.data_display_filter(data_display_filter),
   // .data_display_dft (data_display_dft),
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
    .right_mouse(right_mouse),
    .middle_mouse(middle),
    .y_mouse_pos(y_mouse_pos),
    .x_mouse_pos(x_mouse_pos),
    .minus_y(minus_y),
    .minus_x(minus_x),
    .trigger(trigger_level),
    .count_adc(counter_adc),
    . trig_clk(clk_trig_max)
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

clock_adc u_clock_adc(
   .clk,
   .rst,
   .clk_adc(clk_adc),
   .counter_max(counter_adc)
);
 trigger u_trigger(
    .clk,
    .data_input(data_adc),
    .rst,
    .counter_max(counter_adc),
    .LEVEL_TRIGGER(trigger_level), 
    .trigger_buffer(trigger_buffer),
    .clk_trig_max(clk_trig_max),
    .read(read),
    .ready(ready)
 );
 font_gen u_font_gen (
   .clk,
   .rst,
	.max_bin(max),
   .min_bin(min), 
   .mea_bin(average), 
   //.p2p('b0), 
   //.rms('b0), 
   //.frq('b0),
   //.vol('b0), 
   .trigger_level(trigger_level),
   .counter_adc(counter_adc),
   .clk_trig_max(clk_trig_max),
   .in(vga_display),
   .out(vga_font_gen)
 );
 
 trigger_rom u_trigger_rom(
    .clk,
    .rst,
    .read(read),
    .ready(ready),
    .data(trigger_buffer),
    .data_output(data_display),
    .vcount(vga_bg.vcount)
    );
/*
 * 
 dft u_dtt(
      .clk,
      .rst,
      .data(data_display),
      .dft(data_display_dft)
  );
  */
 endmodule


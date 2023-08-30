`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.07.2023 11:16:25
// Design Name: 
// Module Name: font_gen
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
module font_gen
   (
      input logic clk,
      input logic rst,
     // input logic [23:0] frq,
      input logic [11:0] max_bin,
      input logic [11:0] min_bin,
      input logic [11:0] mea_bin,
     // input logic [19:0] p2p, 
      //input logic [19:0] rms,
     // input logic [15:0] vol, 
      input wire [11:0] trigger_level,
      input wire [11:0] counter_adc,
      input wire [11:0] clk_trig_max,

      vga_if.in in,
      vga_if.out out
   );
	logic font_bit;
	logic [10:0] rom_addr;
	logic [6:0] char_addr;
	logic [3:0] row_addr;
	logic [2:0] bit_addr;
	logic [7:0] font_word;
   logic  [6:0] char_addr_mx;
   logic [3:0] row_addr_mx;
   logic [2:0] bit_addr_mx;
	logic mx_on;
   logic [2:0] bit_addr_cor;

   logic  [23:0] trig, clk_adc, clk_trig, mea, min, max;

	// min signal
   logic  [6:0] char_addr_mn;
   logic [3:0] row_addr_mn;
   logic [2:0] bit_addr_mn;
	logic mn_on;	
	
	// mean signal
   logic  [6:0] char_addr_me;
   logic [3:0] row_addr_me;
   logic [2:0] bit_addr_me;
	logic me_on;
	
	/*
	// peak-peak signal
   logic  [6:0] char_addr_p2p;
   logic [3:0] row_addr_p2p;
   logic [2:0] bit_addr_p2p;
	logic p2p_on;
	
	
	// rms signal
   logic  [6:0] char_addr_rms;
   logic [3:0] row_addr_rms;
   logic [2:0] bit_addr_rms;
	logic rms_on;
	
	// Frequency1
   logic  [6:0] char_addr_frq;
   logic [3:0] row_addr_frq;
   logic [2:0] bit_addr_frq;
	logic frq_on;

	// voltage scaling
   logic [6:0] char_addr_vol;
   logic [3:0] row_addr_vol;
   logic [2:0] bit_addr_vol;
	logic vol_on;
	
	// time_scale
   logic [6:0] char_addr_time;
   logic [3:0] row_addr_time;
   logic [2:0] bit_addr_time;
	logic time_on;
*/
	// signal trig
   logic [6:0] char_addr_trig;
   logic [3:0] row_addr_trig;
   logic [2:0] bit_addr_trig;
	logic trig_on;	
	// signal clk_adc
   logic [6:0] char_addr_clk_adc;
   logic [3:0] row_addr_clk_adc;
   logic [2:0] bit_addr_clk_adc;
	logic clk_adc_on;
	
// signal clk_trig
   logic [6:0] char_addr_clk_trig;
   logic [3:0] row_addr_clk_trig;
   logic [2:0] bit_addr_clk_trig;
   logic clk_trig_on;
	
	// text
   //wire [10:0] rom_addr_text;
   //reg [6:0] char_addr_text;
   //wire [3:0] row_addr_text;
   //wire [2:0] bit_addr_text;
	//wire text_on;

   logic  [10:0] vcount_delay;
   logic  vsync_delay;
   logic  vblnk_delay;
   logic  [10:0] hcount_delay;
   logic  hsync_delay;
   logic  hblnk_delay;
   logic  [11:0] rgb_delay;

   Binary2Decimal u_Binary2Decimal(         
      .clk,
      .rst,
      .bindata(trigger_level),           //12-bit ADC values
      .decimalout(trig)
   );
   Binary2Decimal u_Binary2Decimal_2(         
      .clk,
      .rst,
      .bindata(counter_adc),           //12-bit ADC values
      .decimalout(clk_adc)
   );
   Binary2Decimal u_Binary2Decimal_3(         
      .clk,
      .rst,
      .bindata(clk_trig_max),           //12-bit ADC values
      .decimalout(clk_trig)
   );
   Binary2Decimal u_Binary2Decimal_4(         
      .clk,
      .rst,
      .bindata(mea_bin),           //12-bit ADC values
      .decimalout(mea)
   );
   Binary2Decimal u_Binary2Decimal_5(         
      .clk,
      .rst,
      .bindata(min_bin),           //12-bit ADC values
      .decimalout(min)
   );
   Binary2Decimal u_Binary2Decimal_6(         
      .clk,
      .rst,
      .bindata(max_bin),           //12-bit ADC values
      .decimalout(max)
   );
	delay #(
      .WIDTH(38),
      .CLK_DEL(2)) 
   u_delay_mouse(
    .clk(clk),
    .rst(rst),
    .din({
      in.vcount,
      in.vsync,
      in.vblnk,
      in.hcount,
      in.hsync,
      in.hblnk,
      in.rgb}),
    .dout({
      vcount_delay,
      vsync_delay,
      vblnk_delay,
      hcount_delay,
      hsync_delay,
      hblnk_delay,
      rgb_delay})
 );


   // instantiate font ROM
   font_rom u_font_rom(
      .clk(clk), 
      .addr(rom_addr), 
      .char_line_pixels(font_word)
      );
		
	
   //-------------------------------------------
   // max region
   //  - display max voltage
   //-------------------------------------------
   assign mx_on = ((10'd15<in.vcount)&&(in.vcount<10'd32)) && ((in.hcount>10'd767)&&(in.hcount<10'd888));
   assign row_addr_mx = in.vcount[3:0];
   assign bit_addr_mx = in.hcount[2:0];
   always_comb begin
      case (in.hcount[6:3])
         4'h0: char_addr_mx = 7'h56; // V
         4'h1: char_addr_mx = 7'h6d; // m
         4'h2: char_addr_mx = 7'h61; // a
         4'h3: char_addr_mx = 7'h78; // x
         4'h4: char_addr_mx = 7'h3d; // =
         4'h5: char_addr_mx = (7'd48 + max[19:16]); // digit 10
         4'h6: char_addr_mx = 7'h2e; // .
         4'h7: char_addr_mx = (7'd48 + max[15:12]); // digit 10
         4'h8: char_addr_mx = (7'd48 +  max[11:8]); // digit 10
         4'h9: char_addr_mx = (7'd48 +  max[7:4]); // digit 10
         4'ha: char_addr_mx = (7'd48 +  max[3:0]); // digit 10
         4'hb: char_addr_mx = 7'h00; // 
         4'hc: char_addr_mx = 7'h56; // V
         4'hd: char_addr_mx = 7'h00; // 
         4'he: char_addr_mx = 7'h00; // 
         4'hf: char_addr_mx = 7'h00; // 
      endcase
   end
   //-------------------------------------------
   // min region
   //  - display min voltage
   //-------------------------------------------
   assign mn_on = ((10'd31<in.vcount)&&(in.vcount<10'd48)) && ((in.hcount>10'd767)&&(in.hcount<10'd888));
   assign row_addr_mn = in.vcount[3:0];
   assign bit_addr_mn = in.hcount[2:0];
   always_comb begin
      case (in.hcount[6:3])
         4'h0: char_addr_mn = 7'h56; // V
         4'h1: char_addr_mn = 7'h6d; // m
         4'h2: char_addr_mn = 7'h69; // i
         4'h3: char_addr_mn = 7'h6e; // n
         4'h4: char_addr_mn = 7'h3d; // =
         4'h5: char_addr_mn = (7'd48 + min[19:16]); // digit 10
         4'h6: char_addr_mn = 7'h2e; // .
         4'h7: char_addr_mn = (7'd48 + min[15:12]); // digit 10
         4'h8: char_addr_mn = (7'd48 + min[11:8]); // digit 10
         4'h9: char_addr_mn = (7'd48 + min[7:4]); // digit 10
         4'ha: char_addr_mn = (7'd48 + min[3:0]); // digit 10
         4'hb: char_addr_mn = 7'h00; // 
         4'hc: char_addr_mn = 7'h56; //  V
         4'hd: char_addr_mn = 7'h00; // 
         4'he: char_addr_mn = 7'h00; // 
         4'hf: char_addr_mn = 7'h00; // 
      endcase
   end
   //-------------------------------------------
   // mean region
   //  - display mean voltage
   //-------------------------------------------
   assign me_on = ((10'd47<in.vcount)&&(in.vcount<10'd64)) && ((in.hcount>10'd767)&&(in.hcount<10'd888));
   assign row_addr_me = in.vcount[3:0];
   assign bit_addr_me = in.hcount[2:0];
   always_comb begin
      case (in.hcount[6:3])
         4'h0: char_addr_me = 7'h56; // V
         4'h1: char_addr_me = 7'h6d; // m
         4'h2: char_addr_me = 7'h65; // e
         4'h3: char_addr_me = 7'h61; // a
         4'h4: char_addr_me = 7'h3d; // =
         4'h5: char_addr_me = (7'd48 +  mea[19:16]); // digit 10
         4'h6: char_addr_me = 7'h2e; // .
         4'h7: char_addr_me = (7'd48 +  mea[15:12]); // digit 10
         4'h8: char_addr_me = (7'd48 +  mea[11:8]); // digit 10
         4'h9: char_addr_me = (7'd48 +  mea[7:4]); // digit 10
         4'ha: char_addr_me = (7'd48 +  mea[3:0]); // digit 10
         4'hb: char_addr_me = 7'h00; // 
         4'hc: char_addr_me = 7'h56; // V
         4'hd: char_addr_me = 7'h00; // 
         4'he: char_addr_me = 7'h00; // 
         4'hf: char_addr_me = 7'h00; // 
      endcase
   end
   /*
   //-------------------------------------------
   // peak-peak region
   //  - display peak-peak voltage
   //-------------------------------------------
   assign p2p_on = ((10'd63<in.vcount)&&(in.vcount<10'd80)) && ((in.hcount>10'd767)&&(in.hcount<10'd888));
   assign row_addr_p2p = in.vcount[3:0];
   assign bit_addr_p2p = in.hcount[2:0];
   always_comb begin
      case (in.hcount[6:3])
         4'h0: char_addr_p2p = 7'h56; // V
         4'h1: char_addr_p2p = 7'h70; // p
         4'h2: char_addr_p2p = 7'h32; // 2
         4'h3: char_addr_p2p = 7'h70; // p
         4'h4: char_addr_p2p = 7'h3d; // =
         4'h5: char_addr_p2p = (7'd48 +  p2p[19:16]); // digit 10
         4'h6: char_addr_p2p = 7'h2e; // .
         4'h7: char_addr_p2p = (7'd48 +  p2p[15:12]); // digit 10
         4'h8: char_addr_p2p = (7'd48 +  p2p[11:8]); // digit 10
         4'h9: char_addr_p2p = (7'd48 +  p2p[7:4]); // digit 10
         4'ha: char_addr_p2p = (7'd48 + p2p[3:0]); // digit 10
         4'hb: char_addr_p2p = 7'h00; // 
         4'hc: char_addr_p2p = 7'h56; // V
         4'hd: char_addr_p2p = 7'h00; // 
         4'he: char_addr_p2p = 7'h00; // 
         4'hf: char_addr_p2p = 7'h00; // 
      endcase
   end
   //-------------------------------------------
   // RMS region
   //  - display rms voltage
   //-------------------------------------------
   assign rms_on = ((10'd79<in.vcount)&&(in.vcount<10'd97)) && ((in.hcount>10'd767)&&(in.hcount<10'd888));
   assign row_addr_rms = in.vcount[3:0];
   assign bit_addr_rms = in.hcount[2:0];
   always_comb begin
      case (in.hcount[6:3])
         4'h0: char_addr_rms = 7'h56; // V
         4'h1: char_addr_rms = 7'h72; // r
         4'h2: char_addr_rms = 7'h6d; // m
         4'h3: char_addr_rms = 7'h73; // s
         4'h4: char_addr_rms = 7'h3d; // =
         4'h5: char_addr_rms = (7'd48 +  rms[19:16]); // digit 10
         4'h6: char_addr_rms = 7'h2e; // .
         4'h7: char_addr_rms = (7'd48 +  rms[15:12]); // digit 10
         4'h8: char_addr_rms = (7'd48 +  rms[11:8]); // digit 10
         4'h9: char_addr_rms = (7'd48 +  rms[7:4]); // digit 10
         4'ha: char_addr_rms = (7'd48 +  rms[3:0]); // digit 10
         4'hb: char_addr_rms = 7'h00; // 
         4'hc: char_addr_rms = 7'h56; // V
         4'hd: char_addr_rms = 7'h00; // 
         4'he: char_addr_rms = 7'h00; // 
         4'hf: char_addr_rms = 7'h00; // 
      endcase
   end
   //-------------------------------------------
   // Volts/div region
   //  - display scale voltage
   //-------------------------------------------
   assign vol_on = ((10'd96<in.vcount)&&(in.vcount<10'd112)) && ((in.hcount>10'd767)&&(in.hcount<10'd888));
   assign row_addr_vol = in.vcount[3:0];
	assign bit_addr_vol = in.hcount[2:0];
   always_comb begin
      case (in.hcount[6:3]) 
         4'h0: char_addr_vol = (7'd48 + 7'd0); // digit 10vol[15:12]
         4'h1: char_addr_vol = 7'h2e; // .
         4'h2: char_addr_vol = (7'd48 + 7'd7 ); // digit 10vol[11:8]
         4'h3: char_addr_vol = (7'd48 + 7'd5 ); // digit 10vol[7:4]
         4'h4: char_addr_vol = {3'b011, vol[3:0]}; // digit 10
         4'h5: char_addr_vol = 7'h56; // V
         4'h6: char_addr_vol = 7'h2f; // /
         4'h7: char_addr_vol = 7'h64; // d
         4'h8: char_addr_vol = 7'h69; // i
         4'h9: char_addr_vol = 7'h76; // v
         4'ha: char_addr_vol = 7'h00; //
         4'hb: char_addr_vol = 7'h00; // 
         4'hc: char_addr_vol = 7'h00; // 
         4'hd: char_addr_vol = 7'h00; // 
         4'he: char_addr_vol = 7'h00; // 
         4'hf: char_addr_vol = 7'h00; // 
      endcase
		end
   //-------------------------------------------
   // Frequency region
   //  - display frequency value
   //-------------------------------------------
   assign frq_on = ((10'd111<in.vcount)&&(in.vcount<10'd128)) && ((in.hcount>10'd767)&&(in.hcount<10'd888));
   assign row_addr_frq = in.vcount[3:0];
	assign bit_addr_frq = in.hcount[2:0];
   always_comb begin
      case (in.hcount[6:3])
			4'h0: char_addr_frq = (7'd48 +  frq[19:16]); // digit 10
         4'h1: char_addr_frq = (7'd48 +  frq[15:12]); // digit 10
         4'h2: char_addr_frq = 7'h2c; // ,
         4'h3: char_addr_frq = (7'd48 +  frq[11:8]); // digit 10
         4'h4: char_addr_frq = (7'd48 +  frq[7:4]); // digit 10
         4'h5: char_addr_frq = (7'd48 +  frq[3:0]); // digit 10
         4'h6: char_addr_frq = 7'h00; // digit 10
         4'h7: char_addr_frq = 7'h48; // H
         4'h8: char_addr_frq = 7'h7a; // z
         4'h9: char_addr_frq = 7'h00; // 
         4'ha: char_addr_frq = 7'h00; // 
         4'hb: char_addr_frq = 7'h00; //
         4'hc: char_addr_frq = 7'h00; // 
         4'hd: char_addr_frq = 7'h00; // 
         4'he: char_addr_frq = 7'h00; // 
         4'hf: char_addr_frq = 7'h00; // 
      endcase
   end
   //-------------------------------------------
   // TIme/div region
   //  - display scale time
   //-------------------------------------------
   assign time_on = ((10'd127<in.vcount)&&(in.vcount<10'd144)) && ((in.hcount>10'd767)&&(in.hcount<10'd888));
   assign row_addr_time = in.vcount[3:0];
	assign bit_addr_time = in.hcount[2:0];
   always_comb begin
      case (in.hcount[6:3])
         4'h0: char_addr_time = (7'd48 +7'd6); // digit 10 time1[15:12]
         4'h1: char_addr_time = 7'h2e; // .
         4'h2: char_addr_time = (7'd48 + 7'd8); // digit 10time1[11:8]
         4'h3: char_addr_time = (7'd48 + 7'd6);  // digit 10time1[7:4]);
         4'h4: char_addr_time = (7'd48 + 7'd0); // digit 10time1[3:0]
         4'h5: char_addr_time = 7'h6d; // m
         4'h6: char_addr_time = 7'h73; // s
         4'h7: char_addr_time = 7'h2f; // /
         4'h8: char_addr_time = 7'h64; // d
         4'h9: char_addr_time = 7'h69; // i
         4'ha: char_addr_time = 7'h76; //	v
         4'hb: char_addr_time = 7'h00; // 
         4'hc: char_addr_time = 7'h00; // 
         4'hd: char_addr_time = 7'h00; // 
         4'he: char_addr_time = 7'h00; // 
         4'hf: char_addr_time = 7'h00; // 
      endcase
   end
   */
   //-------------------------------------------
   // MODE region
   //  - display mode voltage
   //-------------------------------------------
   assign trig_on = ((10'd143<in.vcount)&&(in.vcount<10'd160)) && ((in.hcount>10'd767)&&(in.hcount<10'd888));
   assign row_addr_trig = in.vcount[3:0];
	assign bit_addr_trig = in.hcount[2:0];
   always_comb begin
      case (in.hcount[6:3])
         4'h0: char_addr_trig = 7'h4d; // M
         4'h1: char_addr_trig = 7'h4f; // O
         4'h2: char_addr_trig = 7'h44; // D
         4'h3: char_addr_trig = 7'h45; // E
         4'h4: char_addr_trig = 7'h3a; // :
         4'h5: char_addr_trig = 7'd48 + trig[23:20];   // dig0
         4'h6: char_addr_trig = 7'd48 + trig[19:16];   // dig1
         4'h7: char_addr_trig = 7'd48 + trig[15:12];  // dig2
         4'h8: char_addr_trig = 7'd48 + trig[11:8]; // dig3
         4'h9: char_addr_trig = 7'd48 + trig[7:4]; // dig4
         4'ha: char_addr_trig = 7'd48 + trig[3:0]; // dig5
         4'hb: char_addr_trig = 7'h00; // 
         4'hc: char_addr_trig = 7'h00; // 
         4'hd: char_addr_trig = 7'h00; // 
         4'he: char_addr_trig = 7'h00; // 
         4'hf: char_addr_trig = 7'h00; // 
      endcase
   end
   // MODE region
   //  - display mode voltage
   //-------------------------------------------
   assign clk_adc_on = ((10'd159<in.vcount)&&(in.vcount<10'd176)) && ((in.hcount>10'd767)&&(in.hcount<10'd888));
   assign row_addr_clk_adc = in.vcount[3:0];
   assign bit_addr_clk_adc = in.hcount[2:0];
   always_comb begin
      case (in.hcount[6:3])
         4'h0: char_addr_clk_adc = 7'h4d; // M
         4'h1: char_addr_clk_adc = 7'h4f; // O
         4'h2: char_addr_clk_adc = 7'h44; // D
         4'h3: char_addr_clk_adc = 7'h45; // E
         4'h4: char_addr_clk_adc = 7'h3a; // :
         4'h5: char_addr_clk_adc = 7'd48 + clk_adc[23:20];   // dig0
         4'h6: char_addr_clk_adc = 7'd48 + clk_adc[19:16];   // dig1
         4'h7: char_addr_clk_adc = 7'd48 + clk_adc[15:12];  // dig2
         4'h8: char_addr_clk_adc = 7'd48 + clk_adc[11:8]; // dig3
         4'h9: char_addr_clk_adc = 7'd48 + clk_adc[7:4]; // dig4
         4'ha: char_addr_clk_adc = 7'd48 + clk_adc[3:0]; // dig5
         4'hb: char_addr_clk_adc = 7'h00; // 
         4'hc: char_addr_clk_adc = 7'h00; // 
         4'hd: char_addr_clk_adc = 7'h00; // 
         4'he: char_addr_clk_adc = 7'h00; // 
         4'hf: char_addr_clk_adc = 7'h00; // 
      endcase
   end
    // MODE region
   //  - display mode voltage
   //-------------------------------------------
   assign clk_trig_on = ((10'd175<in.vcount)&&(in.vcount<10'd189)) && ((in.hcount>10'd767)&&(in.hcount<10'd888));
   assign row_addr_clk_trig = in.vcount[3:0];
   assign bit_addr_clk_trig = in.hcount[2:0];
   always_comb begin
      case (in.hcount[6:3])
         4'h0: char_addr_clk_trig = 7'h4d; // M
         4'h1: char_addr_clk_trig = 7'h4f; // O
         4'h2: char_addr_clk_trig = 7'h44; // D
         4'h3: char_addr_clk_trig = 7'h45; // E
         4'h4: char_addr_clk_trig = 7'h3a; // :
         4'h5: char_addr_clk_trig = 7'd48 + clk_trig[23:20];   // dig0
         4'h6: char_addr_clk_trig = 7'd48 + clk_trig[19:16];   // dig1
         4'h7: char_addr_clk_trig = 7'd48 + clk_trig[15:12];  // dig2
         4'h8: char_addr_clk_trig = 7'd48 + clk_trig[11:8]; // dig3
         4'h9: char_addr_clk_trig = 7'd48 + clk_trig[7:4]; // dig4
         4'ha: char_addr_clk_trig = 7'd48 + clk_trig[3:0]; // dig5
         4'hb: char_addr_clk_trig = 7'h00; // 
         4'hc: char_addr_clk_trig = 7'h00; // 
         4'hd: char_addr_clk_trig = 7'h00; // 
         4'he: char_addr_clk_trig = 7'h00; // 
         4'hf: char_addr_clk_trig = 7'h00; // 
      endcase
   end
   // "on" region limited to top-left corner

   // rgb multiplexing circuit
   always @(posedge clk)begin
      if (rst) begin
         out.vcount <= '0;
         out.vsync  <= '0;
         out.vblnk  <= '0;
         out.hcount <= '0;
         out.hsync  <= '0;
         out.hblnk  <= '0;
         out.rgb    <= '0;
         char_addr  <= '0;
         row_addr   <= '0;
         bit_addr   <= '0;
         
     end else begin
         out.vcount <= vcount_delay;
         out.vsync  <= vsync_delay;
         out.hblnk  <= hblnk_delay;
         out.vblnk  <= vblnk_delay;
         out.hcount <= hcount_delay;
         out.hsync  <= hsync_delay;
         out.hblnk  <= hblnk_delay;

		if(mx_on) begin                  //Vm ax
			char_addr <= char_addr_mx;
         row_addr <= row_addr_mx;
         bit_addr <= bit_addr_mx;
         if(font_bit) begin
            out.rgb <= 12'hf_f_0;// green
				end
          else begin
            out.rgb <= 12'b0;  // black
				end
			end
			
		else if(mn_on) begin              //Vmin
			char_addr <= char_addr_mn;
         row_addr <= row_addr_mn;
         bit_addr <= bit_addr_mn;
         if(font_bit) begin
            out.rgb <= 12'hf_f_0;// green
				end
          else begin
            out.rgb <= 12'b0;  // black
				end
			end
			
		else if(me_on) begin              //Vmean
			char_addr <= char_addr_me;
         row_addr <= row_addr_me;
         bit_addr <= bit_addr_me;
         if(font_bit) begin
            out.rgb <= 12'hf_f_0;// green
				end
          else begin
            out.rgb <= 12'b0;  // black
				end
			end
/*
		else if(p2p_on) begin              //Vp2p
			char_addr <= char_addr_p2p;
         row_addr <= row_addr_p2p;
         bit_addr <= bit_addr_p2p;
         if(font_bit) begin
            out.rgb <= 12'hf_f_0;// green
				end
          else begin
            out.rgb <= 12'b0;  // black
				end
			end
			
		else if(rms_on) begin              //Vrms
			char_addr <= char_addr_rms;
         row_addr <= row_addr_rms;
         bit_addr <= bit_addr_rms;
         if(font_bit) begin
            out.rgb <= 12'hf_f_0;// green
				end
          else begin
            out.rgb <= 12'b0;  // black
				end
			end
			
		else if(frq_on) begin              //Frquency
			char_addr <= char_addr_frq;
         row_addr <= row_addr_frq;
         bit_addr <= bit_addr_frq;
         if(font_bit) begin
            out.rgb <= 12'hf_f_0;// green
				end
          else begin
            out.rgb <= 12'b0;  // black
				end
			end
			
		else if(vol_on) begin              //Volts/div
			char_addr <= char_addr_vol;
         row_addr <= row_addr_vol;
         bit_addr <= bit_addr_vol;
         if(font_bit) begin
            out.rgb <= 12'hf_f_0;// green
				end
          else begin
            out.rgb <= 12'b0;  // black
				end
			end
			 
		else if(time_on) begin             //Secs/div
			char_addr <= char_addr_time;
         row_addr <= row_addr_time;
         bit_addr <= bit_addr_time;
         if(font_bit) begin
            out.rgb <= 12'hf_f_0;// green
				end
          else begin
            out.rgb <= 12'b0;  // black
				end
			end
			 */
		else if(trig_on) begin             //trig
		 char_addr <= char_addr_trig; 
         row_addr <= row_addr_trig;
         bit_addr <= bit_addr_trig;
        if(font_bit) begin
            out.rgb <= 12'hf_f_0;// green
				end
          else begin
            out.rgb <= 12'b0;  // black
				end
			end
		else if(clk_adc_on) begin             //clk_adc
		 char_addr <= char_addr_clk_adc; 
         row_addr <= row_addr_clk_adc;
         bit_addr <= bit_addr_clk_adc;
        if(font_bit) begin
            out.rgb <= 12'hf_f_0;// green
				end
          else begin
            out.rgb <= 12'b0;  // black
				end
			end
			else if(clk_trig_on) begin             //clk_adc
		 char_addr <= char_addr_clk_trig; 
         row_addr <= row_addr_clk_trig;
         bit_addr <= bit_addr_clk_trig;
        if(font_bit) begin
            out.rgb <= 12'hf_f_0;// green
				end
          else begin
            out.rgb <= 12'b0;  // black
				end
			end
			
		else begin
			out.rgb <= rgb_delay;  // black
			end
	end	
   end
   //-------------------------------------------
   // font rom interface
   //-------------------------------------------
   assign rom_addr = {char_addr, row_addr};
   assign font_bit = font_word[bit_addr_cor];
   always_comb begin 
      case(bit_addr)
            3'd0: bit_addr_cor = 0;
            3'd1: bit_addr_cor = 7;
            3'd2: bit_addr_cor = 6;
            3'd3: bit_addr_cor = 5;
            3'd4: bit_addr_cor = 4;
            3'd5: bit_addr_cor = 3;
            3'd6: bit_addr_cor = 2;
            3'd7: bit_addr_cor = 1;
      endcase
   end

    
endmodule
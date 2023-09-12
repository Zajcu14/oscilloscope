`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.07.2023 11:16:25
// Design Name: Pawe³ Mozgowiec
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
      input logic [11:0] max_bin,
      input logic [11:0] min_bin,
      //input logic [11:0] mea_bin,
      input logic [11:0] Vsk_bin,
      //input logic minus_average,
      input logic [11:0] trigger_level,
      //input logic [11:0] counter_adc,
      input logic [11:0] clk_trig_max,

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

   logic  [23:0] trig, clk_adc, clk_trig, min, max, Vsk;
   //logic  [23:0]  [23:0]mea
	// min signal
   logic [6:0] char_addr_mn;
   logic [3:0] row_addr_mn;
   logic [2:0] bit_addr_mn;
	logic mn_on;
		// Vsk signal
   logic [6:0] char_addr_vsk;
   logic [3:0] row_addr_vsk;
   logic [2:0] bit_addr_vsk;
	logic vsk_on;	
	
	// mean signal
   //logic [6:0] char_addr_me;
   //logic [3:0] row_addr_me;
   //logic [2:0] bit_addr_me;
	//logic me_on;
	
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
   /////////////////////////////////////////////////////////////
 //logic [11:0] counter_adc_2;
 //logic [11:0] mea_bin_1;
 logic [11:0] min_bin_1;
 logic [11:0] max_bin_1;
 logic [11:0] trigger_level_1;
 //logic [11:0] counter_adc_1;
 logic [11:0] clk_trig_max_1;
 logic [11:0] clk_trig_max_1_nxt;
 
 logic [11:0] Vsk_bin_1;
 logic [11:0] Vsk_bin_1_nxt;
 //logic [11:0] mea_bin_1_nxt;
 logic [11:0] min_bin_1_nxt;
 logic [11:0] max_bin_1_nxt;
 logic [11:0] trigger_level_1_nxt;
/* assign counter_adc_hz = 65000/(counter_adc * 2);
 assign mea_bin_1 = mea_bin * 3;
 assign min_bin_1 = min_bin * 3;
 assign max_bin_1 = max_bin * 3;
 assign trigger_level_1 = trigger_level * 3;
 assign clk_trig_max_1 = clk_trig_max;*/
   always_ff @(posedge clk)begin
      if (rst) begin
         //mea_bin_1 <= '0;
         min_bin_1 <= '0;
         max_bin_1 <= '0;
         trigger_level_1 <= '0;
         clk_trig_max_1 <= '0;
         Vsk_bin_1 <= '0;
     end else begin
        Vsk_bin_1 <= Vsk_bin_1_nxt * 4;
        //mea_bin_1 <= mea_bin_1_nxt;
        min_bin_1 <= min_bin_1_nxt * 4; 
        max_bin_1 <= max_bin_1_nxt * 4;
        trigger_level_1 <= trigger_level_1_nxt * 4;
        clk_trig_max_1 <= clk_trig_max_1_nxt;
     end 
   end
   always_comb begin
    //mea_bin_1_nxt = mea_bin;
    Vsk_bin_1_nxt = Vsk_bin / 5;
    min_bin_1_nxt = min_bin / 5; 
    max_bin_1_nxt = max_bin / 5;
    trigger_level_1_nxt = trigger_level / 5;
    clk_trig_max_1_nxt = clk_trig_max;
   end
   /*
   always_ff @(posedge clk)begin
      if (rst) begin
        counter_adc_1 <= '0;
        counter_adc_2 <= '0;
      end else begin
        counter_adc_1 <= counter_adc;
        counter_adc_2 <= 12'd3150 / counter_adc_1;
      end
    end  
    */
     ////////////////////////////////////////////////////////////
   
   Binary2Decimal u_Binary2Decimal(         
      .clk,
      .rst,
      .bindata(trigger_level_1),           
      .decimalout(trig)
   );
  /* Binary2Decimal u_Binary2Decimal_2(         
      .clk,
      .rst,
      .bindata(counter_adc_2),           
      .decimalout(clk_adc)
   );
   */
   Binary2Decimal u_Binary2Decimal_3(         
      .clk,
      .rst,
      .bindata(clk_trig_max_1),           
      .decimalout(clk_trig)
   );
   /*Binary2Decimal u_Binary2Decimal_4(         
      .clk,
      .rst,
      .bindata(mea_bin_1),           
      .decimalout(mea)
   );
   */
   Binary2Decimal u_Binary2Decimal_5(         
      .clk,
      .rst,
      .bindata(min_bin_1),           
      .decimalout(min)
   );
   Binary2Decimal u_Binary2Decimal_6(         
      .clk,
      .rst,
      .bindata(max_bin_1),           
      .decimalout(max)
   );
   Binary2Decimal u_Binary2Decimal_7(         
      .clk,
      .rst,
      .bindata(Vsk_bin_1),           
      .decimalout(Vsk)
   );
   
   ////////////////////////////////////////////////////////////
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
         4'h5: char_addr_mx = 7'h00; //
         4'h6: char_addr_mx = (7'd48 + max[23:20]); // digit 0
         4'h7: char_addr_mx = (7'd48 + max[19:16]); // digit 1
         4'h8: char_addr_mx = (7'd48 + max[15:12]); // digit 2
         4'h9: char_addr_mx = (7'd48 +  max[11:8]); // digit 3
         4'ha: char_addr_mx = (7'd48 +  max[7:4]);  // digit 4
         4'hb: char_addr_mx = (7'd48 +  max[3:0]);  // digit 5
         4'hc: char_addr_mx = 7'h6d; // m
         4'hd: char_addr_mx = 7'h56; // V 
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
         4'h5: char_addr_mn = 7'h2d; // -
         4'h6: char_addr_mn = (7'd48 + min[23:20]); // digit 0
         4'h7: char_addr_mn = (7'd48 + min[19:16]); // digit 1
         4'h8: char_addr_mn = (7'd48 + min[15:12]); // digit 2
         4'h9: char_addr_mn = (7'd48 + min[11:8]);  // digit 3
         4'ha: char_addr_mn = (7'd48 + min[7:4]);   // digit 4
         4'hb: char_addr_mn = (7'd48 + min[3:0]);   // digit 5
         4'hc: char_addr_mn = 7'h6d; //  m
         4'hd: char_addr_mn = 7'h56; //  V 
         4'he: char_addr_mn = 7'h00; // 
         4'hf: char_addr_mn = 7'h00; // 
      endcase
   end
   //-------------------------------------------
   // mean region
   //  - display mean voltage
   //-------------------------------------------
   /*assign me_on = ((10'd47<in.vcount)&&(in.vcount<10'd64)) && ((in.hcount>10'd767)&&(in.hcount<10'd888));
   assign row_addr_me = in.vcount[3:0];
   assign bit_addr_me = in.hcount[2:0];
   always_comb begin
      case (in.hcount[6:3])
         4'h0: char_addr_me = 7'h56; // V
         4'h1: char_addr_me = 7'h73; // s
         4'h2: char_addr_me = 7'h72; // r
         4'h3: char_addr_me = 7'h00; //
         4'h4: char_addr_me = 7'h3d; // =
         4'h5: char_addr_me = (minus_average)? 7'h2d : 7'h00;// - v space 
         4'h6: char_addr_me = (7'd48 +  mea[23:20]); // digit 0
         4'h7: char_addr_me = (7'd48 +  mea[19:16]); // digit 1
         4'h8: char_addr_me = (7'd48 +  mea[15:12]); // digit 2
         4'h9: char_addr_me = (7'd48 +  mea[11:8]);  // digit 3
         4'ha: char_addr_me = (7'd48 +  mea[7:4]);   // digit 4
         4'hb: char_addr_me = (7'd48 +  mea[3:0]);   // digit 5
         4'hc: char_addr_me = 7'h6d; // m
         4'hd: char_addr_me = 7'h56; // V
         4'he: char_addr_me = 7'h00; // 
         4'hf: char_addr_me = 7'h00; // 
      endcase
   end
   */
   //-------------------------------------------
   // Vsk region
   //  - display Vsk voltage
   //-------------------------------------------
   assign vsk_on = ((10'd47<in.vcount)&&(in.vcount<10'd64)) && ((in.hcount>10'd767)&&(in.hcount<10'd888));//if mea (10'd63<in.vcount)&&(in.vcount<10'd80)
   assign row_addr_vsk = in.vcount[3:0];
   assign bit_addr_vsk = in.hcount[2:0];
   always_comb begin
      case (in.hcount[6:3])
         4'h0: char_addr_vsk = 7'h56; // V
         4'h1: char_addr_vsk = 7'h73; // s
         4'h2: char_addr_vsk = 7'h6b; // k
         4'h3: char_addr_vsk = 7'h00; //
         4'h4: char_addr_vsk = 7'h3d; // =
         4'h5: char_addr_vsk = 7'h00; // 
         4'h6: char_addr_vsk = (7'd48 +  Vsk[23:20]); // digit 0
         4'h7: char_addr_vsk = (7'd48 +  Vsk[19:16]); // digit 1
         4'h8: char_addr_vsk = (7'd48 +  Vsk[15:12]); // digit 2
         4'h9: char_addr_vsk = (7'd48 +  Vsk[11:8]);  // digit 3
         4'ha: char_addr_vsk = (7'd48 +  Vsk[7:4]);   // digit 4
         4'hb: char_addr_vsk = (7'd48 +  Vsk[3:0]);   // digit 5
         4'hc: char_addr_vsk = 7'h6d; // m
         4'hd: char_addr_vsk = 7'h56; // V
         4'he: char_addr_vsk = 7'h00; // 
         4'hf: char_addr_vsk = 7'h00; // 
      endcase
   end
   //-------------------------------------------
   // Trig region
   //  - display trig voltage
   //-------------------------------------------
   assign trig_on = ((10'd143<in.vcount)&&(in.vcount<10'd160)) && ((in.hcount>10'd767)&&(in.hcount<10'd888));
   assign row_addr_trig = in.vcount[3:0];
	assign bit_addr_trig = in.hcount[2:0];
   always_comb begin
      case (in.hcount[6:3])
         4'h0: char_addr_trig = 7'h54; // T
         4'h1: char_addr_trig = 7'h6c; // l
         4'h2: char_addr_trig = 7'h76; // v
         4'h3: char_addr_trig = 7'h6c; // l
         4'h4: char_addr_trig = 7'h3d; // =
         4'h5: char_addr_trig = 7'd48 + trig[23:20];   // dig0
         4'h6: char_addr_trig = 7'd48 + trig[19:16];   // dig1
         4'h7: char_addr_trig = 7'd48 + trig[15:12];   // dig2
         4'h8: char_addr_trig = 7'd48 + trig[11:8];    // dig3
         4'h9: char_addr_trig = 7'd48 + trig[7:4];     // dig4
         4'ha: char_addr_trig = 7'd48 + trig[3:0];     // dig5
         4'hb: char_addr_trig = 7'h00; // 
         4'hc: char_addr_trig = 7'h6d; // m
         4'hd: char_addr_trig = 7'h56; // V
         4'he: char_addr_trig = 7'h00; // 
         4'hf: char_addr_trig = 7'h00; // 
      endcase
   end
   // clk_adc region
   //  - display clk_adc Hz
   //-------------------------------------------
   assign clk_adc_on = ((10'd159<in.vcount)&&(in.vcount<10'd176)) && ((in.hcount>10'd767)&&(in.hcount<10'd895));
   assign row_addr_clk_adc = in.vcount[3:0];
   assign bit_addr_clk_adc = in.hcount[2:0];
   always_comb begin
      case (in.hcount[6:3])
         4'h0: char_addr_clk_adc = 7'h41; // A
         4'h1: char_addr_clk_adc = 7'h44; // D
         4'h2: char_addr_clk_adc = 7'h43; // C
         4'h3: char_addr_clk_adc = 7'h00; // 
         4'h4: char_addr_clk_adc = 7'h3d; // =
         4'h5: char_addr_clk_adc = 7'd00; //         + clk_adc[23:20];   // dig0
         4'h6: char_addr_clk_adc = 7'd00; //         + clk_adc[19:16] + clk_adc[15:12];   // dig1 + dig2 never write dig 1
         4'h7: char_addr_clk_adc = 7'h31; // 1     //7'd48 + clk_adc[11:8];    // dig3
         4'h8: char_addr_clk_adc = 7'h2e; // .
         4'h9: char_addr_clk_adc = 7'h39; // 9     //7'd48 + clk_adc[7:4];     // dig4
         4'ha: char_addr_clk_adc = 7'h31; // 1     //7'd48 + clk_adc[3:0];     // dig5
         4'hb: char_addr_clk_adc = 7'd00;                   
         4'hc: char_addr_clk_adc = 7'h4d; // M
         4'hd: char_addr_clk_adc = 7'h68; // h
         4'he: char_addr_clk_adc = 7'h7a; // z
         4'hf: char_addr_clk_adc = 7'h00; // 
      endcase
   end
    // clk_trig region
   //  - display clk_trig  peak
   //-------------------------------------------
   assign clk_trig_on = ((10'd175<in.vcount)&&(in.vcount<10'd189)) && ((in.hcount>10'd767)&&(in.hcount<10'd895));
   assign row_addr_clk_trig = in.vcount[3:0];
   assign bit_addr_clk_trig = in.hcount[2:0];
   always_comb begin
      case (in.hcount[6:3])
         4'h0: char_addr_clk_trig = 7'h54; // T
         4'h1: char_addr_clk_trig = 7'h43; // C
         4'h2: char_addr_clk_trig = 7'h4c; // L
         4'h3: char_addr_clk_trig = 7'h4b; // K
         4'h4: char_addr_clk_trig = 7'h3a; // :
         4'h5: char_addr_clk_trig = 7'd48 + clk_trig[23:20];   // dig0
         4'h6: char_addr_clk_trig = 7'd48 + clk_trig[19:16];   // dig1
         4'h7: char_addr_clk_trig = 7'd48 + clk_trig[15:12];   // dig2
         4'h8: char_addr_clk_trig = 7'd48 + clk_trig[11:8];    // dig3
         4'h9: char_addr_clk_trig = 7'd48 + clk_trig[7:4];     // dig4
         4'ha: char_addr_clk_trig = 7'd48 + clk_trig[3:0];     // dig5
         4'hb: char_addr_clk_trig = 7'h00; // 
         4'hc: char_addr_clk_trig = 7'h00; // 
         4'hd: char_addr_clk_trig = 7'd00; //
         4'he: char_addr_clk_trig = 7'd00; // 
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
			
			else if(vsk_on) begin              //Vsk
			char_addr <= char_addr_vsk;
         row_addr <= row_addr_vsk;
         bit_addr <= bit_addr_vsk;
         if(font_bit) begin
            out.rgb <= 12'hf_f_0;// green
				end
          else begin
            out.rgb <= 12'b0;  // black
				end
			end
			
		/*else if(me_on) begin              //Vmean
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
			else if(clk_trig_on) begin             //clk_trig
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
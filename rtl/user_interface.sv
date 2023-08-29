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
    input logic right_mouse,
    input logic middle_mouse,
    input  logic [11:0] xpos,
    input  logic [11:0] ypos,
    output logic [10:0] x_mouse_pos,
    output logic [10:0] y_mouse_pos, 
    output logic  minus_y,
    output logic  minus_x,
    output logic [11:0]  trigger,
    output logic [11:0] count_adc,
    output logic [11:0] trig_clk
    //output [3:0] delay,
    //output [3:0] mode,
    //output [3:0] corner_freq,
    //output [3:0] amplitude_scale,
    //output [3:0] time_scale,
    //output [3:0] scale_voltage
    );
    import vga_pkg::*;

    
    /**
      * Local variables and signals
      */
 
    logic [10:0] x_mouse_pos_nxt, y_mouse_pos_nxt;
    logic [11:0] xpos_state_nxt, ypos_state_nxt, xpos_state, ypos_state;
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
           xpos_state <= '0;
           ypos_state <= '0;
        end else begin
           x_mouse_pos <= x_mouse_pos_nxt;
           y_mouse_pos <= y_mouse_pos_nxt; 
           minus_y <= minus_y_nxt;
           minus_x <= minus_x_nxt;
           xpos_state <= xpos_state_nxt;
           ypos_state <= ypos_state_nxt;
        end
    end
    reg [18:0]button_counter ;
    reg [18:0] counter_adc, trigger_clk_counter;
    reg [18:0]counter;
    reg [1:0]state;
////////////////////////////////////////////////////////////////////////
    always @(posedge  clk)begin
    	if(rst)begin
    		counter_adc    <= 19'b0000_0000_0011_1100_0000 ;
            counter        <= 19'b0000_0000_0011_1100_0000;
            state          <= '0;
			button_counter <= 19'b0000_0000_0000_0000_0000;
			trigger_clk_counter <= '0;
    		end
        
    	else begin
    		case(state)
            
    			2'b00:begin
    			     if (counter_adc < 'd5)begin 
    			         counter_adc <= 'd100; 
    			         state<=2'b01;
    			          
    			     end else if(right_mouse & middle_mouse & xpos > 500 & xpos < 1000)begin
    					counter_adc <= counter_adc + 1;
    					state<=2'b01;
    					
    				end else if(left_mouse & middle_mouse & xpos > 500 & xpos < 1000)begin
    					counter_adc <= counter_adc - 1;
    					state<=2'b01;
    					

					end else if(right_mouse & middle_mouse & xpos < 500 & xpos > 100)begin
    					button_counter<=button_counter + 1;
    					state<=2'b01;
    					
					end else if(left_mouse  & middle_mouse & xpos < 500 & xpos > 100)begin
    					button_counter<=button_counter - 1;
    					state<=2'b01;

    			    end else if(right_mouse & xpos < 100)begin
    					trigger_clk_counter<= trigger_clk_counter + 1;
    					state<=2'b01;                   
    				end else if(left_mouse & xpos < 100)begin
    					trigger_clk_counter <= trigger_clk_counter - 1;
    					state<=2'b01;
    				end else begin
    				    state<=2'b00;
    				end

    			end
    			2'b01: begin
    				if(counter==20'd0_100_000)begin
    					counter <= '0;
    					state   <= '0;
    					end
    				else begin
    					counter <= counter + 1;
    					state   <= 2'b01;
    					end
    				end
    			default: begin
    				state <= '0;
    			end
    			endcase	
    		end
    	end 
///////////////////////////////////////////////////////////////////////////////////////    
    assign trigger = {button_counter[18:7]};
    assign count_adc = {counter_adc[18:7]};
    assign trig_clk = {trigger_clk_counter[18:7]};
    always_comb begin
        move_chart();
    end
 



    function void  move_chart;
        y_mouse_pos_nxt = y_mouse_pos;
        x_mouse_pos_nxt = x_mouse_pos;
        minus_y_nxt = minus_y; 
        minus_x_nxt = minus_x;
        ypos_state_nxt = ypos_state;
        xpos_state_nxt = xpos_state;
        if ((xpos >= H_DISPLAY_1 && xpos<= H_DISPLAY_1 + LENGTH_DISPLAY_1) 
        && (ypos <= V_DISPLAY_1 && ypos + HEIGHT_DISPLAY_1 >= V_DISPLAY_1)) begin
            if (left_mouse)begin
                y_mouse_pos_nxt = (ypos_state >= ypos)? (ypos_state - ypos) : (ypos - ypos_state);
                x_mouse_pos_nxt = (xpos_state >= xpos)? (xpos_state - xpos) : (xpos - xpos_state);
                minus_y_nxt = (ypos_state >= ypos)? 1'b1 : 1'b0;
                minus_x_nxt = (xpos_state >= xpos)? 1'b1 : 1'b0; 
            end
        end else begin
            xpos_state_nxt = xpos;
            ypos_state_nxt = ypos;
        end
     endfunction
     
     


endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.07.2023 10:15:13
// Design Name: Pawe� Mozgowiec
// Module Name: trigger
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

module trigger(
    input logic clk,
    input logic [11:0] data_input,
    input logic rst,
    input logic [11:0] LEVEL_TRIGGER,
    input logic [11:0] clk_trig_max, 
    output reg [11:0] trigger_buffer [0:255],
    input logic ready,
    output logic read,
    input logic [10:0] vcount
    );
    
/////////////////////////////////////////////////////////////////////////////////////////////////////////// 
   
    localparam HIST_THRESHOLD = 300;
    localparam ATTITUDE_LEVEL_TRIGGER = 8;
    localparam GND = 12'd2048;
    logic [11:0] counter;
    //reg [11:0] buffer [0:0]; 
    logic [11:0] clk_trigger;
    logic [2:0] trigger_level_case;
///////////////////////////////////////////////////////////////////////////////////////////////////////////       
//    assign buffer[0] = data_input;
  
///////////////////////////////////////////////////////////////////////////////////////////////////////////    
    
    always_ff @(posedge clk) begin
        if (rst) begin
        
            trigger_buffer[0] <= '0;
            trigger_level_case <= 3'd0;
            counter <= '0;
            clk_trigger <= '0;
            read <= '0;
//--------------------------------------------------------------
        end else begin
            if (ready)begin
            if (clk_trigger == ((clk_trig_max)))begin
                clk_trigger <= '0;
            case (trigger_level_case)
            3'd0: begin
                trigger_level_case <= (data_input >=  + GND + LEVEL_TRIGGER - ATTITUDE_LEVEL_TRIGGER)? 3'd4 : 3'd1;
                read <= 1'b0;
            end
            3'd1: begin
                trigger_level_case <= (data_input >=  + GND + LEVEL_TRIGGER + HIST_THRESHOLD - ATTITUDE_LEVEL_TRIGGER)? 
                3'd2 : ((data_input >= LEVEL_TRIGGER + GND - ATTITUDE_LEVEL_TRIGGER)? 3'd1 : 3'd0);
                read <= 1'b0;
            end
            3'd2: begin
                trigger_level_case <= (vcount < 10 || vcount > 500 )? 3'd4 : 3'd0;
                read <= 1'b0;
            end
            /*
            3'd3: begin
                trigger_level_case <= (data_input <=  + 2054 +  LEVEL_TRIGGER - HIST_THRESHOLD - ATTITUDE_LEVEL_TRIGGER)?
                 3'd4 : ((data_input <= LEVEL_TRIGGER + 2054 - ATTITUDE_LEVEL_TRIGGER)? 3'd3 : 3'd0);
                read <= 1'b0;
            end       */     
            3'd4: begin
                if(counter == 12'd256)begin
                    read <= 1'b1;
					counter <= 0;
					trigger_level_case <= 3'd0;
				end else begin
				    trigger_buffer[counter] <= data_input;
			//		trigger_buffer[0:511] <= {trigger_buffer[1:511],buffer[0]};
					counter <= counter + 1 ;
					trigger_level_case <= 3'd4;
					read <= 1'b0;
				end
		      end
		      default: begin
		      trigger_level_case <= (data_input >=  + GND + LEVEL_TRIGGER - ATTITUDE_LEVEL_TRIGGER)? 3'd4 : 3'd1;
                read <= 1'b0;
                end
		      endcase 
            end else begin
                clk_trigger <= clk_trigger + 1;
            end
            end else begin
            read <= 1'b1;
        end
       end

   end 
            
///////////////////////////////////////////////////////////////////////////////////////////////////////////            
    
endmodule
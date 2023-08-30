`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.07.2023 10:15:13
// Design Name: 
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
    output reg [11:0] trigger_buffer [0:511],
    input logic ready,
    output logic read
    );
    
/////////////////////////////////////////////////////////////////////////////////////////////////////////// 
   
    parameter HIST_THRESHOLD = 50;
    parameter ATTITUDE_LEVEL_TRIGGER = 8;
    logic [11:0] counter;
    //reg [11:0] buffer [0:0]; 
    logic [11:0] clk_trigger;
    logic [2:0] trigger_level_case;
///////////////////////////////////////////////////////////////////////////////////////////////////////////       
//    assign buffer[0] = data_input;
  
///////////////////////////////////////////////////////////////////////////////////////////////////////////    
    
    always_ff @(posedge clk) begin
        if (rst) begin
        
            for (int i = 0; i < 512; i++) begin
                trigger_buffer[i] <= '0;
            end
            trigger_level_case <= '0;
            counter <= '0;
            clk_trigger <= '0;
            read <= '0;
//--------------------------------------------------------------
        end else begin
            if (ready)begin
            if (clk_trigger==clk_trig_max * 9)begin
                clk_trigger <= '0;
            case (trigger_level_case)
            3'd0: begin
                trigger_level_case <= (data_input >= LEVEL_TRIGGER - ATTITUDE_LEVEL_TRIGGER)? 3'd1 : 3'd0;
                read <= 1'b0;
            end
            3'd1: begin
                trigger_level_case <= (data_input >= LEVEL_TRIGGER + HIST_THRESHOLD - ATTITUDE_LEVEL_TRIGGER)? 
                3'd2 : ((data_input >= LEVEL_TRIGGER - ATTITUDE_LEVEL_TRIGGER)? 3'd1 : 3'd0);
                read <= 1'b0;
            end
            3'd2: begin
                trigger_level_case <= (data_input <= LEVEL_TRIGGER - ATTITUDE_LEVEL_TRIGGER)? 3'd3 : 3'd2;
                read <= 1'b0;
            end
            3'd3: begin
                trigger_level_case <= (data_input <= LEVEL_TRIGGER - HIST_THRESHOLD - ATTITUDE_LEVEL_TRIGGER)?
                 3'd4 : ((data_input <= LEVEL_TRIGGER - ATTITUDE_LEVEL_TRIGGER)? 3'd3 : 3'd0);
                read <= 1'b0;
            end            
            3'd4: begin
                if(counter == 12'd512)begin
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

 /*   always_ff @(posedge clk) begin
        if (rst) begin
            // Sygnał resetu aktywny - zresetuj stan wyjść triggerów i indeksów buforów
            trigger_buffer[0] <= 'bz;
            trigger_index <= 'b0;
            trigger_level_case <= 'b0;
            counter_clk <= 'b0;
        end else begin
            counter_clk <= counter_clk_nxt;
            trigger_level_case <= trigger_level_case_nxt;
            if (trigger_active) begin
                trigger_buffer[trigger_index] <= data_input;
                trigger_index <= trigger_index + 1;
            end else begin
                trigger_buffer[0] <= 12'bz;
                trigger_index <= 8'b0;
            end 
        end
    end
    
always_comb begin
    counter_clk_nxt = counter_clk + 1; 
    trigger_level_case_nxt = trigger_level_case;
    trigger_active = 0;
    if (counter_clk >= 555) begin
        counter_clk_nxt = '0;
        case (mode)
            2'b01: begin            // Trigger aktywowany poziomem
                case (trigger_level_case) 
                    2'b00: begin //wait for LEVEL_TRIGGER
                        trigger_level_case_nxt = (data_input >= LEVEL_TRIGGER + HIST_THRESHOLD - ATTITUDE_LEVEL_TRIGGER)? 2'b01 : 2'b00;
                        trigger_active = 0;
                    end  
                    2'b01: begin //earlier period
                        trigger_level_case_nxt = (data_input >= LEVEL_TRIGGER + HIST_THRESHOLD - ATTITUDE_LEVEL_TRIGGER)? 2'b10 : 2'b01;
                        trigger_active = 0;

                    end 
                    2'b10: begin //trigger idle
                        trigger_level_case_nxt = (data_input <= LEVEL_TRIGGER - HIST_THRESHOLD - ATTITUDE_LEVEL_TRIGGER)? 2'b11 : 2'b10;
                        trigger_active = 1;
                    end
                    2'b11: begin //trigger idle
                        trigger_level_case_nxt = (data_input >= LEVEL_TRIGGER + HIST_THRESHOLD - ATTITUDE_LEVEL_TRIGGER)? 2'b01 : 2'b11;
                        trigger_active = 1;
                    end
                endcase
            end
        
        endcase
end
end
*/
    // Monitorowanie wejścia i triggerowanie
    /*always_ff @(posedge clk) begin
        if (rst) begin
            // Sygnał resetu aktywny - zresetuj stan wyjść triggerów i indeksów buforów
            for (int i = 0; i < 256; i++) begin
                trigger_buffer[i] <= 12'bz;
            end
            trigger_index <= 8'b0;
            trigger_level_case <= 'b0;
        end else begin
            trigger_level_case <= trigger_level_case_nxt;

            if (trigger_active) begin
                trigger_buffer[trigger_index] <= data_input;
                trigger_index <= trigger_index + 1;
            end else begin
                 for (int i = 0; i < 256; i++) begin
                trigger_buffer[i] <= 12'bz;
                end
                trigger_index <= 8'b0;
            end 
            
        end
            // Zapisz bieżące wartości jako poprzednie do kolejnej iteracji
         //   prev_data_input <= data_input;
    end
    
always_comb begin
    trigger_level_case_nxt = trigger_level_case;
    trigger_active = 0;
    case (mode)


        2'b01: begin            // Trigger aktywowany poziomem
            case (trigger_level_case) 
                2'b00: begin //wait for LEVEL_TRIGGER
                    trigger_level_case_nxt = (data_input >= LEVEL_TRIGGER + HIST_THRESHOLD - ATTITUDE_LEVEL_TRIGGER)? 2'b01 : 2'b00;
                    trigger_active = 0;
                end  
                2'b01: begin //earlier period
                    trigger_level_case_nxt = (data_input >= LEVEL_TRIGGER + HIST_THRESHOLD - ATTITUDE_LEVEL_TRIGGER)? 2'b10 : 2'b01;
                    trigger_active = 0;

                end 
                2'b10: begin //trigger idle
                    trigger_level_case_nxt = (data_input <= LEVEL_TRIGGER - HIST_THRESHOLD - ATTITUDE_LEVEL_TRIGGER)? 2'b11 : 2'b10;
                    trigger_active = 1;
                end
                2'b11: begin //trigger idle
                    trigger_level_case_nxt = (data_input >= LEVEL_TRIGGER + HIST_THRESHOLD - ATTITUDE_LEVEL_TRIGGER)? 2'b01 : 2'b11;
                    trigger_active = 1;
                end
            endcase
        end
    endcase
end

*/


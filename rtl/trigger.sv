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
    //input logic [11:0] LEVEL_TRIGGER, 
    output reg [11:0] trigger_buffer [0:255],
    output logic [7:0]  counter_clk,
    output logic [2:0] trigger_level_case
    );
    // Próg histerezy dla zbocza rosnącego i opadającego
    parameter HIST_THRESHOLD = 0; // Można dostosować wartość progową w zależności od szumów
    parameter ATTITUDE_LEVEL_TRIGGER = 8;
    parameter LEVEL_TRIGGER  = 1054;

    logic [7:0] trigger_index, trigger_index_nxt;
    logic trigger_active,trigger_active_nxt;
    logic [2:0] trigger_level_case_nxt;
    logic [7:0] counter_clk_nxt;

    always_ff @(posedge clk) begin
        if (rst) begin
            // Sygnał resetu aktywny - zresetuj stan wyjść triggerów i indeksów buforów
            trigger_buffer[0] <= 'z;
            trigger_index <= '0;
            trigger_level_case <= '0;
            counter_clk <= 8'd0;
            trigger_active <= '0;
        end else begin
            trigger_active <= trigger_active_nxt;
            counter_clk <= counter_clk_nxt; 
            trigger_level_case <= trigger_level_case_nxt;
            trigger_buffer[trigger_index + 1] <= 'z;
            trigger_index <= trigger_index_nxt;
            if (!trigger_active) begin
                trigger_buffer[0] <= 'z;
            end else begin
                trigger_buffer[trigger_index] <= data_input;
            end
            end 
            
        end
    
always_comb begin
    if (counter_clk == 555) begin
        trigger_index_nxt = trigger_index + 1;
        counter_clk_nxt = '0;        // Trigger aktywowany poziomem
                case (trigger_level_case) 
                    3'd0: begin //wait for LEVEL_TRIGGER
                        trigger_level_case_nxt = (data_input >= LEVEL_TRIGGER + HIST_THRESHOLD - ATTITUDE_LEVEL_TRIGGER)? 3'd1 : 3'd0;
                        trigger_active_nxt = 0;
                        trigger_index_nxt = 0;
                    end  
                    3'd1: begin //earlier period
                        trigger_level_case_nxt = (data_input >= LEVEL_TRIGGER + HIST_THRESHOLD - ATTITUDE_LEVEL_TRIGGER)? 3'd2 : 3'd1;
                        trigger_active_nxt = 0;
                        trigger_index_nxt = 0;
                    end 
                    3'd2: begin //trigger idle
                        trigger_level_case_nxt = (data_input >= LEVEL_TRIGGER + HIST_THRESHOLD - ATTITUDE_LEVEL_TRIGGER)? 3'd3 : 3'd2;
                        trigger_active_nxt = 1;
                        trigger_index_nxt = 0;
                    end
                    3'd3: begin //trigger idle
                        trigger_level_case_nxt = (data_input <= LEVEL_TRIGGER - HIST_THRESHOLD - ATTITUDE_LEVEL_TRIGGER)? 3'd4 : 3'd3;
                        trigger_active_nxt = 1;
                     //   trigger_index_nxt = (trigger_buffer[0] == 'z)? 0 : (trigger_index + 1);
                    end
                    3'd4: begin //trigger idle
                        trigger_level_case_nxt = (data_input >= LEVEL_TRIGGER + HIST_THRESHOLD - ATTITUDE_LEVEL_TRIGGER)? 3'd1 : 3'd4;
                        trigger_active_nxt = 1;
                    end
                endcase
     end else begin
        trigger_level_case_nxt = trigger_level_case;
        trigger_active_nxt = trigger_active;
        counter_clk_nxt = counter_clk + 1;
       trigger_index_nxt = trigger_index;
     end
end
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

endmodule

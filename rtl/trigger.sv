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
    input logic [1:0] mode,
    input logic rst,
    input logic [7:0] LEVEL_TRIGGER, 
    output reg [11:0] trigger_buffer [0:255]
    );

    // Bufory na poprzednie wartości sygnału do zastosowania histerezy
    //logic [7:0] prev_data_input;
    //logic [7:0] prev_level_trigger_value;

    // Próg histerezy dla zbocza rosnącego i opadającego
    parameter HIST_THRESHOLD = 0; // Można dostosować wartość progową w zależności od szumów
    parameter ATTITUDE_LEVEL_TRIGGER = 6;

   // Wartości początkowe dla buforów i indeksów
   // logic [7:0] rising_edge_trigger_buffer_internal [0:255];
    //logic [7:0] falling_edge_trigger_buffer_internal [0:255];
    //logic [7:0] level_trigger_buffer_internal [0:255];
    logic [7:0] trigger_index;
    logic trigger_active;
    logic [1:0] trigger_level_case_nxt, trigger_level_case;

    // Monitorowanie wejścia i triggerowanie
    always_ff @(posedge clk) begin
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



endmodule

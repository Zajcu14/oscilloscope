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
    input logic [7:0] data_input,
    input logic mode,
    input logic rst,
    input logic LEVEL_TRIGGER, 
    logic [7:0] trigger_buffer [0:255]
    );

    // Bufory na poprzednie wartości sygnału do zastosowania histerezy
    logic [7:0] prev_data_input;
    logic [7:0] prev_level_trigger_value;
    logic active;

    // Próg histerezy dla zbocza rosnącego i opadającego
    parameter HIST_THRESHOLD = 4; // Można dostosować wartość progową w zależności od szumów

   // Wartości początkowe dla buforów i indeksów
    logic [7:0] rising_edge_trigger_buffer_internal [0:255];
    logic [7:0] falling_edge_trigger_buffer_internal [0:255];
    logic [7:0] level_trigger_buffer_internal [0:255];
    logic [7:0] trigger_index = 0;

    // Monitorowanie wejścia i triggerowanie
    always_ff @(posedge clk, negedge rst) begin
        if (!rst) begin
            // Sygnał resetu aktywny - zresetuj stan wyjść triggerów i indeksów buforów
            for (int i = 0; i < 256; i++) begin
                trigger_buffer[i] <= 8'b0;
            end
            trigger_index <= 8'b0;
        end else begin
            if (trigger_active) begin
                trigger_buffer[level_trigger_index] <= data_input;
                level_trigger_index <= level_trigger_index + 1;
            end else begin
                 for (int i = 0; i < 256; i++) begin
                trigger_buffer[i] <= 8'b0;
                end
                trigger_index <= 8'b0;
            end 
        end
            // Zapisz bieżące wartości jako poprzednie do kolejnej iteracji
            prev_data_input <= data_input;
            prev_level_trigger_value <= LEVEL_TRIGGER;
        end
    end
always_comb begin
    case (mode)


        2'b01: begin            // Trigger aktywowany poziomem
            case (trigger_level_case) 
                2'b00: begin //wait for LEVEL_TRIGGER
                    trigger_level_case_nxt = (data_input >= LEVEL_TRIGGER + HIST_THRESHOLD)? 2'b01 : 2'b00;
                    trigger_active = 1

                end  
                2'b01: begin //earlier period
                    trigger_level_case_nxt = (data_input >= LEVEL_TRIGGER + HIST_THRESHOLD)? 2'b10 : 2'b01;
                    trigger_active = 0;

                end 
                2'b10: begin //trigger idle
                    trigger_level_case_nxt = (data_input <= LEVEL_TRIGGER - HIST_THRESHOLD)? 2'b00 : 2'b10;
                    trigger_active = (trigger_active)? 0 : 1;
                end
            endcase
        end
    endcase
        end


    endcase
end


endmodule

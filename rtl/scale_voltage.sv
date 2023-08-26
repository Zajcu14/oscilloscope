`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.08.2023 10:15:13
// Design Name: 
// Module Name: scale_voltage
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


module scale_voltage(
    input logic clk,
    input logic rst,
    input logic [11:0] data_input,
    input logic [1:0] scale,
    output reg [11:0] trigger_buffer [0:255]
    );

    // Bufory na poprzednie wartości sygnału do zastosowania histerezy
    //logic [7:0] prev_data_input;
    //logic [7:0] prev_level_trigger_value;

    // Próg histerezy dla zbocza rosnącego i opadającego
    //parameter HIST_THRESHOLD = 0; // Można dostosować wartość progową w zależności od szumów
    //parameter ATTITUDE_LEVEL_TRIGGER = 6;

   // Wartości początkowe dla buforów i indeksów
   // logic [7:0] rising_edge_trigger_buffer_internal [0:255];
    //logic [7:0] falling_edge_trigger_buffer_internal [0:255];
    //logic [7:0] level_trigger_buffer_internal [0:255];
    logic [7:0] trigger_index;
    //logic trigger_active;
   // logic [1:0] trigger_level_case_nxt, trigger_level_case;

    // Monitorowanie wejścia i triggerowanie
    always_ff @(posedge clk or negedge rst) begin
        if (rst) begin
            // Sygnał resetu aktywny - zresetuj stan wyjść triggerów i indeksów buforów
            for (int i = 0; i < 256; i++) begin
                trigger_buffer[i] <= 12'bz;
            end
            trigger_index <= 8'b0;
            //trigger_level_case <= 0;
        end else begin
            case(scale)
                2'b00: begin
               
                    
            
                trigger_buffer[trigger_index] <= data_input;
                trigger_index <= trigger_index + 1;
            
        end
            endcase
        end
            // Zapisz bieżące wartości jako poprzednie do kolejnej iteracji
         //   prev_data_input <= data_input;
    end
    




endmodule

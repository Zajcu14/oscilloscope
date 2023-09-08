`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.07.2023 18:56:45
// Design Name: Pawe³ Mozgowiec & Jakub Zaj¹c
// Module Name: draw_display
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
//(* CLOCK_PIN = "clk_adc" *)
module clock_adc(
    input logic clk,
    input logic rst,
    output logic clk_adc,
    input logic [11:0] counter_max
    );
    
    
    int counter;
    
    always_ff @( posedge clk) begin
        if(rst) begin
            clk_adc <= '0;
            counter <= '0;
        end
        else if(counter == counter_max)begin
            clk_adc <= ~clk_adc;
            counter <= 0;
        end
        else begin
            counter <= counter +1;
        end
    end
    
endmodule
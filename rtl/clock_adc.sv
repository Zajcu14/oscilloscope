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
     output logic clk_scl,
    input logic [11:0] counter_max
    );
    
    
    int counter;
    
    always_ff @( posedge clk) begin
        if(rst) begin
            clk_adc <= 1'b0;
            counter <= 12'd0;
            clk_scl <= 1'b0;
        end
        else if(counter == counter_max)begin
            clk_adc <= 1'b1;
            counter <= 0;
        end
        else if(counter == counter_max/2)begin
            clk_scl <= 1'b1;
            counter <= counter + 1;
        end
        else begin
            clk_scl <= 1'b0;
            clk_adc <= 1'b0;
            counter <= counter + 1;
        end
    end
    
endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.07.2023 09:31:41
// Design Name: 
// Module Name: trigger_rom
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


module trigger_rom(
    input logic clk,
    input logic rst,
    input logic read,
    output logic ready,
    input logic [11:0] data [0:511],
    output logic [11:0] data_output [0:511]
    );
    logic active;
    logic[11:0] counter;
    
    always_ff @(posedge clk)begin
        if(rst) begin
        active <= '0;
        ready <= 1'b1;
        end else begin
            if(read)
            active <= 1'b1;
             ready <= 1'b0;
            if(active) begin
            if(counter == 12'd511)begin
                    data_output[counter] <= data[counter];
                     ready <= 1'b1;                    
					 counter <= 0;
					 active <= 1'b0;
				end else begin
				    data_output[counter] <=  data[counter];
					counter <= counter + 1 ;
					active <= 1'b1;
					 ready <= 1'b0; 
                end 
            end else begin
                 ready  <= 1'b1;
                 active <= 1'b0;
            end   
          
        end
    end
    
endmodule 
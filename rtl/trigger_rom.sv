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
    output logic [11:0] data_output [0:511],
    input logic [10:0] vcount,
    input logic [10:0] hcount
    );
    logic[11:0] counter;
    logic [1:0] write;
    
    always_ff @(posedge clk)begin
        if(rst) begin
        ready <= 1'b1;
        counter <= '0;
        write <= '0;
        for (int i = 0; i < 512; i++) begin
            data_output[i] <= '0;
        end
        end else begin
                case (write)
                    2'd0: begin
                        write <= (read)? 2'd1 : 2'd0;
                        counter <= '0;
                        ready <= 1'b1; 
                    end
                    2'd1: begin
                        write <= (hcount == 600 || vcount < 6)? 2'd2 : 2'd1;
                        counter <= '0;
                        ready <= 1'b0; 
                    end
                    2'd2: begin
                        write <= (counter == 12'd512)? 2'd0 : 2'd2;
                        counter <= counter + 1 ;
                        ready <= 1'b0; 
                        data_output[counter] <=  data[counter];
                    end
                endcase 
          
        end
    end
    
endmodule 
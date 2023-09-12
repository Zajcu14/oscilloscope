`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.07.2023 09:31:41
// Design Name: Pawe³ Mozgowiec
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
    logic[11:0] counter;
    logic [1:0] write;
    
    always_ff @(posedge clk)begin
        if(rst) begin
        ready <= 1'b1;
        counter <= '0;
        write <= '0;
        data_output[0] <= '0;
        end else begin
                case (write)
                    2'd0: begin
                        write <= (read)? 2'd1 : 2'd0;
                        counter <= '0;
                        ready <= 1'b1; 
                    end
                    2'd1: begin
                        write <= 2'd2;
                        counter <= '0;
                        ready <= 1'b0; 
                    end
                    2'd2: begin
                        write <= (counter == 12'd512)? 2'd0 : 2'd2;
                        counter <= counter + 1;
                        ready <= 1'b0; 
                        data_output[counter] <=  data[counter];
                    end
                    default: begin
                     write <= (read)? 2'd1 : 2'd0;
                        counter <= '0;
                        ready <= 1'b1; 
                        end
                endcase 
          
        end
    end
  /*  always_comb begin
    if (write == 2'd2)begin
        counter_nxt = counter + 1;
    end
        counter_nxt = '0;
    end
    */
endmodule 
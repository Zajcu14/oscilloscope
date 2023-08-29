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
    vga_if.in in
    );
    logic active;
    logic[11:0] counter;
    logic [1:0] write;
    
    always_ff @(posedge clk)begin
        if(rst) begin
        active <= '0;
        ready <= 1'b1;
        counter <= '0;
        write <= '0;
        for (int i = 0; i < 512; i++) begin
            data_output[i] <= '0;
        end
        end else begin
            if(read)begin
                active <= 1'b1;
                ready <= 1'b0;
                counter <= '0;

            end else if(active) begin
                case (write)
                    2'b00: begin
                        write <= (in.hcount == 600 || in.vcount < 3)? 2'b01 : 2'b00;
                        counter <= '0;
                        ready <= 1'b0; 
                        active <= 1'b1;
                    end
                    2'b01: begin
                        write <= (counter == 12'd512)? 2'b10 : 2'b01;
                        counter <= counter + 1 ;
                        ready <= 1'b0; 
                        active <= 1'b1;
                        data_output[counter] <=  data[counter];
                    end
                    2'b10: begin
                        write <= 'b00;
                        counter <= '0;
                        ready <= 1'b1; 
                        active <= 1'b0;
                        
                    end 
                endcase 
          
            end
        end
    end
    
endmodule 
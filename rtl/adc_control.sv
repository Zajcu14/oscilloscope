`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.06.2023 13:27:38
// Design Name: 
// Module Name: adc_control
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


module adc_control(
    input logic clk,
    input logic channel,
    inout logic sda,
    output logic scl
    );
    
    typedef enum bit [1:0] {START ,CONF, READ} fsm_state;
    
    bit [3:0] counter;
    bit [3:0] counter_nxt;
    bit [7:0] address;
    
    fsm_state state;
    fsm_state state_nxt;
    
    initial begin
        
        //state = START;
        //counter = '0;
        
    end
    
    assign sda = ( state == CONF) ? address[counter] : 'bz; 
    assign scl = clk;
    
    always_ff @(posedge clk) begin
            counter <= counter_nxt;
            state <= state_nxt;
    end
    
   
    
    always_comb begin
        if(counter == 'd9) begin
            state_nxt = READ;
            counter_nxt = 0;
        end
        else begin
            state_nxt = CONF;
            counter_nxt = counter + 1;
        end
    end
    
    always_comb begin
        case (channel)
                2'b00: address = 10'b0000100010;
                2'b01: address = 10'b0001000010;
                2'b10: address = 10'b0010000010;
                2'b11: address = 10'b0100000010;
        endcase
    end
    
    
    
endmodule

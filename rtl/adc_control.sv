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
    input logic [1:0] channel,
    input logic rst,
    inout logic sda,
    output logic scl,
    output logic [11:0] data_output
    );
    
    typedef enum bit [2:0] {START, CONF , READ, ACK_SLAVE, ACK_MASTER,ACK_MASTER_OFF, OFF} fsm_state;
    
    fsm_state state;
    fsm_state state_nxt;
    
    bit [9:0] address;
    bit master;
    
    logic [10:0] counter;
    logic [10:0] counter_read;
    logic [10:0] counter_read_nxt;
    logic [10:0] counter_nxt;
    
    logic [21:0] delay;
    logic [21:0] delay_nxt;
    
    logic [15:0] adc_buffer;
    
    assign sda = ( state ==  READ  || state == ACK_SLAVE  ) ? 1'bZ : master; 
    assign scl = ( state ==  START || state == OFF ) ? 1'b1 : !clk;
   
    always_ff @(posedge clk , posedge rst ) begin
        if(rst) begin
            state <= START;
            counter <= 'b0;
            delay <= 'b0;
        end
        else if(clk) begin
            state <= state_nxt;
            counter <= counter_nxt;
            delay <= delay_nxt;
        
        end
        else begin
            state <= state;
            counter <= counter;
            delay <= delay;
        end
    end
    
    always_comb begin
        if(state == START && counter == 'b0) begin
            state_nxt = START;
            master = 'b1;
            counter_nxt = counter + 1;
        end
        else if(state == START && counter == 'b1 && delay != 'd99999) begin
         
                state_nxt = START;
                counter_nxt = counter;
                master = 'b0;
                delay_nxt = delay + 1;
        end
        else if(state == START && counter == 'b1 && delay == 'd99999) begin
         
                state_nxt = CONF;
                counter_nxt = counter + 1;
                master = 'b0;
                delay_nxt = 0;
        end
        else if(state == CONF) begin
            case(counter)
                'd9: begin
                    state_nxt = ACK_SLAVE;
                    master = address[9 - counter];
                end
                default: begin
                    state_nxt = CONF;
                    master = address[9 - counter];
                end
            endcase
            counter_nxt = counter + 1;
        end
        else if(state == ACK_SLAVE) begin
            state_nxt = READ;
            counter_nxt = counter + 1;
            master = 'b0;
        end
        else if(state == READ) begin
            case(counter)
                'd27: begin
                    state_nxt = ACK_MASTER_OFF;
                    master = 'b0;
                end
                'd18: begin
                    state_nxt = ACK_MASTER;
                    master = 'b0;
                end
                default: begin
                    state_nxt = READ;
                    master = 'b0;
                end
            endcase
            counter_nxt = counter + 1;
        end
        else if(state == ACK_MASTER) begin
                state_nxt = READ;
                counter_nxt = counter + 1;
                master = 'b0;
        end
        else if(state == ACK_MASTER_OFF) begin
                state_nxt = OFF;
                counter_nxt = counter + 1;
                master = 'b1;
                
                data_output[11] <= adc_buffer[4];
                data_output[10] <= adc_buffer[5];
                data_output[9] <= adc_buffer[6];
                data_output[8] <= adc_buffer[7];
                data_output[7] <= adc_buffer[8];
                data_output[6] <= adc_buffer[9];
                data_output[5] <= adc_buffer[10];
                data_output[4] <= adc_buffer[11];
                data_output[3] <= adc_buffer[12];
                data_output[2]  <= adc_buffer[13];
                data_output[1]  <= adc_buffer[14];
                data_output[0]  <= adc_buffer[15];
        end
        else if(state == OFF) begin
            case(counter)
                'd29: begin
                    state_nxt = OFF;
                    master = 'b1;
                    counter_nxt = counter + 1;
                end
                'd28: begin
                    state_nxt = OFF;
                    master = 'b0;
                    counter_nxt = counter + 1;
                end
                default: begin
                    state_nxt = START;
                    master = 'b1;
                    counter_nxt = 0;
                end
            endcase
        end
    end
    
    always_ff @(negedge clk, posedge rst) begin
        if(rst) begin
            counter_read <= 0;
            adc_buffer <= 'b0;
        end
        else if(state == START) begin
            counter_read <= 0;
            adc_buffer <= 'b0;
        end
        else if(state == READ) begin
            counter_read <= counter_read_nxt;
            adc_buffer[counter_read] <= sda;
        end
    end
    
    always_comb begin
        if(state == READ) 
            counter_read_nxt = counter_read + 1;
        else
            counter_read_nxt = counter_read;
    end
    
    
    
    always_comb begin
        case (channel)
                2'b00: address = 8'b01010001;
                2'b01: address = 8'b00100001;
                2'b10: address = 8'b01000001;
                2'b11: address = 8'b10000001;
        endcase
    end
    
    
    
endmodule

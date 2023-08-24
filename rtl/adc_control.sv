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
    bit master, master_nxt;

    logic [11:0] data_output_nxt;

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
            data_output <= 'b0;
            state <= START;
            counter <= 'b0;
            delay <= 'b0;
            master <= 'b0;
        end
        else if(clk) begin
            master <= master_nxt;
            state <= state_nxt;
            counter <= counter_nxt;
            delay <= delay_nxt;
            data_output <= data_output_nxt;
        
        end
        /* to nigdy sie nie wykona, always_ff ustawiony na posegde wiec zadziła kiedy clk ma stan wysoki
        else begin
            state <= state;
            counter <= counter;
            delay <= delay;
        end
        */
    end
    
    always_comb begin
        data_output_nxt = data_output;
        state_nxt = START;
        delay_nxt = delay;
        counter_nxt = counter;
        master_nxt = master;
        if(state == START && counter == 'b0) begin
            state_nxt = START;
            master_nxt = 'b1;
            counter_nxt = counter + 1;
        end
        else if(state == START && counter == 'b1 && delay != 'd99999) begin
         
                state_nxt = START;
                counter_nxt = counter;
                master_nxt = 'b0;
                delay_nxt = delay + 1;
        end
        else if(state == START && counter == 'b1 && delay == 'd99999) begin
         
                state_nxt = CONF;
                counter_nxt = counter + 1;
                master_nxt = 'b0;
                delay_nxt = 0;
        end
        else if(state == CONF) begin
            case(counter)
                11'd9: begin
                    state_nxt = ACK_SLAVE;
                    master_nxt = address[9 - counter];
                end
                default: begin
                    state_nxt = CONF;
                    master_nxt = address[9 - counter];
                end
            endcase
            counter_nxt = counter + 1;
        end
        else if(state == ACK_SLAVE) begin
            state_nxt = READ;
            counter_nxt = counter + 1;
            master_nxt = 'b0;
        end
        else if(state == READ) begin
            case(counter)
                11'd27: begin
                    state_nxt = ACK_MASTER_OFF;
                    master_nxt = 'b0;
                end
                11'd18: begin
                    state_nxt = ACK_MASTER;
                    master_nxt = 'b0;
                end
                default: begin
                    state_nxt = READ;
                    master_nxt = 'b0;
                end
            endcase
            counter_nxt = counter + 1;
        end
        else if(state == ACK_MASTER) begin
                state_nxt = READ;
                counter_nxt = counter + 1;
                master_nxt = 'b0;
        end
        else if(state == ACK_MASTER_OFF) begin
                state_nxt = OFF;
                counter_nxt = counter + 1;
                master_nxt = 'b1;
                
                data_output_nxt[11] = adc_buffer[4];
                data_output_nxt[10] = adc_buffer[5];
                data_output_nxt[9] = adc_buffer[6];
                data_output_nxt[8] = adc_buffer[7];
                data_output_nxt[7] = adc_buffer[8];
                data_output_nxt[6] = adc_buffer[9];
                data_output_nxt[5] = adc_buffer[10];
                data_output_nxt[4] = adc_buffer[11];
                data_output_nxt[3] = adc_buffer[12];
                data_output_nxt[2]  = adc_buffer[13];
                data_output_nxt[1]  = adc_buffer[14];
                data_output_nxt[0]  = adc_buffer[15];
        end
        else if(state == OFF) begin
            case(counter)
                11'd29: begin
                    state_nxt = OFF;
                    master_nxt = 'b1;
                    counter_nxt = counter + 1;
                end
                11'd28: begin
                    state_nxt = OFF;
                    master_nxt = 'b0;
                    counter_nxt = counter + 1;
                end
                default: begin
                    state_nxt = START;
                    master_nxt = 'b1;
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
                2'b00: address[7:0]  = 8'b01010001;
                2'b01: address[7:0]  = 8'b00100001;
                2'b10: address[7:0]  = 8'b01000001;
                2'b11: address[7:0]  = 8'b10000001;
        endcase
    end
    
    
    
endmodule

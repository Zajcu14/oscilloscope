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
    output logic [11:0] data_output,
    output logic ready,
    output logic ack
    );
    
    typedef enum bit [3:0] {START, CONF ,WRITE, READ, ACK_SLAVE, ACK_MASTER,ACK_MASTER_OFF, OFF, OFF_LOW, ACK_SLAVE_OFF} fsm_state;
    
    localparam device_address = 8'b01010000;
   
    fsm_state state;
    fsm_state state_nxt;
    
    bit [7:0] channel_address;
    bit [7:0] fast_mode;
    bit [9:0] address;
    
    bit master_all;
    bit master_high;
    bit master;
   
    logic [10:0] counter;
    logic [10:0] counter_read;
    logic [10:0] counter_read_nxt;
    logic [10:0] counter_nxt;
    
    logic [21:0] delay;
    logic [21:0] delay_nxt;
    
    logic [1:0] mode;
    logic [1:0] mode_nxt;
    
    logic [15:0] adc_buffer;


    /**
     * Assigments
     */
    
    assign master_all = ( state ==  OFF_LOW ) ? master_high : master;
    assign sda = ( state ==  READ  || state == ACK_SLAVE || state == ACK_SLAVE_OFF) ? 1'bZ : master_all; 
    assign scl = ( state ==  START || state == OFF ) ? 1'b1 : !clk;
   
   always_ff @(negedge clk) begin
        if(state == OFF_LOW) 
            master_high <= 'b1;
        else
            master_high <= 'b0;
    end
   
    always_ff @(posedge clk , posedge rst ) begin
        if(rst) begin
            state <= START;
            counter <= 'b0;
            delay <= 'b0;
            mode <= 2'b11;
            
        end
        else begin
            state <= state_nxt;
            counter <= counter_nxt;
            delay <= delay_nxt;
            mode <= mode_nxt;
        end
    end
    
    
    always_comb begin
        if(state == START && counter == 'b0 &&  delay != 'd10 ) begin
            state_nxt = START;
            master = 'b1;
            counter_nxt = counter;
            delay_nxt = delay + 1;
            mode_nxt = mode;
        end
        if(state == START && counter == 'b0 && delay == 'd10) begin
            state_nxt = START;
            master = 'b1;
            counter_nxt = counter +1;
            delay_nxt = delay + 1;
            mode_nxt = mode;
        end
        else if(state == START && counter == 'b1 && delay != 'd99) begin
  
                state_nxt = START;
                counter_nxt = counter;
                master = 'b0;
                delay_nxt = delay + 1;
                mode_nxt = mode;
        end
        else if(state == START && counter == 'b1 && delay == 'd99) begin
         
                state_nxt = CONF;
                counter_nxt = counter + 1;
                master = 'b0;
                delay_nxt = 0;
                mode_nxt = mode;
        end
        else if(state == CONF) begin
            case(counter)
                'd9: begin
                    state_nxt = ACK_SLAVE;
                    if(mode == 'b1)
                        master = 'b1;
                    else
                        master = 'b0;
                end
                default: begin
                    state_nxt = CONF;
                    if(mode == 2'b11)
                        master = fast_mode[9 - counter];
                    else
                        master = address[9 - counter];
                end
            endcase
            
            counter_nxt = counter + 1;
            delay_nxt = delay_nxt;
            mode_nxt = mode;
        end
        else if(state == ACK_SLAVE) begin
            if(mode == 2'b11) begin
                state_nxt = START;
                mode_nxt = 'b0;
            end
            else if(mode == 'b1) begin
                state_nxt = READ;
                mode_nxt = mode;
            end
            else begin
                state_nxt = WRITE;
                mode_nxt = mode;
            end
                
            counter_nxt = counter + 1;
            master = 'b0;
        end
        else if(state == WRITE) begin
            case(counter)
                'd18: begin
                    state_nxt = ACK_SLAVE_OFF;
                    master = 'b0;
                end
                default: begin
                    state_nxt = WRITE;
                    master = channel_address[18 - counter];
                end
            endcase
            counter_nxt = counter + 1;
        end
        else if(state == ACK_SLAVE_OFF) begin
                state_nxt = OFF_LOW;
                counter_nxt = 0;
                mode_nxt = 'b1;
                master = 'b0;
                ack <= sda;
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
                state_nxt = OFF_LOW;
                counter_nxt = 'd0;
                master = 'b1;
                delay_nxt = 'b0;
             
                
                data_output[11] <= adc_buffer[4];
                data_output[10] <= adc_buffer[5];
                data_output[9] <= adc_buffer[6];
                data_output[8] <= adc_buffer[7];
                data_output[7] <= adc_buffer[8];
                data_output[6] <= adc_buffer[9];
                data_output[5] <= adc_buffer[10];
                data_output[4] <= adc_buffer[11];
                data_output[3] <= adc_buffer[12];
                data_output[2] <= adc_buffer[13];
                data_output[1] <= adc_buffer[14];
                data_output[0] <= adc_buffer[15];
        end
        else if(state == OFF_LOW) begin
            state_nxt = OFF;
            master = 'b0;
            counter_nxt = 'd29;
            delay_nxt = 0;
            //mode_nxt <= 'b1;
        end
        else if(state == OFF) begin
            case(counter)
                'd30: begin
                    state_nxt = OFF;
                    master = 'b1;
                    counter_nxt = counter + 1;
                end
                'd29: begin
                    state_nxt = OFF;
                    master = 'b1;
                    counter_nxt = counter + 1;
                end
                default: begin
                    if(counter == 'd45) begin
                        state_nxt = START;
                        counter_nxt = 0;
                        master = 'b1;
                    end
                    else begin
                        state_nxt = OFF;
                        counter_nxt = counter + 1;
                        master = 'b1;
                    end
                    
                    delay_nxt = 0;
                end
            endcase
        end
    end
    
    
    
    
    always_ff @(negedge clk, posedge rst) begin
        if(rst) begin
            counter_read <= 'd0;
            adc_buffer <= 'b0;
        end
        else if(state == READ) begin
             adc_buffer[counter_read] <= sda;
             counter_read <= counter_read_nxt;
        end
 
    end
    
    always_comb begin
        if(state == READ )
            counter_read_nxt = counter_read + 1;
        else 
            counter_read_nxt = counter_read;
    end
       
       
       
       
       
       
       
       
       
       
       
       
       
       
    always_comb begin
        case (channel)
                2'b00: begin 
                    address = 8'b01010001;
                    channel_address = 8'b00010000;
                end
                2'b01: begin 
                    address = 8'b01010001;
                    channel_address = 8'b00010000;
                end
                2'b10: begin 
                    address = 8'b01010001;
                    channel_address = 8'b00010000;
                end
                2'b11: begin 
                    address = 8'b01010001;
                    channel_address = 8'b00010000;
                end
        endcase
    end
    
    
    
endmodule
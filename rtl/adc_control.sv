`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.06.2023 13:27:38
// Design Name: Jakub Zaj¹c
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
    input logic [11:0] counter_max,
    output logic scl,
    output logic [11:0] data_output
    );
    
    typedef enum bit [3:0] {START, CONF ,WRITE, READ, ACK_SLAVE, ACK_MASTER,ACK_MASTER_OFF, OFF, OFF_LOW, ACK_SLAVE_OFF,TEST} fsm_state;
    
    logic [11:0] counter_time;
    logic [11:0] counter_time_nxt;
    fsm_state state;
    fsm_state state_nxt;
    
    bit [7:0] channel_address;
    bit [7:0] fast_mode;
    bit [9:0] address;
    
    logic [11:0] data_output_nxt;
    bit master_all;
    bit master_high;
    bit master;
   
    logic [5:0] counter;
    logic [5:0] counter_read;
    logic [5:0] counter_read_nxt;
    logic [5:0] counter_nxt;
    
    logic [6:0] delay;
    logic [6:0] delay_nxt;
    
    logic [1:0] mode;
    logic [1:0] mode_nxt;
       
    logic [15:0] adc_buffer;
    logic [11:0] counter_scl;
    
    logic scl_bit;
    logic master_nxt;

    /**
     * Assigments
     */
    
    assign master_all = ( state ==  OFF_LOW ) ? master_high : master;
    assign sda = ( state ==  READ  || state == ACK_SLAVE || state == ACK_SLAVE_OFF) ? 1'bZ : master_all; 
    assign scl = ( state ==  START || state == OFF  ) ? 1'b1 : scl_bit;
    
    
    always_ff @( posedge clk, posedge rst) begin
        if(rst) begin
            scl_bit <= 0;
            counter_scl <= 0;
        end
        else if(counter_scl == counter_max) begin
            scl_bit <= ~scl_bit;
            counter_scl <= 0;
        end
        else begin
            scl_bit <= scl_bit;
            counter_scl <= counter_scl + 1;
        end
    end
    
    /*always_ff @( posedge clk, posedge rst) begin
        if(rst) begin
            scl_bit <= 0;
            counter_scl <= '0;
        end
        else if ( (state ==  START && state_nxt == START)  || state_nxt == OFF) begin
            scl <= 1'b1;
            //counter_scl <= '0;
        end
        else if(counter_scl == 0)begin
            scl <= ~scl;
            counter_scl <= 1;
        end
        else begin
            if(counter_scl ==  counter_max)
                counter_scl <= 0;
            else
                counter_scl <= counter_scl + 1;
        end
    end*/
  
   
   always_ff @(posedge clk) begin
        if(state == OFF_LOW && ( counter_scl == counter_max || scl_bit) )
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
            data_output <= 12'b0;
            counter_time <= 'b0;
            master <= 'b0;
        end
        else begin
            state <= state_nxt;
            counter <= counter_nxt;
            delay <= delay_nxt;
            mode <= mode_nxt;
            data_output <= data_output_nxt;
            counter_time <= counter_time_nxt;
            master <= master_nxt;
        end
    end
    
    
    always_comb begin
    if(counter_time == ((counter_max * 2) + 1))begin
        
        counter_time_nxt = 0;
    
        if(state == START && counter == 6'b0 &&  delay != 7'd2 ) begin
            state_nxt = START;
            master_nxt = 'b1;
            counter_nxt = counter;
            delay_nxt = delay + 1;
            mode_nxt = mode;
            data_output_nxt = data_output;
            
            //scl_next = 1;
        end
        else if(state == START && counter == 6'b0 && delay == 7'd2) begin
            state_nxt = START;
            master_nxt = 'b1;
            counter_nxt = counter +1;
            delay_nxt = delay + 1;
            mode_nxt = mode;
            data_output_nxt = data_output;
            
            //scl_next = 1;
        end
        else if(state == START && counter == 6'b1 && delay != 7'd4) begin
            state_nxt = START;
            counter_nxt = counter;
            master_nxt = 'b0;
            delay_nxt = delay + 1;
            mode_nxt = mode;
            data_output_nxt = data_output;
            
            //scl_next = 1;
        end
        else if(state == START && counter == 6'b1 && delay == 7'd4) begin
            state_nxt = CONF;
            counter_nxt = counter + 1;
            master_nxt = 'b0;
            delay_nxt = 0;
            mode_nxt = mode;
            data_output_nxt = data_output;
        end
        else if(state == CONF) begin
            case(counter)
                6'd9: begin
                    state_nxt = ACK_SLAVE;
                    if(mode == 'b1)
                        master_nxt = 'b1;
                    else
                        master_nxt = 'b0;
                end
                default: begin
                    state_nxt = CONF;
                    if(mode == 2'b11)
                        master_nxt = fast_mode[9 - counter];
                    else
                        master_nxt = address[9 - counter];
                end
            endcase
            data_output_nxt = data_output;
            counter_nxt = counter + 1;
            delay_nxt = delay;
            mode_nxt = mode;
        end
        else if(state == ACK_SLAVE) begin
            if(mode == 2'b11) begin
                state_nxt = START;
                mode_nxt = 'b0;
                counter_nxt = 'b0;
            end
            else if(mode == 'b1) begin
                    state_nxt = READ;
                    mode_nxt = mode;
                    counter_nxt = counter + 1;
            end
            else begin
                state_nxt = WRITE;
                mode_nxt = mode;
                counter_nxt = counter + 1;
            end
            data_output_nxt = data_output;
            delay_nxt = delay;
            master_nxt = 'b0;
        end
        else if(state == WRITE) begin
            case(counter)
                6'd18: begin
                    state_nxt = ACK_SLAVE_OFF;
                    master_nxt = 'b0;
                end
                default: begin
                    state_nxt = WRITE;
                    master_nxt = channel_address[18 - counter];
                end
            endcase
            data_output_nxt = data_output;
            counter_nxt = counter + 1;
            mode_nxt = mode;
            delay_nxt = delay;
        end
        else if(state == ACK_SLAVE_OFF) begin
            state_nxt = OFF_LOW;
            counter_nxt = 'b0;
            mode_nxt = 'b1;
            master_nxt = 'b0;
            delay_nxt = delay;
            data_output_nxt = data_output;
        end
        else if(state == READ) begin
            case(counter)
                6'd27: begin
                    state_nxt = ACK_MASTER_OFF;
                    master_nxt = 'b0;
                end
                6'd18: begin
                    state_nxt = ACK_MASTER;
                    master_nxt = 'b0;
                end
                default: begin
                    state_nxt = READ;
                    master_nxt = 'b0;
                end
            endcase
            data_output_nxt = data_output;
            counter_nxt = counter + 1;
            delay_nxt = delay;
            mode_nxt = mode;
        end
        else if(state == ACK_MASTER) begin
            state_nxt = READ;
            counter_nxt = counter + 1;
            master_nxt = 'b0;
            delay_nxt = delay;
            mode_nxt = mode;
            data_output_nxt = data_output;
        end
        else if(state == ACK_MASTER_OFF) begin
            state_nxt = READ;
            counter_nxt = 'd11;
            master_nxt = 'b0;
            delay_nxt = 'b0;
            mode_nxt = mode;
            
            //data_output <= adc_buffer[15:4];
            
            data_output_nxt[11] = adc_buffer[4];
            data_output_nxt[10] = adc_buffer[5];
            data_output_nxt[9]  = adc_buffer[6];
            data_output_nxt[8]  = adc_buffer[7];
            data_output_nxt[7]  = adc_buffer[8];
            data_output_nxt[6]  = adc_buffer[9];
            data_output_nxt[5]  = adc_buffer[10];
            data_output_nxt[4]  = adc_buffer[11];
            data_output_nxt[3]  = adc_buffer[12];
            data_output_nxt[2]  = adc_buffer[13];
            data_output_nxt[1]  = adc_buffer[14];
            data_output_nxt[0]  = adc_buffer[15];
        end
        else if(state == OFF_LOW) begin
            state_nxt = OFF;
            master_nxt = 'b0;
            counter_nxt = 'd29;
            delay_nxt = 0;
            mode_nxt = mode;
            data_output_nxt = data_output;
            //mode_nxt <= 'b1;
        end
        else if(state == OFF) begin
            case(counter)
                6'd30: begin
                    state_nxt = OFF;
                    master_nxt = 'b1;
                    counter_nxt = counter + 1;
                end
                6'd29: begin
                    state_nxt = OFF;
                    master_nxt = 'b1;
                    counter_nxt = counter + 1;
                end
                default: begin
                    if(counter == 6'd45) begin
                        state_nxt = START;
                        counter_nxt = 0;
                        master_nxt = 'b1;
                    end
                    else begin
                        state_nxt = OFF;
                        counter_nxt = counter + 1;
                        master_nxt = 'b1;
                    end
                end
            endcase
            delay_nxt = 0;
            mode_nxt = mode;
            data_output_nxt = data_output;
        end
        else begin
            data_output_nxt = data_output;
            state_nxt = state;
            counter_nxt = counter;
            master_nxt = 'b0;
            delay_nxt = delay;
            mode_nxt = mode;
        end
            
        /*if(state == READ )begin
            counter_read_nxt = counter_read + 1;
        end else begin
            counter_read_nxt = counter_read;
        end*/
            
     end else begin
        /*if(counter_time == ((counter_max * 2) + 1))
            counter_time_nxt = 0;
        else */
            counter_time_nxt = counter_time + 1;
        state_nxt = state;
        counter_nxt = counter;
        delay_nxt = delay;
        mode_nxt = mode;
        data_output_nxt = data_output;
        master_nxt = master;
        //counter_read_nxt = counter_read;
        end
    end
    
    
    
    
    always_ff @(posedge clk, posedge rst) begin
        if(rst) begin
            counter_read <= 'd0;
            adc_buffer <= 'b0;
        end
        else if(state == READ && counter_time == counter_max) begin
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
                    fast_mode = 8'b00001000;
                end
                2'b01: begin 
                    address = 8'b01010001;
                    channel_address = 8'b00010000;
                    fast_mode = 8'b00001000;
                end
                2'b10: begin 
                    address = 8'b01010001;
                    channel_address = 8'b00010000;
                    fast_mode = 8'b00001000;
                end
                2'b11: begin 
                    address = 8'b01010001;
                    channel_address = 8'b00010000;
                    fast_mode = 8'b00001000;
                end
        endcase
    end
    
    
    
endmodule
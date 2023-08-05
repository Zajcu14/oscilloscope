`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.07.2023 11:16:25
// Design Name: 
// Module Name: sin_gen
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


module sin_gen #(parameter AMPLITUDE = 5, parameter RESOLUTION = 12) (
    input logic clk,
    output logic [11:0] out [399:0],
    output logic ready
    );
    
    localparam coef = 0.707;
    
    /*real current;
    real next;
    real previous;*/
    
    logic[15:0] current;
    logic[15:0] next;
    logic[15:0] previous;
    
    logic start;
    logic [11:0] sin_sample;
    
    logic [8:0] counter;
    logic [8:0] counter_nxt;
    
    
    
    always_ff @( posedge clk) begin
        if(start === 'x) begin
            previous <= 0;
            current <= 0;
            counter <= 0;
            out[0] <= 0;
            
            start <= 0;
        end
        else begin
            out[counter_nxt] <= next;
            current <= next;
            previous <= current;
            counter <= counter_nxt;
            
            start <= 0;
        end
    end
    
    always_comb begin
        if(counter == 399) begin
            ready = 1;
            counter_nxt = 0;
            next = 0;
        end
        else begin
            ready = 0;
            counter_nxt = counter + 1;
            //next  = Linear(current);
            next = current + 1;
        end
        
        // Next logic
        //next = Wave(current,previous);
        
        
        // Quantisation
        //sin_sample = (next * (2^RESOLUTION))/AMPLITUDE;
        
    end
    
    function int Wave(input int current,input int previos);
     
        int next_value;
        
        next_value = int'((real'( AMPLITUDE * coef * (current/(2^RESOLUTION)) ) - real'(AMPLITUDE * (previous/(2^RESOLUTION))))*((2^RESOLUTION)/AMPLITUDE));
        return next_value;
  
    endfunction
    
    function int Linear(input int current);
        return current + 1;
    endfunction
    
    function sample_data AddFloating ( input [11:0] a, [11:0] b, int range);
        return a+b;
    endfunction
    
    function sample_data MultipleFloating ( input [11:0] a, [11:0] b, int range);
        logic [23:0] a_extended = a; 
        logic [23:0] b_extended = b; 
        return a*b >> 12;
    endfunction
    
    function sample_data DivideFloating ( input [11:0] a, [11:0] b, int range);
        logic [23:0] a_extended = a; 
        logic [23:0] b_extended = b; 
        return a*b >> 12;
    endfunction
    
endmodule

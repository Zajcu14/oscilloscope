`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.08.2023 10:32:12
// Design Name: Jakub Zaj?c
// Module Name: filter
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


module filter(
    input logic clk,
    input logic rst,
    input logic [11:0] data [0:255],
    input logic mode,
    //input logic [11:0] freq_corner,
    //input logic [11:0] freq_stop,
    output logic  [11:0] filtered_data [0:255]
    );
    
    logic [11:0] next;
    logic [8:0] counter;
    logic [8:0] counter_nxt;
    
    always_ff @(posedge clk) begin
        if(rst) 
            counter <= 0;
        else 
            counter <= counter_nxt;
            
        filtered_data[counter] = next;
    end
    
   
    
    always_comb begin
        case (mode)
                1'b0: begin
                    if(counter == 'b0)
                        next = Transform(LowPass('b0, InvertTransform(data[counter])) );
                    else
                        next = Transform(LowPass(InvertTransform(filtered_data[counter - 1]), InvertTransform(data[counter])) );
                end
                1'b1:
                    begin
                    if(counter == 'b0)
                        next = Transform(HighPass('b0, InvertTransform(data[counter])) );
                    else
                        next = Transform(HighPass(InvertTransform(filtered_data[counter - 1]), InvertTransform(data[counter])) );
                end 
        endcase
    end
    
    always_comb begin
        if(counter == 255)
            counter_nxt = 'b0;
        else
            counter_nxt = counter + 1;
    end
    
    // Functions
    
    function logic [11:0] Transform(logic signed [11:0] a);     
        return 12'(13'(a) + 13'sd2048);
    endfunction
    
    function logic signed [11:0] InvertTransform(logic [11:0] a);     
        return 12'(13'($signed(a)) - 13'sd2048);
    endfunction
    
    function logic signed [11:0] LowPass(logic signed [12:0] y_prev, logic signed [12:0] x);
        return Add( Multiply(12'(int'((0.5)*2**11)),x ) , Multiply(12'(int'((0.5)*2**11)),y_prev ));
    endfunction
    
    function logic signed [11:0] HighPass(logic signed [12:0] y_prev, logic signed [12:0] x);
        logic signed [11:0] low_pass;
        low_pass = Add( Multiply(12'(int'((0.5)*2**11)),x ) , Multiply(12'(int'((0.5)*2**11)),y_prev ));
 
        return 12'(Add((-1)*low_pass,x));
    endfunction
    
    function logic signed [11:0]  Add ( input logic signed [12:0] a, logic signed [12:0] b);
        if( a + b > 13'sd2047 ) begin       
            return 12'sd2047;
        end
        
        if(a + b < -13'sd2047) begin   
            return -12'sd2047;
        end
            
        return 12'(a+b);
    endfunction
    
    function logic signed [11:0] Multiply ( input logic signed [11:0] a, logic signed [11:0] b);
        logic signed [23:0] a_extended; 
        logic signed [23:0] b_extended;

        a_extended = 23'(a);
        b_extended = 23'(b);
        
        return 12'(a_extended*b_extended >> 11);
        
    endfunction
    
endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.08.2023 10:32:12
// Design Name: 
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
    output logic  [11:0] filtered_data [0:255]
    );
    
    logic [8:0] counter;
    logic [8:0] counter_nxt;
    
    always_ff @(posedge clk) begin
        if(rst) begin
            counter <= 0;
        end
        else begin
            counter <= counter_nxt;
        end
    
    end
    
    always_comb begin
        
        case (mode)
                1'b0: begin
                    if(counter == 'b0)
                        filtered_data[counter] = LowPass('b0, data[counter]);
                    else
                        filtered_data[counter] = LowPass(filtered_data[counter - 1], data[counter]);
                end
                1'b1:
                    begin
                    if(counter == 'b0)
                        filtered_data[counter] = HighPass('b0, data[counter]);
                    else
                        filtered_data[counter] = HighPass(filtered_data[counter - 1], data[counter]);
                end 
        endcase
        if(counter == 255)
            counter_nxt = 'b0;
        else
            counter_nxt = counter + 1;
    end
    
    
    function logic signed [11:0] LowPass(logic signed [11:0] y_prev, logic signed [11:0] x);
        logic signed [11:0] y;
        y = Add( Multiply(12'(int'(0.9*2*11)),x ) , Multiply(12'(int'(0.9*2*11)),y_prev ));
        
        return y;
        
    endfunction
    
    function logic signed [11:0] HighPass(logic signed [11:0] y_prev, logic signed [11:0] x);
        logic signed [11:0] y;
        y = Add( Multiply(12'(int'(0.9*2*11)),x ) , Multiply(12'(int'(0.9*2*11)),y_prev ));
        
        return 12'(Add((-1)*y,x));
        
    endfunction
     
    function logic signed [11:0]  Add ( input logic signed [31:0] a, logic signed [31:0] b);
        if( a + b > 13'sd2047 ) begin       
            return 12'sd2047;
        end
        
        if(a + b < -13'sd2047) begin   
            return -12'sd2047;
        end
            
        return 12'(a+b);
    endfunction
    
    function logic signed [12:0] Multiply ( input logic signed [12:0] a, logic signed [12:0] b);
        logic signed [25:0] a_extended; 
        logic signed [25:0] b_extended;
        
        if(a[12] == 'b1)
            a_extended = {{11{1'b1}},a};
        else
            a_extended = {{11{1'b0}},a};
            
        if(b[12] == 'b1)
            b_extended = {{11{1'b1}},b};
        else
            b_extended = {{11{1'b0}},b};
            
        return 13'(a_extended*b_extended >> 11);
        
    endfunction
    
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.07.2023 10:09:54
// Design Name: Jakub Zaj¹c
// Module Name: dft
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


module dft(
    input logic clk,
    input logic rst,
    input logic  [11:0] data [255:0],
    output logic  [11:0] dft [63:0]
    
    
    );
    
    localparam coef = 0.8090169943749475;
    localparam sin_value = -0.5877852522924731;

    localparam SAMPLES = 63;
    typedef logic signed  [SAMPLES:0][11:0] matrix ;
    
    
    logic signed [11:0] sin_current;
    logic signed [11:0] sin_next;
    logic signed [11:0] sin_previous;
    
    logic signed [11:0] cos_current;
    logic signed [11:0] cos_next;
    logic signed [11:0] cos_previous;
    
    logic start;
    
    logic [8:0] counter;
    logic [8:0] counter_nxt;
    
    logic [8:0] counter_dft;
    logic [8:0] counter_dft_nxt;
    
    logic [8:0] counter_dft_index;
    logic [8:0] counter_dft_index_nxt;
   
    matrix real_base;
    matrix imag_base;
    
    matrix real_part;
    matrix imag_part;
    
    always_ff @(posedge clk) begin
        if(start) begin
            counter_dft <= 0;
            counter_dft_index <= 0;
           
            imag_part[0] <=  Multiply( data[0] , imag_base[0]) / (SAMPLES+1);
            real_part[0] <=  Multiply( data[0] , real_base[0]) / (SAMPLES+1);
        end
        else begin
            counter_dft <= counter_dft_nxt;
            counter_dft_index <= counter_dft_index_nxt;
            
            if( counter_dft_nxt == SAMPLES + 1) begin
                dft[counter_dft_index] <= Add( Multiply(real_part[counter_dft_index],real_part[counter_dft_index]) , |
                                               Multiply(imag_part[counter_dft_index],imag_part[counter_dft_index]) ) ;
            end
            else begin
                
                
                if(counter_dft_nxt == 'b0) begin
                    imag_part[counter_dft_index_nxt] <= Multiply( data[counter_dft_nxt*4] , imag_base[0]) / (SAMPLES+1);
                    real_part[counter_dft_index_nxt] <= Multiply( data[counter_dft_nxt*4] , real_base[0]) / (SAMPLES+1);
                    
                end
                else  begin
                    real_part[counter_dft_index] <=  Add(real_part[counter_dft_index] , ( Multiply( data[counter_dft_nxt*4] , real_base[(counter_dft_nxt * counter_dft_index)%(SAMPLES+1)])) / (SAMPLES + 1));
                    imag_part[counter_dft_index] <= (Add(imag_part[counter_dft_index] , (Multiply( data[counter_dft_nxt*4] , imag_base[(counter_dft_nxt * counter_dft_index)%(SAMPLES+1)]))/ (SAMPLES+1))) ;
                end
            end
        end
    
    end
    
    always_comb begin
        
        if(counter_dft == SAMPLES + 1) begin
        
            if( counter_dft_index == SAMPLES ) begin
                counter_dft_index_nxt = 0;
                counter_dft_nxt = 0;
            end
            else begin
                counter_dft_index_nxt = counter_dft_index + 1;
                counter_dft_nxt = 0;
            end
        end
        else begin
            counter_dft_index_nxt = counter_dft_index;;
            counter_dft_nxt = counter_dft + 1;
        end
    end
    
    
    always_ff @(posedge clk, posedge rst) begin
        if(rst) begin
            sin_current <= 12'sd0;
            sin_previous <=  12'(int'(sin_value*(2**11)));
            imag_base[0] <= 12'sd0;
            
            cos_current <= 12'sd2047;
            cos_previous <=  12'(int'(coef*(2**11)));
            real_base[0] <= 12'sd2047;
            
            counter <= 0;
            start <= 'b0;
        
        end
        else if(counter == SAMPLES) begin
                counter <= counter;
                start <= 'b0;
        end
        else begin

                sin_current <= sin_next;
                sin_previous <=  sin_current;
                imag_base[counter_nxt] <= sin_next;
                
                cos_current <= cos_next;
                cos_previous <=  cos_current;
                real_base[counter_nxt] <= cos_next;
                
                counter <= counter_nxt;
                if(counter == SAMPLES - 1)
                    start <= 'b1;
                else
                    start <= 'b0;
        end
    end
    
    always_comb begin
        if(counter == SAMPLES) begin
            counter_nxt = 'b0;
            sin_next = Wave( sin_current , sin_previous );
            cos_next = Wave( cos_current , cos_previous );
        end
        else begin
            counter_nxt = counter + 1;
            sin_next = Wave( sin_current , sin_previous );
            cos_next = Wave( cos_current , cos_previous );
        end
    end
    
    
    
   function logic signed [11:0] Wave(logic signed [12:0] a,logic signed [12:0] b);
      
        logic signed [12:0]  next_value;
        logic signed [11:0]  coeficient;
        coeficient = 12'(int'(coef * (2**11)));
        
        next_value = Add( 2* Multiply(a,coeficient ), (-1)*b);
  
        return 12'(next_value);
  
    endfunction
    
    function logic signed [11:0]  Add ( input logic signed [11:0] a, logic signed [11:0] b);
        
        logic signed [12:0] a_extended; 
        logic signed [12:0] b_extended;
            
        a_extended = 13'(a);
        b_extended = 13'(b);    
            
        return 12'(a_extended+b_extended);
    endfunction
    
    function logic signed [11:0] Multiply ( input logic signed [11:0] a, logic signed [11:0] b);
        logic signed [25:0] a_extended; 
        logic signed [25:0] b_extended;
       
            a_extended = 25'(a);
            b_extended = 25'(b);
        return 12'(a_extended*b_extended / (2**11));
        
    endfunction
 
endmodule

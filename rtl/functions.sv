`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.08.2023 09:06:35
// Design Name: Jakub Zaj�c
// Module Name: functions
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


module functions #(parameter SAMPLES = 80) (
    input logic clk,
    input logic rst,
    input reg [11:0] data [0:79],
    output logic [11:0] average,
    output logic [11:0] min,
    output logic [11:0] max
    );
   
   
/*
logic [11:0] sum;
logic [11:0] minimun;
logic [11:0] maximum;

assign average = Sum( data ) / SAMPLES;
assign min = Minimum( data );
assign max = Maximum( data );
*/
logic [11:0] average_nxt, min_nxt, max_nxt;

always_ff @(posedge clk) begin
    if(rst) begin
        average <= 'd0;
        min <= 'd0;
        max <= 'd0; 
    end
    else begin
        average <= average_nxt;
        min <= min_nxt;
        max <= max_nxt;
    end
    
end

always_comb begin
        average_nxt <= Sum( data ) / SAMPLES;
        min_nxt <= Minimum( data );
        max_nxt <= Maximum( data );
end


function logic [11:0] Sum(logic [11:0] data [79:0]);
        logic [11:0] sum;
        
        sum = 'b0;
        for(int i = 0; i<SAMPLES; i++) begin
            sum += data[i];
        end
        
        return sum;
endfunction

function logic [11:0] Minimum(logic [11:0] data [79:0]);
        logic [11:0] minimum;
        
        minimum = 'b0;
        for(int i = 0; i<SAMPLES; i++) begin
            if(data[i] < minimum) 
                minimum = data[i];
       end
        
        return minimum;
endfunction

function logic [11:0] Maximum(logic [11:0] data [79:0]);
        logic [11:0] maximum;
        
        maximum = data[0];
        for(int i = 1; i<SAMPLES; i++) begin
            if(data[i] > maximum) 
                maximum = data[i];
       end
        
        return maximum;
endfunction


/*assign average = data.sum() ;
assign min = data.min();
assign max = data.max();*/


endmodule

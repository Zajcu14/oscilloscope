`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.08.2023 09:06:35
// Design Name: 
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


module functions #(parameter SAMPLES = 79) (
    input logic clk,
    input logic rst,
    input logic [11:0] data [79:0],
    logic [11:0] average,
    logic [11:0] min,
    logic [11:0] max
    );
   
   
   
/*logic [11:0] sum;
logic [11:0] minimun;
logic [11:0] maximum;*/

assign average = Sum( data ) / SAMPLES;
assign min = Minimum( data );
assign max = Maximum( data );



/*always_ff @(posedge clk) begin
    if(rst) begin
        sum <= 'd0;
        minimun <= 'd0;
        maximum <= 'd0; 
    end
    else begin
        sum <= 'd0;
        minimun <= 'd0;
        maximum <= 'd0; 
    end
    
end*/

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

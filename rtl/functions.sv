`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.08.2023 09:06:35
// Design Name: Jakub Zaj¹c
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


module functions #(parameter SAMPLES = 512) (
    input logic clk,
    input logic rst,
    input reg [11:0] data [0:511],
    //output logic [11:0] average,
    //output logic  minus_average,
    output logic [11:0] Vsk,
    output logic [11:0] min,
    output logic [11:0] max
    );
 localparam GND = 12'd2048;
 localparam MAX_VALUE = 12'd4054;
   
/*
logic [11:0] sum;
logic [11:0] minimun;
logic [11:0] maximum;

assign average = Sum( data ) / SAMPLES;
assign min = Minimum( data );
assign max = Maximum( data );
*/

//logic [11:0] average_1; 
logic [11:0] min_nxt, max_nxt, min_delay, max_delay, Vsk_delay ;
logic [11:0] counter, counter_nxt;
logic [22:0]  sum_sk; //max sum = 256* max_one_sample(4054)
logic [26:0] counter_delay;
//logic [20:0]  sum; //max sum = 256* max_one_sample(4054)
always_ff @(posedge clk) begin
    if(rst) begin
       // average  <= 'd0;
        min      <= 'd0;
        min_nxt  <= 'd0;
        max      <= 'd0; 
        max_nxt  <= 'd0; 
        Vsk      <= 'd0;
        counter  <= 'd0;
        counter_delay <= 'd0;
        //sum      <= 'd0;
       // average_1 <= 'd0;
       // minus_average <= 'd0;
        sum_sk   <= 'd0;
        
        min_delay      <= 'd0;
        max_delay      <= 'd0; 
        Vsk_delay      <= 'd0;
    end
    else begin
        counter_delay <= (counter_delay >= 100000000)? 27'd0 :  counter_delay + 1;
        counter <= (counter == SAMPLES)? 12'd0 :  counter + 1;
        if(counter_delay >= 100000000)begin
        min <= min_delay;
        max <= max_delay; 
        Vsk <= Vsk_delay;
        end
        
       /* //AVERAGE
        if(counter == SAMPLES)begin
            average_1 <= (sum / SAMPLES);
            sum <= 'd0;
        end else begin
            sum <= sum + data[counter];
        end
        
        if (average_1 >= GND)begin
            average <= average_1;
            minus_average <= 1'b0;
         end else begin 
            average <= GND - average_1;
            minus_average <= 1'b1;
         end
         */
         /////////////////////////////////////////////////
         //Vsk
         if(counter == SAMPLES)begin
             Vsk_delay <= (sum_sk / SAMPLES);
            sum_sk <= 'd0;
        end else if (data[counter] >= GND)begin
            sum_sk <= (sum_sk + data[counter]) - GND;
        end else begin
            sum_sk <= (sum_sk + GND) - data[counter];
        end
        //////////////////////////////////////////////////
        //MIN
        if(counter == SAMPLES)begin
            min_delay <= GND -  min_nxt;
            min_nxt <= MAX_VALUE;
        end else if(data[counter] <= min_nxt)begin
            min_nxt <= data[counter];
            min_delay <=  min_delay;
        end
        //////////////////////////////////////////////////
        //MAX
        if(counter == SAMPLES)begin       
            max_delay <= max_nxt - GND;
            max_nxt <= 'd0;
        end else if(data[counter] >= max_nxt)begin
            max_nxt <= data[counter];
            max_delay <= max_delay;
            
        end
            
    end
    
end
endmodule
